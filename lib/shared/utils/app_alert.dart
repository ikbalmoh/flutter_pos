import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum AlertType { success, error, info }

class AppAlert {
  static final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static void snackbar(
    String title, {
    AlertType alertType = AlertType.info,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    final messenger = rootScaffoldMessengerKey.currentState;
    if (messenger == null || messenger.mounted == false) {
      // Fallback to toast if no scaffold is available
      toast(title);
      return;
    }

    try {
      Color backgroundColor = Colors.grey.shade900;
      Color textColor = Colors.white;

      if (alertType == AlertType.success) {
        backgroundColor = Colors.white;
        textColor = Colors.teal;
      } else if (alertType == AlertType.error) {
        backgroundColor = Colors.red.shade500;
      }

      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            title,
            style: TextStyle(color: textColor),
          ),
          backgroundColor: backgroundColor,
          duration: duration,
          action: action,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      // Fallback to toast if showing snackbar fails
      toast(title);
    }
  }

  static void toast(
    String message, {
    Color? backgroundColor,
    Color? textColor,
    Toast? toastLength = Toast.LENGTH_LONG,
  }) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: toastLength,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: backgroundColor ?? Colors.black.withValues(alpha: 0.8),
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
    bool shouldPop = true,
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
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: danger == true ? Colors.red : Colors.black),
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
                          backgroundColor: danger != null && danger
                              ? Colors.red.shade50
                              : Colors.teal.shade50,
                          foregroundColor: danger != null && danger
                              ? Colors.red
                              : Colors.teal),
                      onPressed: () {
                        if (onConfirm != null) {
                          onConfirm();
                          if (shouldPop && navigator.canPop()) {
                            navigator.pop();
                          }
                        }
                      },
                      child: Text(confirmLabel ?? 'yes'.tr()),
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }
}
