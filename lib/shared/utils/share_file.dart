import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:pdf/pdf.dart';
import 'package:screenshot/screenshot.dart';
import 'package:selleri/shared/utils/file_download.dart';
import 'package:pdf/widgets.dart' as pw;
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
    final containerBox =
        containerKey.currentContext!.findRenderObject() as RenderBox?;

    final Size contentSize = containerBox!.size;

    final path = await FileDownload().localPath;
    final imageBytes = await screenshotController.capture();
    pw.Document pdf = pw.Document(title: title);
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat(contentSize.width, contentSize.height),
        build: (context) {
          return pw.Center(child: pw.Image(pw.MemoryImage(imageBytes!)));
        },
      ),
    );
    final fileName = '${title.replaceAll(' ', '-')}-$timestamp.pdf';
    final filePath = '$path/$fileName';
    await File(filePath).writeAsBytes(await pdf.save());
    final xFile = XFile(filePath);
    onReadyToShare();
    final shareResult = await Share.shareXFiles(
      [xFile],
      subject: title,
      sharePositionOrigin:
          shareButtonBox!.localToGlobal(Offset.zero) & shareButtonBox.size,
    );
    onShared(onShared(shareResult.status));
  }
}
