import 'package:flutter/material.dart';
import 'package:selleri/data/models/promotion.dart';

class PromotionTimes extends StatelessWidget {
  const PromotionTimes({
    super.key,
    required this.promo,
  });

  final Promotion promo;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
          color: Colors.blueGrey.shade100,
          borderRadius: BorderRadius.circular(5)),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      margin: const EdgeInsets.only(right: 10),
      child: Text(
        promo.times!.map((time) => time.startTime).join(', '),
        style: textTheme.bodySmall?.copyWith(
            color: Colors.blueGrey.shade600, fontWeight: FontWeight.w600),
      ),
    );
  }
}
