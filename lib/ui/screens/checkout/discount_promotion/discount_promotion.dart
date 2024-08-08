import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:selleri/ui/screens/checkout/discount_promotion/discount_item.dart';
import 'package:selleri/ui/screens/checkout/discount_promotion/promotion_items.dart';
// import 'package:selleri/ui/screens/checkout/discount_promotion/promotion_code_item.dart';

class DiscountPromotion extends StatelessWidget {
  const DiscountPromotion({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Card(
      margin: const EdgeInsets.all(10),
      color: Colors.white,
      elevation: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Text('discount&promotion'.tr(), style: textTheme.bodyLarge),
          ),
          Divider(
            height: 1,
            color: Colors.blueGrey.shade50,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: const Column(
              children: [
                DiscountItem(),
                // PromotionCodeItem(),
                PromotionItems()
              ],
            ),
          )
        ],
      ),
    );
  }
}
