import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class PromotionPolicy extends StatelessWidget {
  const PromotionPolicy({
    super.key,
    required this.policy,
  });

  final bool policy;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          color: policy ? Colors.teal.shade50 : Colors.amber.shade50),
      child: Text(
        policy ? 'can_be_combined'.tr() : 'cannot_be_combined'.tr(),
        style: Theme.of(context)
            .textTheme
            .bodySmall
            ?.copyWith(color: policy ? Colors.teal.shade500 : Colors.amber.shade700),
      ),
    );
  }
}
