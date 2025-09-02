import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/shared/provider/connectivity_status_provider.dart';

class ErrorHandler extends ConsumerWidget {
  const ErrorHandler({super.key, this.error, this.stackTrace, this.onRetry});

  final String? error;
  final String? stackTrace;
  final Function()? onRetry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOffline =
        ref.watch(connectivityStatusProvider) != ConnectivityState.connected;

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
            color: Colors.red.shade300,
          ),
          const SizedBox(
            height: 40,
          ),
          Text(
            isOffline ? 'no_connections'.tr() : error ?? 'something_wrong'.tr(),
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
