import 'package:flutter/material.dart';
import 'package:selleri/data/models/item_cart.dart';
import 'package:selleri/providers/cart/cart_provider.dart';
import 'package:selleri/utils/formater.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderItem extends StatelessWidget {
  final ItemCart item;
  const OrderItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    String itemName = item.itemName;
    if (item.variantName != '') {
      itemName += ' - ${item.variantName}';
    }

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 7.5, horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.quantity.toString(),
            style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            width: 15,
          ),
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
                    CurrencyFormat.currency(item.price - item.discountTotal),
                    style: textTheme.bodySmall?.copyWith(fontSize: 14),
                  ),
                  item.note != ''
                      ? Text(
                          item.note,
                          style: textTheme.bodySmall,
                        )
                      : Container(),
                ]),
          ),
          const SizedBox(
            width: 12,
          ),
          Text(
            CurrencyFormat.currency(item.total, symbol: false),
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }
}

class OrderSummary extends ConsumerWidget {
  const OrderSummary({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartNotiferProvider);
    TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Text('Order Summary', style: textTheme.bodyLarge),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Subtotal',
                  style: textTheme.bodyMedium
                      ?.copyWith(color: Colors.grey.shade700),
                ),
                Text(
                  CurrencyFormat.currency(cart.subtotal),
                  style: textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
