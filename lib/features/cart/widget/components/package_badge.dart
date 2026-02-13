import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PackageBadge extends ConsumerWidget {
  const PackageBadge({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.blue.shade400, width: 0.5),
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(3)),
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            CupertinoIcons.gift,
            size: 12,
            color: Colors.blue.shade600,
          ),
          const SizedBox(width: 5),
          Text(
            'package'.tr(),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.blue.shade600,
                ),
          ),
        ],
      ),
    );
  }
}
