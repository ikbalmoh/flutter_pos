import 'package:flutter/services.dart';
import 'package:selleri/utils/app_alert.dart';

class Helpers {
  static void copy(String text, {String? message}) {
    Clipboard.setData(ClipboardData(text: text));
    if (message != null) {
      AppAlert.toast(message);
    }
  }

  double ceilToNearestIDR(double amount) {
    if (amount % 1000 == 0) return amount; // Already a multiple of 1000

    double remainder = amount % 1000;

    if (remainder <= 500) {
      return amount - remainder + 500; // Round up to nearest 500
    } else {
      return amount - remainder + 1000; // Round up to nearest 1000
    }
  }
}
