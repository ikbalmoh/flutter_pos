import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:selleri/features/item/model/item.dart';

class ExpiredPackageBadge extends StatelessWidget {
  const ExpiredPackageBadge({
    super.key,
    required this.item,
    this.padding,
    this.showLabel,
  });

  final Item item;
  final bool? showLabel;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    bool isExpired = item.hasExpiredItems();
    if (!isExpired) {
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
            'x_items_expired'.tr(args: [item.totalExpiredItems().toString()]),
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
