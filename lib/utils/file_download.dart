import 'dart:developer';

import 'package:dio/dio.dart';

import 'fetch.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';

class FileDownload {
  Future<String> download(String urlPath,
      {required String fileName,
      Map<String, dynamic>? params,
      Function(double progress)? callback,
      bool? openAfterDownload}) async {
    try {
      String savePath = await _getFilePath(fileName);

      log('Download: url => $urlPath\n fileName => $savePath');

      await fetch().download(urlPath, savePath, queryParameters: params,
          onReceiveProgress: (receive, total) {
        log('downloading: $receive/$total');
        if (callback != null) {
          callback((receive / total) * 100);
        }
      });
      if (openAfterDownload == true) {
        OpenFile.open(savePath);
      }
      return savePath;
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? e.message;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> _getFilePath(String uniqueFileName) async {
    String path = '';

    Directory? dir = await getDownloadsDirectory();

    dir ??= await getApplicationCacheDirectory();

    path = '${dir.path}/$uniqueFileName';

    return path;
  }
}
