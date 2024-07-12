import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:selleri/data/models/item_package.dart';
import 'package:selleri/providers/cart/cart_provider.dart';
import 'package:selleri/utils/formater.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StockBadge extends ConsumerWidget {
  const StockBadge({
    super.key,
    required this.stockItem,
    required this.stockControl,
    this.packageItems,
  });

  final double stockItem;
  final bool stockControl;
  final List<ItemPackage>? packageItems;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ItemPackage? emptyItem;
    if (packageItems != null) {
      final emptyItems = ref
          .read(cartNotiferProvider.notifier)
          .getEmptyItemPackages(packageItems ?? []);
      if (emptyItems.isNotEmpty) {
        emptyItem = emptyItems.first;
      }
    }
    return emptyItem != null
        ? Container(
            decoration: BoxDecoration(
                color: Colors.red.shade100.withOpacity(0.5),
                borderRadius: BorderRadius.circular(3)),
            padding: const EdgeInsets.symmetric(
              horizontal: 5,
            ),
            child: Text(
              'x_stock_empty'.tr(args: [emptyItem.itemName]),
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.red),
            ),
          )
        : stockItem <= 0
            ? Container(
                decoration: BoxDecoration(
                    color: Colors.red.shade100.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(3)),
                padding: const EdgeInsets.symmetric(
                  horizontal: 5,
                ),
                child: Text(
                  'out_of_stock'.tr(),
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.red),
                ),
              )
            : stockControl
                ? Container(
                    decoration: BoxDecoration(
                        color: Colors.blue.shade100.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(3)),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                    ),
                    child: Text(
                      '${'stock'.tr()} ${CurrencyFormat.currency(stockItem, symbol: false)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.blue.shade700,
                          ),
                    ),
                  )
                : stockItem <= 10
                    ? Container(
                        decoration: BoxDecoration(
                            color: Colors.amber.shade100.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(3)),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                        ),
                        child: Text(
                          'low_stock'.tr(),
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.amber.shade700),
                        ),
                      )
                    : Container();
  }
}
