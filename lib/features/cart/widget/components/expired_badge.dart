import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:selleri/features/cart/widget/components/expired_package_badge.dart';
import 'package:selleri/features/item/model/item.dart';
import 'package:selleri/shared/utils/formater.dart';

class ExpiredBadge extends StatelessWidget {
  const ExpiredBadge({
    super.key,
    this.padding,
    this.showLabel,
    required this.item,
  });

  final Item item;
  final bool? showLabel;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    bool isExpired = item.isExpired();
    DateTime? expiredDate = item.expiredDate;

    if (item.isPackage) {
      return ExpiredPackageBadge(item: item);
    }

    if (expiredDate == null) {
      return SizedBox.shrink();
    }
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
