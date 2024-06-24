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
      // color: Colors.red.shade100,
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
            'Hi, ${(ref.watch(authNotifierProvider).value as Authenticated).user.user.name}!',
            style: textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            'shift_inactive'.tr(),
            textAlign: TextAlign.center,
            style:
                textTheme.titleSmall?.copyWith(color: Colors.blueGrey.shade700),
          ),
          const SizedBox(
            height: 25,
          ),
          SizedBox(
            width: 160,
            height: 45,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25))),
              onPressed: () {},
              child: Text('open_shift'.tr()),
            ),
          ),
        ],
      ),
    );
  }
}
