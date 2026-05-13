import 'package:flutter/material.dart';
import 'package:selleri/shared/utils/formater.dart';
import 'package:selleri/features/item/model/item_cart.dart';

class OrderItem extends StatelessWidget {
  final ItemCart item;
  final bool? asReceipt;
  const OrderItem({super.key, required this.item, this.asReceipt});

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
            style: asReceipt == true
                ? TextStyle(fontSize: 20, color: Colors.black)
                : textTheme.bodyMedium,
          ),
          if (item.details.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 7),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: item.details
                    .map(
                      (itemPackage) => Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '- ${CurrencyFormat.currency(itemPackage.quantity, symbol: false)} x',
                            style: asReceipt == true
                                ? TextStyle(fontSize: 20, color: Colors.black)
                                : textTheme.bodySmall
                                    ?.copyWith(color: Colors.black54),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: Text(
                              itemPackage.name,
                              style: asReceipt == true
                                  ? TextStyle(fontSize: 20, color: Colors.black)
                                  : textTheme.bodySmall
                                      ?.copyWith(color: Colors.black54),
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          if (item.note != '')
            Text(
              item.note ?? '',
              style: asReceipt == true
                  ? TextStyle(fontSize: 20, color: Colors.black)
                  : textTheme.bodySmall,
            ),
          const SizedBox(height: 3),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  ' ${CurrencyFormat.currency(item.quantity, symbol: false)} x ${CurrencyFormat.currency(item.price)}',
                  style: asReceipt == true
                      ? TextStyle(fontSize: 20, color: Colors.black)
                      : textTheme.bodySmall
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
                          style: TextStyle(
                            decoration: TextDecoration.lineThrough,
                            fontSize: asReceipt == true ? 20 : null,
                            color: asReceipt == true ? Colors.black : null,
                          ),
                        )
                      : Container(),
                  Text(
                    CurrencyFormat.currency(item.total, symbol: false),
                    textAlign: TextAlign.right,
                    style: asReceipt == true
                        ? TextStyle(fontSize: 20, color: Colors.black)
                        : null,
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
