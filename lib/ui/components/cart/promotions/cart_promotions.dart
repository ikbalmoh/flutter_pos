import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/data/models/promotion.dart';
import 'package:selleri/providers/promotion/promotions_provider.dart';
import 'package:selleri/ui/components/cart/promotions/cart_promotions_list.dart';

class CartPromotions extends ConsumerWidget {
  const CartPromotions({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Promotion> promotions = ref.watch(promotionsProvider);

    void onViewPromotions() {
      log('promotions: ${promotions.map((promo) => promo.name)}');
      showModalBottomSheet(
          backgroundColor: Colors.white,
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return const CartPromotionsList();
          });
    }

    return Material(
      color: promotions.isEmpty ? Colors.grey.shade50 : Colors.green.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
        side: BorderSide(
            color:
                promotions.isEmpty ? Colors.transparent : Colors.green.shade600,
            width: 1),
      ),
      child: InkWell(
        onTap: promotions.isEmpty ? null : onViewPromotions,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                CupertinoIcons.tickets_fill,
                color: promotions.isEmpty
                    ? Colors.grey.shade600
                    : Colors.amber.shade600,
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'promotions'.tr(),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: promotions.isEmpty
                              ? Colors.grey.shade700
                              : Colors.black),
                    ),
                    Text(
                      promotions.isEmpty
                          ? 'no_valid_promotions'.tr()
                          : '${promotions.length} ${'promotions_available'.tr()}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: promotions.isEmpty
                              ? Colors.grey.shade600
                              : Colors.black87),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 15),
              promotions.isEmpty
                  ? Container()
                  : const Icon(
                      CupertinoIcons.chevron_right,
                      size: 20,
                      color: Colors.black54,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
