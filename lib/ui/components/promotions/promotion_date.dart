import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:selleri/utils/formater.dart';

class PromotionDate extends StatelessWidget {
  const PromotionDate({
    super.key,
    required this.allTime,
    required this.startDate,
    required this.endDate,
  });

  final bool allTime;
  final DateTime? startDate;
  final DateTime? endDate;

  @override
  Widget build(BuildContext context) {
    final isExpired = allTime == false &&
        !(startDate!.isBefore(DateTime.now()) &&
            endDate!.isAfter(DateTime.now()));

    TextTheme textTheme = Theme.of(context).textTheme;

    if (allTime) {
      return const SizedBox(
        width: 0,
        height: 0,
      );
    }

    return Container(
      decoration: BoxDecoration(
          color: isExpired ? Colors.red.shade50 : Colors.green.shade50,
          borderRadius: BorderRadius.circular(5)),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            CupertinoIcons.calendar,
            color: isExpired ? Colors.red.shade600 : Colors.green.shade600,
            size: 16,
          ),
          const SizedBox(width: 5),
          Text(
            [
              DateTimeFormater.dateToString(startDate!, format: 'dd MMM y'),
              DateTimeFormater.dateToString(endDate!, format: 'dd MMM y'),
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
