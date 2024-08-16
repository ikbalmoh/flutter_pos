import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class PromotionTypeBadge extends StatelessWidget {
  final int type;

  const PromotionTypeBadge({required this.type, super.key});

  String getPromotionType(int type) {
    switch (type) {
      case 2:
        return 'transaction'.tr();
      case 3:
        return 'item'.tr();
      default:
        return 'A get B';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
          color: type == 3
              ? Colors.blue.shade100
              : type == 1
                  ? Colors.orange.shade100
                  : Colors.green.shade100,
          borderRadius: BorderRadius.circular(15)),
      child: Text(
        getPromotionType(type),
        style: TextStyle(
            fontSize: 12,
            color: type == 3
                ? Colors.blue.shade600
                : type == 1
                    ? Colors.orange.shade600
                    : Colors.green.shade600),
      ),
    );
  }
}
