import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/shared/constants/store_key.dart';
import 'package:selleri/features/outlet/model/outlet.dart';
import 'package:selleri/features/auth/model/token.dart';
import 'package:selleri/features/auth/provider/auth_provider.dart';
import 'package:selleri/features/auth/repository/token_repository.dart';
import 'package:selleri/shared/exeptions/offline_exeption.dart';
import 'package:selleri/shared/provider/app_config_provider.dart';
import 'package:selleri/shared/model/app_config.dart' as config_model;
import 'package:selleri/shared/provider/connectivity_status_provider.dart';
import 'package:selleri/shared/router/api_url.dart';
import 'package:validators/validators.dart';
import 'dart:developer';
import 'package:package_info_plus/package_info_plus.dart';

const storage = FlutterSecureStorage();

Dio fetch(config_model.AppConfig? config) {
  final baseOption = BaseOptions(
    baseUrl: config?.baseUrl ?? '',
    contentType: Headers.jsonContentType,
    connectTimeout: Duration(minutes: 10),
    receiveTimeout: Duration(minutes: 10),
  );

  Dio dio = Dio(baseOption);

  return dio;
}

class CustomInterceptors extends QueuedInterceptor {
  final Dio dio;
  Function? onSessionExpired;
  config_model.AppConfig? config;

  /// A bare Dio instance used exclusively for the refresh-token call so that
  /// it does not go through CustomInterceptors and cause an infinite loop.
  late final Dio _refreshDio = Dio(
    BaseOptions(
      baseUrl: config?.baseUrl ?? '',
      contentType: Headers.jsonContentType,
      validateStatus: (status) => status != null,
    ),
  );

  bool _isRefreshing = false;

  CustomInterceptors({
    required this.dio,
    this.onSessionExpired,
    this.config,
  });

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    options.receiveTimeout = Duration(seconds: 120);

    // Read stored token, proactively refresh if expiring soon, then build
    // all request headers via the shared _buildHeaders helper.
    Token? token = await TokenRepository().fetchToken();

    if (token != null) {
      final isAuthEndpoint = options.path == ApiUrl.auth;
      if (!isAuthEndpoint && token.isExpiringSoon() && !_isRefreshing) {
        final refreshed = await _tryRefreshToken(token);
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
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    log('request error: $err');

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

    // Record all API errors to Analytics & Crashlytics
    FirebaseAnalytics.instance.logEvent(
      name: 'api_error',
      parameters: {
        'status_code': statusCode?.toString() ?? 'unknown',
        'url': err.requestOptions.path,
        'method': err.requestOptions.method,
        'message': (message.length > 100 ? message.substring(0, 100) : message),
      },
    );
    FirebaseCrashlytics.instance.recordError(
      {
        'statusCode': statusCode,
        'message': err.message,
        'url': err.requestOptions.path,
        'method': err.requestOptions.method,
        'request': err.requestOptions.data,
        'headers': err.requestOptions.headers,
        'response': err.response?.data,
      },
      err.stackTrace,
      reason:
          'API Error: ${err.requestOptions.method} ${err.requestOptions.path} [$statusCode]',
      fatal: false,
      printDetails: true,
    );

    final isAuthEndpoint = err.requestOptions.path == ApiUrl.auth;
    log('statusCode: $statusCode, isRefreshing: $_isRefreshing, isAuthEndpoint: $isAuthEndpoint');
    if (statusCode == 401 && !isAuthEndpoint) {
      final tokenString = await storage.read(key: StoreKey.token.name);
      if (tokenString != null) {
        final currentToken = Token.fromJson(json.decode(tokenString));
        final currentTokenHeader = 'Bearer ${currentToken.accessToken}';
        final failedTokenHeader = err.requestOptions.headers['Authorization'];

        if (failedTokenHeader != null && failedTokenHeader != currentTokenHeader) {
          // Token was already refreshed by a previous request in the queue.
          // Retry the request with the new token immediately.
          log('Token already refreshed, retrying request immediately.');
          final retryOptions = err.requestOptions
            ..headers['Authorization'] = currentTokenHeader;
          try {
            final retryResponse = await dio.fetch(retryOptions);
            return handler.resolve(retryResponse);
          } catch (_) {
            // Retry failed, fall through to sign-out
          }
        } else if (!_isRefreshing) {
          _isRefreshing = true;
          final newToken = await _tryRefreshToken(currentToken);
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
          _isRefreshing = false;
        }
      }

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
  final config = ref.watch(appConfigProvider).requireValue;
  
  final Dio dio = fetch(config);
 
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
        config: config,
        onSessionExpired: () => auth.logout(skipLogout: true),
      ),
    ]);
});
