import 'package:flutter/material.dart';
import 'package:selleri/models/item_cart.dart';
import 'package:selleri/utils/formater.dart';

class CartItem extends StatefulWidget {
  final ItemCart item;
  final Function(ItemCart) onPress;

  const CartItem({super.key, required this.item, required this.onPress});

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return InkWell(
      onTap: () => widget.onPress(widget.item),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(width: 1, color: Colors.grey.shade100),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
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
                widget.item.note != ''
                    ? Text(
                        widget.item.note,
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
