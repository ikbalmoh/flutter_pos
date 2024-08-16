import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class PromotionDays extends StatelessWidget {
  const PromotionDays({
    super.key,
    required this.days,
  });

  final List<String>? days;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
          color: Colors.blueGrey.shade50,
          borderRadius: BorderRadius.circular(5)),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      child: Text(
        days == null || days!.length == 7
            ? 'everyday'.tr()
            : days!.map((day) => day.tr()).join(', '),
        style: textTheme.bodySmall?.copyWith(
            color: Colors.blueGrey.shade600, fontWeight: FontWeight.w600),
      ),
    );
  }
}
 