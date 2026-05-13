import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/shared/exeptions/offline_exeption.dart';
import 'package:selleri/shared/provider/connectivity_status_provider.dart';

class ErrorHandler extends ConsumerWidget {
  const ErrorHandler({super.key, this.error, this.stackTrace, this.onRetry});

  final Object? error;
  final String? stackTrace;
  final Function()? onRetry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOffline = error is OfflineException ||
        ref.read(connectivityStatusProvider) != ConnectivityState.connected;

    final String message = isOffline
        ? 'offline'.tr()
        : (error != null ? error.toString() : 'something_wrong'.tr());

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20).copyWith(top: 80),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Icon(
            isOffline
                ? CupertinoIcons.wifi_slash
                : CupertinoIcons.exclamationmark_circle,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(
            height: 40,
          ),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Colors.grey.shade600),
          ),
          const SizedBox(
            height: 10,
          ),
          isOffline || stackTrace != null
              ? Text(
                  isOffline
                      ? 'no_connections_instruction'.tr()
                      : stackTrace.toString(),
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
