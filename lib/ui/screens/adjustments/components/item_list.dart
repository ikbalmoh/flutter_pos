import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:selleri/data/models/item_adjustment.dart';
import 'package:selleri/ui/components/cart/stock_badge.dart';
import 'package:selleri/utils/formater.dart';

class ItemList extends StatelessWidget {
  final ItemAdjustment item;
  final Function(ItemAdjustment) onAddToCart;
  final Function(ItemAdjustment) showVariants;
  final int qtyOnCart;

  const ItemList({
    required this.item,
    required this.onAddToCart,
    required this.showVariants,
    super.key,
    required this.qtyOnCart,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: InkWell(
        onTap: () =>
            item.variants.isNotEmpty ? showVariants(item) : onAddToCart(item),
        child: Material(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: qtyOnCart > 0 ? Colors.teal : Colors.blueGrey.shade50,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                qtyOnCart > 0
                    ? Container(
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.all(
                            Radius.circular(999),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                        margin: const EdgeInsets.only(right: 10),
                        child: Text(
                          qtyOnCart.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700),
                        ),
                      )
                    : Container(),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.itemName,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      item.lastAdjustment != null
                          ? Row(
                              children: [
                                const Icon(
                                  CupertinoIcons.time,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                    DateTimeFormater.dateToString(
                                        item.lastAdjustment!,
                                        format: 'dd MMMM y'),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Colors.grey.shade700,
                                        ))
                              ],
                            )
                          : Container()
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                item.variants.isNotEmpty
                    ? Row(
                        children: [
                          Icon(
                            Icons.list,
                            size: 18,
                            color: Colors.amber.shade700,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text('${item.variants.length} variants')
                        ],
                      )
                    : StockBadge(
                        stockItem: item.stockItem ?? 0,
                        stockControl: item.stockControl ?? false,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
