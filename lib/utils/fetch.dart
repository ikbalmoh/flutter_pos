import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:validators/validators.dart';

final GetStorage box = GetStorage();

Dio fetch({bool ignoreBaseUrl = false}) {
  Dio dio = Dio();

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
    if (kDebugMode) {
      print(
          'REQUEST[${options.method}]\n => PATH: ${options.path}\n => DATA: ${options.data}');
    }

    String? token = box.read('token');
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    // options.followRedirects = false;
    // options.validateStatus = (status) => status != null && status < 500;

    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      print(
          'RESPONSE[${response.statusCode}]\n => PATH: ${response.requestOptions.path}\n => DATA: ${response.data}');
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
      err.response?.data = {'message': 'Tidak dapat terhubung ke server'};
    }
    if (kDebugMode) {
      print(
          'ERROR[${err.response?.statusCode}] \n => JSON: $json\n=> PATH: ${err.requestOptions.path}\n => DATA: $originalData');
    }

    if (err.response?.statusCode == 401) {
      // Sign out
    }

    super.onError(err, handler);
  }
}
