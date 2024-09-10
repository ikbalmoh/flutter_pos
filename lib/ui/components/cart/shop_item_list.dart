import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:selleri/data/models/item.dart';
import 'package:selleri/ui/components/cart/promotions/promotion_badge.dart';
import 'package:selleri/ui/components/cart/stock_badge.dart';
import 'package:selleri/utils/formater.dart';

class ShopItemList extends StatelessWidget {
  final Item item;
  final Function(Item)? onLongPress;
  final Function(Item) onAddToCart;
  final Function(Item) showVariants;
  final Function(String) addQty;
  final int qtyOnCart;

  const ShopItemList({
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: InkWell(
        onLongPress: onLongPress != null ? () => onLongPress!(item) : null,
        onTap: () => item.variants.isNotEmpty
            ? showVariants(item)
            : qtyOnCart > 0
                ? addQty(item.idItem)
                : onAddToCart(item),
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
                      const SizedBox(
                        height: 5,
                      ),
                      Wrap(
                        spacing: 5,
                        children: [
                          item.promotions.isNotEmpty
                              ? const PromotionBadge()
                              : Container(),
                          StockBadge(
                            stockItem: item.stockItem,
                            stockControl: item.stockControl,
                            packageItems: item.packageItems,
                          ),
                        ],
                      ),
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
                    : Text(
                        CurrencyFormat.currency(item.itemPrice),
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.black54),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
