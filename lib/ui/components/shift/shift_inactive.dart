import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/providers/auth/auth_provider.dart';
import 'package:selleri/ui/components/shift/open_shift_button.dart';

class ShiftInactive extends ConsumerWidget {
  const ShiftInactive({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextTheme textTheme = Theme.of(context).textTheme;
    final authState = ref.watch(authNotifierProvider).value;
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.store,
            size: 60,
            color: Colors.blueGrey.shade300,
          ),
          const SizedBox(
            height: 25,
          ),
          Text(
            'Hi, ${authState is Authenticated ? authState.user.user.name : ''}!',
            style: textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            'please_open_shift'.tr(),
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
