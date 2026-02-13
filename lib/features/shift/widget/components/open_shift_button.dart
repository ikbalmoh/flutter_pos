import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/features/shift/widget/components/open_shift.dart';
import 'package:selleri/shared/provider/connectivity_status_provider.dart';

class OpenShiftButton extends ConsumerWidget {
  const OpenShiftButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOffline =
        ref.watch(connectivityStatusProvider) == ConnectivityState.disconnected;

    void showOpenShift() {
      showDialog(
          context: context,
          builder: (context) {
            return const OpenShift();
          });
    }

    if (isOffline) {
      return Container();
    }

    return TextButton.icon(
      style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
      onPressed: showOpenShift,
      label: Text('open_shift'.tr()),
      icon: Icon(
        CupertinoIcons.list_bullet_below_rectangle,
      ),
    );
  }
}
