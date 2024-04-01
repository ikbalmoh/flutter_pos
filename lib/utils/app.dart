import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum AlertType { success, error, info }

class App {
  static void showAlert(String title, String message,
      {AlertType alertType = AlertType.error}) {
    Color backgroundColor = Colors.red.shade50;
    Color colorText = Colors.red.shade800;

    if (alertType == AlertType.success) {
      backgroundColor = Colors.teal.shade50;
      colorText = Colors.teal.shade800;
    }

    Get.snackbar(
      title,
      message,
      backgroundColor: backgroundColor,
      colorText: colorText,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    );
  }

  static void showSnackbar(
    String title,
    String message, {
    AlertType alertType = AlertType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    Color backgroundColor = Colors.grey.shade900;

    if (alertType == AlertType.success) {
      backgroundColor = Colors.teal.shade500;
    } else if (alertType == AlertType.error) {
      backgroundColor = Colors.red.shade500;
    }

    Get.showSnackbar(
      GetSnackBar(
        title: title,
        message: message,
        duration: duration,
        backgroundColor: backgroundColor,
      ),
    );
  }

  static void showConfirmDialog({
    required String title,
    String? subtitle,
    void Function()? onConfirm,
    String? confirmLabel,
    bool? danger
  }) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        title: Text(title),
        content: subtitle != null ? Text(subtitle) : null,
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            style: TextButton.styleFrom(foregroundColor: Colors.grey.shade600),
            child: Text('cancel'.tr),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: danger != null && danger ? Colors.red : Colors.teal),
              onPressed: onConfirm, child: Text(confirmLabel ?? 'continue'.tr)),
        ],
      ),
    );
  }
}
