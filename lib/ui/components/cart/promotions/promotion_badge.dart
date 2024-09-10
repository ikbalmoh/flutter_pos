import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PromotionBadge extends StatelessWidget {
  const PromotionBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.amber.shade700, width: 0.5),
          color: Colors.amber.shade50,
          borderRadius: BorderRadius.circular(3)),
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            CupertinoIcons.tag_fill,
            size: 12,
            color: Colors.amber.shade700,
          ),
          const SizedBox(width: 5),
          Text(
            'promotions'.tr(),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.brown.shade600,
                ),
          ),
        ],
      ),
    );
  }
}
