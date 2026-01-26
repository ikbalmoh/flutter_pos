import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/shared/provider/connectivity_status_provider.dart';

class ConnectionBanerWidget extends ConsumerWidget {
  const ConnectionBanerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(connectivityStatusProvider) ==
            ConnectivityState.disconnected
        ? Container(
            width: double.maxFinite,
            height: 30,
            padding: const EdgeInsets.symmetric(vertical: 5),
            color: Colors.red.shade500.withValues(alpha: 0.2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 10,
              children: [
                Icon(
                  Icons.cloud_off_rounded,
                  color: Colors.red,
                  size: 14,
                ),
                Text(
                  'offline'.tr(),
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium
                      ?.copyWith(color: Colors.red),
                ),
              ],
            ),
          )
        : Container();
  }
}
