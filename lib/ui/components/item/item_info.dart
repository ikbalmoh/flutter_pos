import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:selleri/data/models/item.dart';
import 'package:selleri/data/models/item_package.dart';
import 'package:selleri/data/models/item_variant.dart';
import 'package:selleri/data/models/promotion.dart';
import 'package:selleri/data/objectbox.dart';
import 'package:selleri/providers/item/item_provider.dart';
import 'package:selleri/providers/promotion/promotions_provider.dart';
import 'package:selleri/ui/components/cart/promotions/cart_promotion_item.dart';
import 'package:selleri/ui/components/cart/stock_badge.dart';
import 'package:selleri/utils/formater.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ItemInfo extends ConsumerWidget {
  final Item item;

  const ItemInfo({required this.item, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<String> promotionsIds = item.promotions;
    if (item.variants.isNotEmpty) {
      for (ItemVariant variant in item.variants) {
        if (variant.promotions != null) {
          promotionsIds = promotionsIds..addAll(variant.promotions!);
        }
      }
    }
    List<Promotion> promotions = objectBox.getPromotions(promotionsIds) ?? [];
    return Padding(
      padding: EdgeInsets.only(
        top: 10,
        left: 15,
        right: 15,
        bottom: MediaQuery.of(context).viewInsets.bottom + 15,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding:
                const EdgeInsets.only(top: 8, left: 5, right: 5, bottom: 15),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 0.5,
                  color: Colors.blueGrey.shade100,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.itemName,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Icon(
                        Icons.close,
                        color: Colors.grey.shade500,
                        size: 16,
                      ),
                    ),
                  ],
                ),
                item.barcode != null ? Row(
                  children: [
                    const Icon(
                      CupertinoIcons.barcode,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      item.barcode!,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.grey.shade700),
                    )
                  ],
                ) : Container()
              ],
            ),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                item.isPackage
                    ? ItemPackagesQtyInfo(
                        details: item.packageItems,
                        stockControl: item.stockControl,
                      )
                    : ItemQtyInfo(stockItem: item.stockItem),
                const SizedBox(height: 10),
                promotions.isNotEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'promotions'.tr(),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 10),
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, idx) {
                              Promotion promo = promotions[idx];
                              bool isEligible = ref
                                  .read(promotionsProvider.notifier)
                                  .isPromotionEligible(promo);
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: CartPromotionItem(
                                  promo: promo,
                                  onSelect: null,
                                  active: isEligible,
                                ),
                              );
                            },
                            itemCount: promotions.length,
                          )
                        ],
                      )
                    : Container()
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ItemPackagesQtyInfo extends ConsumerWidget {
  const ItemPackagesQtyInfo({
    super.key,
    required this.details,
    required this.stockControl,
  });

  final bool stockControl;
  final List<ItemPackage> details;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List<ItemPackage>.from(details).map((itemPackage) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${itemPackage.quantityItem} x',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.black87),
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Text(
                    itemPackage.itemName,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.black87,
                        ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                StockBadge(
                  stockItem:
                      ref.read(itemsStreamProvider().notifier).getItemStock(
                            itemPackage.idItem,
                          ),
                  stockControl: true,
                )
              ],
            ),
          );
        }).toList());
  }
}

class ItemQtyInfo extends StatelessWidget {
  const ItemQtyInfo({
    super.key,
    required this.stockItem,
  });

  final double stockItem;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 15),
        Text(
          CurrencyFormat.currency(stockItem, symbol: false),
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .displayMedium
              ?.copyWith(color: Colors.teal, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 5),
        Text(
          'current_quantity'.tr(),
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: Colors.grey.shade700),
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
