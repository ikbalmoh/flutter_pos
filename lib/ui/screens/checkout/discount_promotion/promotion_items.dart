import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/data/models/cart_promotion.dart';
import 'package:selleri/providers/cart/cart_provider.dart';
import 'package:selleri/utils/formater.dart';

class PromotionItems extends ConsumerWidget {
  const PromotionItems({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<CartPromotion> promotions = ref.watch(cartProvider).promotions;
    TextTheme textTheme = Theme.of(context).textTheme;

    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: promotions.length,
        itemBuilder: (context, index) {
          CartPromotion promo = promotions[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  CupertinoIcons.tag,
                  size: 14,
                  color: promo.type == 3
                      ? Colors.blue.shade600
                      : promo.type == 1
                          ? Colors.orange.shade600
                          : Colors.green.shade600,
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    promo.promotionName,
                    style: textTheme.bodyMedium
                        ?.copyWith(color: Colors.grey.shade800),
                  ),
                ),
                Text(
                  CurrencyFormat.currency(
                    promo.discountValue,
                    minus: true,
                  ),
                  textAlign: TextAlign.right,
                  style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600, color: Colors.red.shade600),
                ),
              ],
            ),
          );
        });
  }
}
