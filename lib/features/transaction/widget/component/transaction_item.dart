import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:selleri/features/cart/model/cart.dart';
import 'package:selleri/shared/utils/formater.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem(
      {super.key,
      required this.cart,
      required this.active,
      required this.onTap});

  final Cart cart;
  final bool active;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: active ? Colors.grey.shade100 : Colors.white,
      title: Text(cart.transactionNo),
      trailing: Column(
        spacing: 2,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            CurrencyFormat.currency(
              cart.grandTotal,
              symbol: true,
            ),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          if (cart.isOffline == true)
            const Icon(
              Icons.cloud_off,
              color: Colors.grey,
              size: 16,
            )
        ],
      ),
      leading: cart.deletedAt != null
          ? const Icon(
              CupertinoIcons.xmark_circle_fill,
              color: Colors.red,
            )
          : cart.totalPayment < cart.grandTotal
              ? Icon(
                  CupertinoIcons.exclamationmark_circle_fill,
                  color: Colors.amber.shade600,
                )
              : const Icon(
                  CupertinoIcons.checkmark_alt_circle_fill,
                  color: Colors.green,
                ),
      shape: Border(
        bottom: BorderSide(
          width: 0.5,
          color: Colors.blueGrey.shade50,
        ),
      ),
      titleTextStyle: Theme.of(context).textTheme.bodyMedium,
      subtitleTextStyle: Theme.of(context)
          .textTheme
          .bodySmall
          ?.copyWith(color: Colors.grey.shade600),
      subtitle: Text(
        DateTimeFormater.msToString(cart.transactionDate,
            format: 'd MMM y HH:mm'),
      ),
      onTap: onTap,
    );
  }
}
