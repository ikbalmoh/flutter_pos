import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum AlertType { success, error, info }

class AppAlert {
  static void snackbar(
    BuildContext context,
    String title, {
    AlertType alertType = AlertType.info,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    Color backgroundColor = Colors.grey.shade900;

    if (alertType == AlertType.success) {
      backgroundColor = Colors.teal.shade500;
    } else if (alertType == AlertType.error) {
      backgroundColor = Colors.red.shade500;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(title),
        backgroundColor: backgroundColor,
        duration: duration,
        action: action,
      ),
    );
  }

  static void confirm(
    BuildContext context, {
    required String title,
    String? subtitle,
    void Function()? onConfirm,
    String? confirmLabel,
    bool? danger,
  }) {
    final navigator = Navigator.of(context, rootNavigator: true);
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(title),
            content: subtitle != null ? Text(subtitle) : null,
            actionsAlignment: MainAxisAlignment.end,
            actions: [
              TextButton(
                onPressed: () => context.pop(),
                style:
                    TextButton.styleFrom(foregroundColor: Colors.grey.shade600),
                child: Text('cancel'.tr()),
              ),
              TextButton(
                  style: TextButton.styleFrom(
                      foregroundColor:
                          danger != null && danger ? Colors.red : Colors.teal),
                  onPressed: () {
                    if (onConfirm != null) {
                      onConfirm();
                      if (navigator.canPop()) {
                        navigator.pop();
                      }
                    }
                  },
                  child: Text(confirmLabel ?? 'Ok')),
            ],
          );
        });
  }
}
