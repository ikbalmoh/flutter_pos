import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class PromotionTypeBadge extends StatelessWidget {
  final int type;

  const PromotionTypeBadge({required this.type, super.key});

  String getPromotionType(int type) {
    switch (type) {
      case 2:
        return 'discount_transaction'.tr();
      case 3:
        return 'discount_item'.tr();
      default:
        return 'discount_free_gift'.tr();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      getPromotionType(type),
      style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: type == 3
              ? Colors.blue.shade600
              : type == 1
                  ? Colors.orange.shade600
                  : Colors.green.shade600),
    );
  }
}
