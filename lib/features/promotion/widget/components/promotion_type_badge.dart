import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class PromotionTypeBadge extends StatelessWidget {
  final int type;

  const PromotionTypeBadge({required this.type, super.key});

  String getPromotionType(int type) {
    switch (type) {
      case 1:
        return 'reward_by_product'.tr();
      case 2:
        return 'discount_by_order'.tr();
      case 3:
        return 'discount_by_product'.tr();
      case 4:
        return 'reward_by_transaction'.tr();
      default:
        return 'promotions'.tr();
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
                : type == 4
                    ? Colors.green.shade600
                    : Colors.red.shade400,
      ),
    );
  }
}
