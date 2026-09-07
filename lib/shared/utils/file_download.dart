import 'dart:developer';

import 'package:dio/dio.dart';

import 'fetch.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'package:open_file/open_file.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:selleri/shared/constants/store_key.dart';
import 'package:selleri/shared/model/app_config.dart' as config_model;

class FileDownload {
  Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<String> download(String urlPath,
      {required String fileName,
      Map<String, dynamic>? params,
      Function(double progress)? callback,
      Options? options,
      bool? openAfterDownload}) async {
    try {
      String savePath = await _getFilePath(fileName);

      const storage = FlutterSecureStorage();
      final localData = await storage.read(key: StoreKey.appConfig.name);
      config_model.AppConfig? config;
      if (localData != null) {
        config = config_model.AppConfig.fromJson(jsonDecode(localData));
      }

      log('Download: url => $urlPath\n fileName => $savePath');

      await fetch(config).download(urlPath, savePath,
          queryParameters: params,
          options: options, onReceiveProgress: (receive, total) {
        log('downloading: $receive/$total');
        if (callback != null) {
          callback((receive / total) * 100);
        }
      });
      if (openAfterDownload == true) {
        log('opening fileL $savePath');
        OpenFile.open(savePath);
      }
      return savePath;
    } on DioException catch (e) {
      throw e.message!;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> _getFilePath(String uniqueFileName) async {
    String path = '';

    Directory? dir = Platform.isAndroid
        ? await getDownloadsDirectory()
        : await getApplicationDocumentsDirectory();

    dir = dir ?? await getApplicationCacheDirectory();

    path = '${dir.path}/$uniqueFileName';

    return path;
  }
}
