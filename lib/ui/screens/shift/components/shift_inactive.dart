import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/providers/auth/auth_provider.dart';

class ShiftInactive extends ConsumerWidget {
  const ShiftInactive({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      color: Colors.red.shade100,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Hi ${(ref.watch(authNotifierProvider).value as Authenticated).user.user.name}!',
            style: textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          Chip(
            backgroundColor: Colors.red.shade300,
            labelStyle: textTheme.labelSmall?.copyWith(color: Colors.white),
            side: BorderSide.none,
            padding: const EdgeInsets.all(3),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            label: Text(
              'shift_inactive'.tr(),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }
}
