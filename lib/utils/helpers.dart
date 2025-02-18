import 'package:flutter/services.dart';
import 'package:selleri/utils/app_alert.dart';

class Helpers {
  static void copy(String text, {String? message}) {
    Clipboard.setData(ClipboardData(text: text));
    if (message != null) {
      AppAlert.toast(message);
    }
  }
}
