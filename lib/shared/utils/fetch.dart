import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/features/auth/repository/token_repository.dart';
import 'package:selleri/shared/constants/store_key.dart';
import 'package:selleri/features/outlet/model/outlet.dart';
import 'package:selleri/features/auth/model/token.dart';
import 'package:selleri/features/auth/provider/auth_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:validators/validators.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:developer';
import 'package:package_info_plus/package_info_plus.dart';

Dio fetch() {
  final baseOption = BaseOptions(
    baseUrl: dotenv.env['HOST']!,
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

  CustomInterceptors({
    required this.dio,
    this.onSessionExpired,
  });

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? deviceId = prefs.getString(StoreKey.device.name);
    options.headers['device'] = deviceId;
    options.headers['is-app'] = 1;

    final packageInfo = await PackageInfo.fromPlatform();
    options.headers['version'] = packageInfo.version;

    // User agent
    options.headers['User-Agent'] = 'okhttp/3.12.1';

    String? tokenString = prefs.getString(StoreKey.token.name);
    if (tokenString != null) {
      final Token token = Token.fromJson(json.decode(tokenString));
      options.headers['Authorization'] = 'Bearer ${token.accessToken}';
    }

    String? outletString = prefs.getString(StoreKey.outlet.name);
    if (outletString != null) {
      final jsonOutlet = json.decode(outletString);
      final outlet = Outlet.fromJson(jsonOutlet);
      options.headers['outlet'] = outlet.idOutlet;
    }

    return super.onRequest(options, handler);
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
    bool json = err.response?.data != null
        ? isJSON(jsonEncode(err.response?.data))
        : false;
    if (!json) {
      err.response?.data = {'msg': 'connection_error'};
    }

    if (err.response?.statusCode == 401) {
      // Sign out
      await TokenRepository().removeToken();
      log('Expired Session!');
      if (onSessionExpired != null) {
        onSessionExpired!();
      }
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

    super.onError(err, handler);
  }
}

final apiProvider = Provider<Dio>((ref) {
  final auth = ref.read(authProvider.notifier);
  final Dio dio = fetch();
  ref.onDispose(dio.close);
  return dio
    ..interceptors.addAll([
      CustomInterceptors(
          dio: dio, onSessionExpired: () => auth.logout(skipLogout: true)),
    ]);
});
