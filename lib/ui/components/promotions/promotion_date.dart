import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:selleri/data/models/promotion.dart';
import 'package:selleri/utils/formater.dart';

class PromotionDate extends StatelessWidget {
  const PromotionDate({
    super.key,
    required this.promo,
  });

  final Promotion promo;

  @override
  Widget build(BuildContext context) {
    final isExpired = promo.allTime == false &&
        !(promo.startDate!.isBefore(DateTime.now()) &&
            promo.endDate!.isAfter(DateTime.now()));

    TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
          color: isExpired ? Colors.red.shade50 : Colors.green.shade50,
          borderRadius: BorderRadius.circular(5)),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      margin: const EdgeInsets.only(right: 10),
      child: Row(
        children: [
          Icon(
            CupertinoIcons.calendar,
            color: isExpired ? Colors.red.shade600 : Colors.green.shade600,
            size: 16,
          ),
          const SizedBox(width: 5),
          Text(
            [
              DateTimeFormater.dateToString(promo.startDate!,
                  format: 'dd MMM y'),
              DateTimeFormater.dateToString(promo.endDate!, format: 'dd MMM y'),
            ].join(' - '),
            style: textTheme.bodySmall?.copyWith(
                color: isExpired ? Colors.red.shade600 : Colors.green.shade600,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
