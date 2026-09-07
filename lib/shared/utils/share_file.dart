import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:screenshot/screenshot.dart';
import 'package:selleri/shared/utils/file_download.dart';
import 'package:selleri/shared/utils/formater.dart';
import 'package:share_plus/share_plus.dart';

class ShareFile {
  static Future<void> shareReceipt(
    BuildContext context, {
    required GlobalKey containerKey,
    required String title,
    required ScreenshotController screenshotController,
    required Function onReadyToShare,
    required Function(ShareResultStatus?) onShared,
  }) async {
    String timestamp = DateTimeFormater.dateToString(DateTime.now(),
        format: 'ddMMyyyy-HHmmss');

    final shareButtonBox = context.findRenderObject() as RenderBox?;

    final path = await FileDownload().localPath;
    final imageBytes = await screenshotController.capture();
    final fileName = '${title.replaceAll(' ', '-')}-$timestamp.png';
    final filePath = '$path/$fileName';
    await File(filePath).writeAsBytes(imageBytes!.toList());
    final xFile = XFile(filePath);
    onReadyToShare();
    final shareResult = await SharePlus.instance.share(ShareParams(
      files: [xFile],
      subject: title,
      sharePositionOrigin:
          shareButtonBox!.localToGlobal(Offset.zero) & shareButtonBox.size,
    ));
    onShared(shareResult.status);
  }
}
