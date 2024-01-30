import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide Response;
import 'package:get_storage/get_storage.dart';
import 'package:validators/validators.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final GetStorage box = GetStorage();

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
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['device'] = box.read('deviceId');

    String? accessToken = box.read('access_token');
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    if (kDebugMode) {
      print(
          'REQUEST[${options.method}]\n => HEAEDER: ${options.headers} \n => URI: ${options.uri}\n => DATA: ${options.data}');
    }

    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      print(
          'RESPONSE[${response.statusCode}]\n => URI: ${response.requestOptions.uri}\n => DATA: ${response.data}');
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
      err.response?.data = {'message': 'connection_error'.tr};
    }
    if (kDebugMode) {
      print(
          'ERROR[${err.response?.statusCode}] \n => JSON: $json\n=> URI: ${err.requestOptions.uri}\n => DATA: $originalData');
    }

    if (err.response?.statusCode == 401) {
      // Sign out
    }

    super.onError(err, handler);
  }
}
