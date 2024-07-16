import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:selleri/data/models/item_package.dart';
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
    bool isPackage = packageItems?.isNotEmpty ?? false;
    return !stockControl || isPackage
        ? Container()
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
            : Container(
                decoration: BoxDecoration(
                    color: stockItem <= 10
                        ? Colors.amber.shade100.withOpacity(0.5)
                        : Colors.blue.shade100.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(3)),
                padding: const EdgeInsets.symmetric(
                  horizontal: 5,
                ),
                child: Text(
                  '${'stock'.tr()} ${CurrencyFormat.currency(stockItem, symbol: false)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: stockItem <= 10
                            ? Colors.amber.shade700
                            : Colors.blue.shade700,
                      ),
                ),
              );
  }
}
