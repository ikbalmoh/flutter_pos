import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:selleri/shared/utils/formater.dart';

class ExpiredBadge extends StatelessWidget {
  const ExpiredBadge({
    super.key,
    required this.expiredDate,
    required this.isExpired,
    this.padding,
    this.showLabel,
  });

  final DateTime expiredDate;
  final bool isExpired;
  final bool? showLabel;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(3)),
      padding: padding ??
          const EdgeInsets.symmetric(
            horizontal: 5,
          ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isExpired
                ? CupertinoIcons.exclamationmark_circle_fill
                : CupertinoIcons.calendar_today,
            size: 16,
            color: isExpired ? Colors.red.shade600 : Colors.orange.shade400,
          ),
          const SizedBox(width: 5),
          Text(
            isExpired
                ? 'expired'.tr()
                : [
                    if (showLabel == true) 'expired'.tr(),
                    DateTimeFormater.dateToString(expiredDate,
                        format: 'dd MMM y')
                  ].join(' '),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color:
                      isExpired ? Colors.red.shade500 : Colors.orange.shade600,
                ),
          ),
        ],
      ),
    );
  }
}
