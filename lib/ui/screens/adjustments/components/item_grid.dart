import 'package:flutter/material.dart';
import 'package:selleri/data/models/item_adjustment.dart';
import 'package:selleri/ui/components/cart/stock_badge.dart';

class ItemGrid extends StatelessWidget {
  final ItemAdjustment item;
  final Function(ItemAdjustment)? onLongPress;
  final Function(ItemAdjustment) onAddToCart;
  final Function(ItemAdjustment) showVariants;
  final Function(String) addQty;
  final int qtyOnCart;

  const ItemGrid({
    required this.item,
    required this.onAddToCart,
    required this.showVariants,
    this.onLongPress,
    super.key,
    required this.addQty,
    required this.qtyOnCart,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: onLongPress != null ? () => onLongPress!(item) : null,
      onTap: () => item.variants != null && item.variants!.isNotEmpty
          ? showVariants(item)
          : qtyOnCart > 0
              ? addQty(item.idItem)
              : onAddToCart(item),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: qtyOnCart > 0 ? Colors.teal : Colors.transparent,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        elevation: qtyOnCart > 0 ? 2 : 4,
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(10)),
                      color: Colors.grey.shade200,
                    ),
                    child: Center(
                      child: Text(
                        item.itemName.substring(0, 3).toUpperCase(),
                        style:
                            Theme.of(context).textTheme.displaySmall?.copyWith(
                                  color: Colors.grey.shade400,
                                ),
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(10)),
                    color: Colors.white,
                  ),
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7.5, vertical: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.itemName,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      item.variants != null && item.variants!.isNotEmpty
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
                                Text('${item.variants!.length} variants')
                              ],
                            )
                          : StockBadge(
                              stockItem: item.stockItem ?? 0,
                              stockControl: item.stockControl ?? false,
                            ),
                    ],
                  ),
                )
              ],
            ),
            qtyOnCart > 0
                ? Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
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
                      child: Text(
                        qtyOnCart.toString(),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white, fontWeight: FontWeight.w700),
                      ),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
