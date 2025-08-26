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
            padding: const EdgeInsets.symmetric(vertical: 5),
            color: Colors.red,
            child: Center(
              child: Text(
                'no_connections'.tr(),
                style: Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(color: Colors.white),
              ),
            ),
          )
        : Container();
  }
}
