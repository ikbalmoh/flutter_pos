import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fluttertoast/fluttertoast.dart';

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

  static void toast(String message,
      {Color? backgroundColor, Color? textColor}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: backgroundColor ?? Colors.black.withOpacity(0.8),
      textColor: textColor ?? Colors.white,
      fontSize: 16.0,
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
    showModalBottomSheet(
        backgroundColor: Colors.white,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
              top: 25,
              left: 20,
              right: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 15,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                SizedBox(height: subtitle != null ? 20 : 0),
                subtitle != null
                    ? Text(
                        subtitle,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.grey.shade700),
                      )
                    : Container(),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => context.pop(),
                      style: TextButton.styleFrom(
                          foregroundColor: Colors.grey.shade600),
                      child: Text('cancel'.tr()),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                          foregroundColor: danger != null && danger
                              ? Colors.red
                              : Colors.teal),
                      onPressed: () {
                        if (onConfirm != null) {
                          onConfirm();
                          if (navigator.canPop()) {
                            navigator.pop();
                          }
                        }
                      },
                      child: Text(confirmLabel ?? 'Ok'),
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }
}
