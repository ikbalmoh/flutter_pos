import 'package:flutter/material.dart';
import 'package:selleri/data/models/item_cart.dart';
import 'package:selleri/data/models/item_package.dart';
import 'package:selleri/utils/formater.dart';

class CartItem extends StatefulWidget {
  final ItemCart item;
  final Function(ItemCart) onPress;
  final Function(ItemCart)? onLongPress;

  const CartItem({
    super.key,
    required this.item,
    required this.onPress,
    this.onLongPress,
  });

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return InkWell(
      onLongPress: widget.onLongPress != null
          ? () => widget.onLongPress!(widget.item)
          : null,
      onTap: () => widget.onPress(widget.item),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(width: 1, color: Colors.grey.shade100),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.item.quantity.toString(),
              style: textTheme.bodyLarge?.copyWith(color: Colors.red.shade700),
            ),
            const SizedBox(width: 20),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.item.itemName,
                ),
                widget.item.details.isNotEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List<ItemPackage>.from(widget.item.details)
                            .map(
                              (itemPackage) => Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    '${itemPackage.quantityItem} x ',
                                    style: textTheme.bodySmall
                                        ?.copyWith(color: Colors.black54),
                                  ),
                                  Expanded(
                                    child: Text(
                                      itemPackage.itemName,
                                      style: textTheme.bodySmall
                                          ?.copyWith(color: Colors.black54),
                                    ),
                                  ),
                                ],
                              ),
                            )
                            .toList(),
                      )
                    : Container(),
                Row(
                  children: [
                    widget.item.idVariant != null
                        ? Container(
                            margin: const EdgeInsets.only(top: 5, right: 5),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              widget.item.variantName ?? '',
                              style: textTheme.bodyMedium,
                            ),
                          )
                        : Container(),
                    widget.item.discountTotal > 0
                        ? Container(
                            margin: const EdgeInsets.only(top: 5, right: 5),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              '-${CurrencyFormat.currency(widget.item.discount, symbol: !widget.item.discountIsPercent)}${widget.item.discountIsPercent ? '%' : ''}',
                              style: textTheme.bodyMedium
                                  ?.copyWith(color: Colors.red.shade600),
                            ),
                          )
                        : Container(),
                  ],
                ),
                widget.item.note != ''
                    ? Text(
                        widget.item.note ?? '',
                        style: textTheme.bodySmall,
                      )
                    : Container()
              ],
            )),
            const SizedBox(width: 15),
            Text(
              CurrencyFormat.currency(widget.item.total, symbol: false),
              style:
                  textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }
}
