import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/data/models/promotion.dart';
import 'package:selleri/providers/promotion/promotions_provider.dart';
import 'package:selleri/ui/components/cart/promotions/cart_promotion_item.dart';

class CartPromotionsList extends ConsumerWidget {
  const CartPromotionsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Promotion> promotions = ref.watch(promotionsProvider);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      height: (MediaQuery.of(context).size.height * 0.8) +
          MediaQuery.of(context).viewInsets.bottom +
          15,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding:
                const EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 0.5,
                  color: Colors.blueGrey.shade100,
                ),
              ),
            ),
            child: Text(
              promotions.isEmpty
                  ? 'no_valid_promotions'.tr()
                  : '${promotions.length} ${'promotions_available'.tr()}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          Expanded(
              child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 7.5),
            shrinkWrap: true,
            itemBuilder: (context, idx) {
              Promotion promo = promotions[idx];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 7.5),
                child: CartPromotionItem(promo: promo),
              );
            },
            itemCount: promotions.length,
          ))
        ],
      ),
    );
  }
}
