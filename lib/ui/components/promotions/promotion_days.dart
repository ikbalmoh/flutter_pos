import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:selleri/data/models/promotion.dart';
import 'package:selleri/utils/formater.dart';

class PromotionDays extends StatelessWidget {
  const PromotionDays({
    super.key,
    required this.promo,
  });

  final Promotion promo;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
          color: Colors.blueGrey.shade50,
          borderRadius: BorderRadius.circular(5)),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      margin: const EdgeInsets.only(right: 10),
      child: Text(
        promo.days != null && promo.days!.length < 7
            ? promo.days!.map((day) => day.tr()).join(', ')
            : 'everyday'.tr(),
        style: textTheme.bodySmall?.copyWith(
            color: Colors.blueGrey.shade600, fontWeight: FontWeight.w600),
      ),
    );
  }
}
