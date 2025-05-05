import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/providers/cart/cart_provider.dart';
import 'package:selleri/ui/screens/checkout/discount_promotion/discount_overall_item.dart';
import 'package:selleri/ui/screens/checkout/discount_promotion/promotion_items.dart';
import 'package:selleri/ui/screens/checkout/discount_promotion/voucher_item.dart';

class DiscountPromotion extends ConsumerWidget {
  const DiscountPromotion({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextTheme textTheme = Theme.of(context).textTheme;

    // Check if there's a discount voucher applied
    bool hasDiscountVoucher = ref.watch(cartProvider).vouchers.any(
          (voucher) => voucher.voucherType == 'discount',
        );

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
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20)),
            child: Column(
              children: [
                if (!hasDiscountVoucher) const DiscountOverallItem(),
                const VoucherItem(),
                const PromotionItems(),
                // PromotionCodeItem(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
