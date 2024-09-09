import 'package:flutter/material.dart';
import 'package:selleri/utils/formater.dart';
import 'package:selleri/data/models/item_cart.dart';

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
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            itemName,
            style: textTheme.bodyMedium,
          ),
          item.details.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(left: 7),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: item.details
                        .map(
                          (itemPackage) => Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '- ${itemPackage.quantity} x',
                                style: textTheme.bodySmall
                                    ?.copyWith(color: Colors.black54),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: Text(
                                  itemPackage.name,
                                  style: textTheme.bodySmall
                                      ?.copyWith(color: Colors.black54),
                                ),
                              ),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                )
              : Container(),
          item.note != ''
              ? Text(
                  item.note ?? '',
                  style: textTheme.bodySmall,
                )
              : Container(),
          const SizedBox(height: 3),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  ' ${item.quantity} x ${CurrencyFormat.currency(item.price)}',
                  style: textTheme.bodySmall
                      ?.copyWith(fontSize: 14, color: Colors.grey.shade700),
                ),
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
        ],
      ),
    );
  }
}
