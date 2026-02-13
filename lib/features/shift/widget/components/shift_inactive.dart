import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/features/auth/provider/auth_provider.dart';
import 'package:selleri/features/shift/widget/components/open_shift_button.dart';
import 'package:selleri/shared/provider/connectivity_status_provider.dart';

class ShiftInactive extends ConsumerWidget {
  const ShiftInactive({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextTheme textTheme = Theme.of(context).textTheme;
    final authState = ref.watch(authProvider).value;
    final isOffline =
        ref.watch(connectivityStatusProvider) == ConnectivityState.disconnected;

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isOffline ? Icons.wifi_off : Icons.store,
            size: 60,
            color: Colors.blueGrey.shade300,
          ),
          const SizedBox(
            height: 25,
          ),
          Text(
            '${'hello'.tr()}, ${authState is Authenticated ? authState.user.user.name : ''}!',
            style: textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            isOffline
                ? 'connect_internet_to_open_shift'.tr()
                : 'please_open_shift'.tr(),
            textAlign: TextAlign.center,
            style:
                textTheme.titleSmall?.copyWith(color: Colors.blueGrey.shade700),
          ),
          const SizedBox(
            height: 25,
          ),
          const OpenShiftButton()
        ],
      ),
    );
  }
}
