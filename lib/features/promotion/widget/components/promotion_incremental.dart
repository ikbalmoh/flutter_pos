import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class PromotionIncremental extends StatelessWidget {
  const PromotionIncremental({
    super.key,
    required this.incremental,
  });

  final bool incremental;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          color: incremental ? Colors.amber.shade50 : Colors.blueGrey.shade50),
      child: Text(
        incremental ? 'incremental'.tr() : 'flat_rate'.tr(),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color:
                incremental ? Colors.amber.shade700 : Colors.blueGrey.shade700),
      ),
    );
  }
}
