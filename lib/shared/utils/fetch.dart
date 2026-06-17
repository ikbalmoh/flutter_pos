import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/shared/constants/store_key.dart';
import 'package:selleri/features/outlet/model/outlet.dart';
import 'package:selleri/features/auth/model/token.dart';
import 'package:selleri/features/auth/provider/auth_provider.dart';
import 'package:selleri/features/auth/repository/token_repository.dart';
import 'package:selleri/shared/exeptions/offline_exeption.dart';
import 'package:selleri/shared/provider/connectivity_status_provider.dart';
import 'package:selleri/shared/router/api_url.dart';
import 'package:validators/validators.dart';
import 'package:selleri/shared/constants/app_config.dart';
import 'dart:developer';
import 'package:package_info_plus/package_info_plus.dart';

const storage = FlutterSecureStorage();

Dio fetch() {
  final baseOption = BaseOptions(
    baseUrl: AppConfig.baseUrl,
    contentType: Headers.jsonContentType,
    validateStatus: (int? status) => status != null,
    connectTimeout: Duration(minutes: 10),
    receiveTimeout: Duration(minutes: 10),
  );

  Dio dio = Dio(baseOption);

  dio.interceptors.add(CustomInterceptors(dio: dio));

  return dio;
}

class CustomInterceptors extends Interceptor {
  final Dio dio;
  Function? onSessionExpired;

  /// A bare Dio instance used exclusively for the refresh-token call so that
  /// it does not go through CustomInterceptors and cause an infinite loop.
  late final Dio _refreshDio = Dio(
    BaseOptions(
      baseUrl: AppConfig.baseUrl,
      contentType: Headers.jsonContentType,
      validateStatus: (status) => status != null,
    ),
  );

  bool _isRefreshing = false;

  CustomInterceptors({
    required this.dio,
    this.onSessionExpired,
  });

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    options.receiveTimeout = Duration(seconds: 120);

    // Read stored token, proactively refresh if expiring soon, then build
    // all request headers via the shared _buildHeaders helper.
    Token? token;
    final tokenString = await storage.read(key: StoreKey.token.name);
    if (tokenString != null) {
      token = Token.fromJson(json.decode(tokenString));
      log('[TOKEN] Expiring at ${token.expiresAt} - ${token.isExpiringSoon() ? 'EXPIRING' : 'VALID'}');
      final isAuthEndpoint = options.path == ApiUrl.auth;
      if (!isAuthEndpoint && token.isExpiringSoon() && !_isRefreshing) {
        final refreshed = await _tryRefreshToken(token);
        log('[TOKEN] New token will expire at ${refreshed?.expiresAt}');
        if (refreshed != null) token = refreshed;
      }
    }

    final headers = await _buildHeaders(token);
    options.headers.addAll(headers);

    return super.onRequest(options, handler);
  }

  /// Single source of truth for all request headers.
  /// Used by both [onRequest] (main Dio) and [_tryRefreshToken] ([_refreshDio]
  /// which bypasses the interceptor chain).
  /// Pass [token] as null when no session exists.
  Future<Map<String, dynamic>> _buildHeaders(Token? token) async {
    final headers = <String, dynamic>{
      'is-app': 1,
      'User-Agent': 'okhttp/3.12.1',
    };

    final deviceId = await storage.read(key: StoreKey.device.name);
    if (deviceId != null) headers['device'] = deviceId;

    final packageInfo = await PackageInfo.fromPlatform();
    headers['version'] = packageInfo.version;

    if (token != null) {
      headers['Authorization'] = 'Bearer ${token.accessToken}';
    }

    final outletString = await storage.read(key: StoreKey.outlet.name);
    if (outletString != null) {
      final jsonOutlet = json.decode(outletString);
      final outlet = Outlet.fromJson(jsonOutlet);
      headers['outlet'] = outlet.idOutlet;
    }

    return headers;
  }

  /// Calls POST /refresh-token and persists the new token.
  /// Returns the new [Token] on success, or null on any error.
  Future<Token?> _tryRefreshToken(Token currentToken) async {
    try {
      final headers = await _buildHeaders(currentToken);
      final response = await _refreshDio.post(
        ApiUrl.refreshToken,
        data: {'refresh_token': currentToken.refreshToken},
        options: Options(headers: headers),
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        final newToken = Token.fromJson(response.data);
        final tokenToSave = await TokenRepository().saveToken(newToken);
        log('Token refreshed successfully (expires at ${tokenToSave.expiresAt})');
        return tokenToSave;
      }
    } catch (e) {
      log('Token refresh failed: $e');
    }
    return null;
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final status = response.statusCode;
    final isValid = status != null && status >= 200 && status < 300;
    if (!isValid) {
      throw DioException.badResponse(
        statusCode: status!,
        requestOptions: response.requestOptions,
        response: response,
      );
    }
    super.onResponse(response, handler);
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    bool isJson = err.response?.data != null
        ? isJSON(jsonEncode(err.response?.data))
        : false;
    if (!isJson) {
      err.response?.data = {'msg': 'connection_error'};
    }

    String message = err.message ?? 'Unexpected Error Occured!';
    if (err.response?.data is String) {
      message = err.response?.data;
    } else if (err.response?.data['msg'] != null) {
      message = err.response?.data?['msg'];
    } else if (err.response?.data['message'] != null) {
      message = err.response?.data?['message'];
    } else if (err.response?.statusCode == 422) {
      message = 'Invalid data. Please check your input and try again.';
    }
    err = err.copyWith(message: message);

    int? statusCode = err.response?.statusCode;

    if (statusCode != null && ![401, 500].contains(statusCode)) {
      FirebaseCrashlytics.instance.recordError(
        err.message,
        err.stackTrace,
        fatal: false,
      );
    }

    final isAuthEndpoint = err.requestOptions.path == ApiUrl.auth;
    if (statusCode == 401 && !_isRefreshing && !isAuthEndpoint) {
      _isRefreshing = true;
      final tokenString = await storage.read(key: StoreKey.token.name);
      if (tokenString != null) {
        final oldToken = Token.fromJson(json.decode(tokenString));
        final newToken = await _tryRefreshToken(oldToken);
        if (newToken != null) {
          // Retry the original request with the refreshed access token.
          final retryOptions = err.requestOptions
            ..headers['Authorization'] = 'Bearer ${newToken.accessToken}';
          try {
            final retryResponse = await dio.fetch(retryOptions);
            _isRefreshing = false;
            return handler.resolve(retryResponse);
          } catch (_) {
            // Retry failed – fall through to sign-out below.
          }
        }
      }

      _isRefreshing = false;
      // Refresh failed or no token stored – sign out.
      await storage.delete(key: StoreKey.token.name);
      log('Session expired, signing out.');
      if (onSessionExpired != null) {
        onSessionExpired!();
      }
    }

    super.onError(err, handler);
  }
}

final apiProvider = Provider<Dio>((ref) {
  final auth = ref.read(authProvider.notifier);
  final Dio dio = fetch();

  ref.onDispose(dio.close);

  final isOffline =
      ref.read(connectivityStatusProvider) == ConnectivityState.disconnected;

  if (isOffline) {
    throw OfflineException('no_connections'.tr());
  }

  return dio
    ..interceptors.addAll([
      CustomInterceptors(
        dio: dio,
        onSessionExpired: () => auth.logout(skipLogout: true),
      ),
    ]);
});
