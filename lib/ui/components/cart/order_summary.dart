import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:selleri/data/models/cart.dart';
import 'package:selleri/data/models/item_cart.dart';
import 'package:selleri/utils/formater.dart';

class OrderItem extends StatelessWidget {
  final ItemCart item;
  const OrderItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    String itemName = item.itemName;
    if (item.variantName != '' && item.variantName != null) {
      itemName += ' - ${item.variantName}';
    }

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 7.5, horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    itemName,
                    style: textTheme.bodyMedium,
                  ),
                  Text(
                    ' ${item.quantity} x ${CurrencyFormat.currency(item.price)}',
                    style: textTheme.bodySmall
                        ?.copyWith(fontSize: 14, color: Colors.grey.shade700),
                  ),
                  item.note != ''
                      ? Text(
                          item.note ?? '',
                          style: textTheme.bodySmall,
                        )
                      : Container(),
                ]),
          ),
          const SizedBox(
            width: 12,
          ),
          Column(
            children: [
              (item.price * item.quantity) != item.total
                  ? Text(
                      CurrencyFormat.currency(item.price * item.quantity,
                          symbol: false),
                      style: const TextStyle(
                        decoration: TextDecoration.lineThrough,
                      ),
                    )
                  : Container(),
              Text(
                CurrencyFormat.currency(item.total, symbol: false),
                textAlign: TextAlign.right,
              ),
            ],
          )
        ],
      ),
    );
  }
}

class OrderSummary extends StatelessWidget {
  final Cart cart;
  final Radius? radius;
  const OrderSummary({required this.cart, this.radius, super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          radius ?? const Radius.circular(0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Text('order_summary'.tr(), style: textTheme.bodyLarge),
          ),
          Divider(
            height: 1,
            color: Colors.blueGrey.shade50,
          ),
          ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 7.5),
            itemBuilder: (context, idx) {
              ItemCart item = cart.items[idx];
              return OrderItem(item: item);
            },
            itemCount: cart.items.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Divider(
              height: 1,
              color: Colors.blueGrey.shade50,
            ),
          ),
          const SizedBox(height: 7),
          TwoColumn(
            label: 'Subtotal',
            value: cart.subtotal,
          ),
          TwoColumn(
            label: 'discount'.tr(),
            value: cart.discOverallTotal,
          ),
          TwoColumn(
            label: cart.taxName ?? 'tax'.tr(),
            value: cart.ppnTotal,
          ),
          TwoColumn(
            label: 'Grand Total',
            value: cart.grandTotal,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Divider(
              height: 15,
              color: Colors.blueGrey.shade50,
            ),
          ),
          TwoColumn(
            label: 'payment_amount'.tr(),
            value: cart.totalPayment,
          ),
          TwoColumn(
            label: 'change'.tr(),
            value: cart.change,
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class TwoColumn extends StatelessWidget {
  const TwoColumn({super.key, required this.label, required this.value});

  final String label;
  final double value;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: textTheme.bodySmall?.copyWith(color: Colors.grey.shade700),
          ),
          Text(
            CurrencyFormat.currency(value, symbol: false),
            style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
