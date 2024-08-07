import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:selleri/data/constants/store_key.dart';
import 'package:selleri/data/models/token.dart';
import 'package:validators/validators.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:developer';
import 'package:package_info_plus/package_info_plus.dart';

const storage = FlutterSecureStorage();

Dio fetch({bool ignoreBaseUrl = false}) {
  final baseOption = BaseOptions(
    baseUrl: dotenv.env['HOST']!,
    contentType: Headers.jsonContentType,
    validateStatus: (int? status) => status != null,
  );

  Dio dio = Dio(baseOption);

  dio.interceptors
      .add(CustomInterceptors(dio: dio, ignoreBaseUrl: ignoreBaseUrl));

  return dio;
}

class CustomInterceptors extends Interceptor {
  Dio dio;
  bool ignoreBaseUrl;

  CustomInterceptors({required this.dio, required this.ignoreBaseUrl});

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    String? deviceId = await storage.read(key: StoreKey.device.toString());
    options.headers['device'] = deviceId;

    final packageInfo = await PackageInfo.fromPlatform();
    options.headers['version'] = packageInfo.version;

    // User agent
    options.headers['User-Agent'] = 'okhttp/3.12.1';

    String? tokenString = await storage.read(key: StoreKey.token.toString());
    if (tokenString != null) {
      final Token token = Token.fromJson(json.decode(tokenString));
      options.headers['Authorization'] = 'Bearer ${token.accessToken}';
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
    err.response?.data['msg'] = err.response?.data['msg'] ??
        err.response?.data['message'] ??
        err.message;
    if (kDebugMode) {
      log('ERROR[${err.response?.statusCode}] \n => JSON: $json\n=> URI: ${err.requestOptions.uri}\n => DATA: $originalData');
    }

    if (err.response?.statusCode == 401) {
      // Sign out
    }

    super.onError(err, handler);
  }
}
