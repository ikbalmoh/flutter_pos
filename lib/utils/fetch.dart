import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/data/constants/store_key.dart';
import 'package:selleri/data/models/outlet.dart';
import 'package:selleri/data/models/token.dart';
import 'package:selleri/providers/auth/auth_provider.dart';
import 'package:validators/validators.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:developer';
import 'package:package_info_plus/package_info_plus.dart';

const storage = FlutterSecureStorage();

Dio fetch() {
  final baseOption = BaseOptions(
    baseUrl: dotenv.env['HOST']!,
    contentType: Headers.jsonContentType,
    validateStatus: (int? status) => status != null,
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
    String? deviceId = await storage.read(key: StoreKey.device.name);
    options.headers['device'] = deviceId;
    options.headers['is-app'] = 1;

    final packageInfo = await PackageInfo.fromPlatform();
    options.headers['version'] = packageInfo.version;

    // User agent
    options.headers['User-Agent'] = 'okhttp/3.12.1';

    String? tokenString = await storage.read(key: StoreKey.token.name);
    if (tokenString != null) {
      final Token token = Token.fromJson(json.decode(tokenString));
      options.headers['Authorization'] = 'Bearer ${token.accessToken}';
    }

    String? outletString = await storage.read(key: StoreKey.outlet.name);
    if (outletString != null) {
      final jsonOutlet = json.decode(outletString);
      final outlet = Outlet.fromJson(jsonOutlet);
      options.headers['outlet'] = outlet.idOutlet;
    }

    if (kDebugMode) {
      log('REQUEST[${options.method}]\n => URI: ${options.uri}\n => DATA: ${options.data}\n => DEVICE: ${options.headers['device']}');
    }

    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      log('RESPONSE[${response.statusCode}]\n => URI: ${response.requestOptions.uri}\n => DATA: ${response.data}');
    }
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
    dynamic originalData = err.response?.data;
    bool json = err.response?.data != null
        ? isJSON(jsonEncode(err.response?.data))
        : false;
    if (!json) {
      err.response?.data = {'msg': 'connection_error'};
    }

    if (kDebugMode) {
      log('ERROR[${err.response?.statusCode}] \n => JSON: $json\n=> URI: ${err.requestOptions.uri}\n => DATA: $originalData');
    }

    if (err.response?.statusCode == 401) {
      // Sign out
      storage.delete(key: StoreKey.token.name);
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
