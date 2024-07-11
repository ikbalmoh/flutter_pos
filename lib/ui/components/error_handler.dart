import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ErrorHandler extends StatelessWidget {
  const ErrorHandler({super.key, this.error, this.stackTrace, this.onRetry});

  final String? error;
  final String? stackTrace;
  final Function()? onRetry;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          const Icon(
            CupertinoIcons.exclamationmark_circle,
            size: 80,
            color: Colors.red,
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            error ?? 'something_wrong'.tr(),
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Colors.red),
          ),
          const SizedBox(
            height: 10,
          ),
          stackTrace != null
              ? Text(
                  stackTrace.toString(),
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.black54),
                  textAlign: TextAlign.center,
                )
              : Container(),
          const SizedBox(
            height: 10,
          ),
          onRetry != null
              ? TextButton.icon(
                  onPressed: onRetry,
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  icon: const Icon(CupertinoIcons.refresh),
                  label: Text('reload'.tr()))
              : Container()
        ],
      ),
    );
  }
}
