import 'package:flutter/material.dart';
import 'package:selleri/data/models/item.dart';
import 'package:selleri/ui/components/cart/promotions/promotion_badge.dart';
import 'package:selleri/ui/components/cart/stock_badge.dart';
import 'package:selleri/utils/formater.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ItemGrid extends StatelessWidget {
  final Item item;
  final Function(Item)? onLongPress;
  final Function(Item) onAddToCart;
  final Function(Item) showVariants;
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
      onTap: () => item.variants.isNotEmpty
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
                    child: Stack(
                      children: [
                        item.image != null && item.image != ''
                            ? ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(10)),
                                child: CachedNetworkImage(
                                  imageUrl: item.image!,
                                  width: double.maxFinite,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Center(
                                    child: CircularProgressIndicator(
                                      backgroundColor: Colors.blueGrey.shade300,
                                    ),
                                  ),
                                ),
                              )
                            : Center(
                                child: Text(
                                  item.itemName.substring(0, 3).toUpperCase(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall
                                      ?.copyWith(
                                        color: Colors.grey.shade400,
                                      ),
                                ),
                              ),
                        Positioned(
                          bottom: 5,
                          left: 5,
                          child: Wrap(
                            alignment: WrapAlignment.start,
                            spacing: 5,
                            direction: Axis.horizontal,
                            children: [
                              StockBadge(
                                stockItem: item.stockItem,
                                stockControl: item.stockControl,
                                packageItems: item.packageItems,
                              ),
                              item.promotions.isNotEmpty
                                  ? const PromotionBadge()
                                  : Container(),
                            ],
                          ),
                        )
                      ],
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
                          : Text(CurrencyFormat.currency(item.itemPrice)),
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
