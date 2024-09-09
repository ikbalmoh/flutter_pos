import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:selleri/data/models/item.dart';
import 'package:selleri/data/models/item_package.dart';
import 'package:selleri/providers/item/item_provider.dart';
import 'package:selleri/ui/components/cart/stock_badge.dart';
import 'package:selleri/utils/formater.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ItemInfo extends StatelessWidget {
  final Item item;

  const ItemInfo({required this.item, super.key});

  @override
  Widget build(BuildContext context) {
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
            child: Row(
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
          ),
          const SizedBox(height: 10),
          item.isPackage
              ? ItemPackagesQtyInfo(
                  details: item.packageItems,
                  stockControl: item.stockControl,
                )
              : ItemQtyInfo(stockItem: item.stockItem),
          const SizedBox(height: 10),
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
