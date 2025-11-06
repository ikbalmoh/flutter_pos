import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:selleri/features/cart/model/cart.dart';
import 'package:selleri/shared/utils/formater.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem(
      {super.key,
      required this.cart,
      required this.isActive,
      required this.onTap});

  final Cart cart;
  final VoidCallback onTap;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: isActive ? Colors.grey.shade100 : Colors.white,
      title: Text(cart.transactionNo),
      trailing: Text(
        CurrencyFormat.currency(
          cart.grandTotal,
          symbol: true,
        ),
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      leading: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: cart.deletedAt != null
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
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Column(
          spacing: 4,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              spacing: 6,
              children: [
                Icon(
                  Icons.calendar_month,
                  size: 16,
                  color: Colors.grey.shade500,
                ),
                Text(
                  DateTimeFormater.msToString(cart.transactionDate,
                      format: 'd MMM y HH:mm'),
                ),
              ],
            ),
            if (cart.customerName != null)
              Row(
                spacing: 6,
                children: [
                  Icon(
                    Icons.person,
                    size: 16,
                    color: Colors.grey.shade500,
                  ),
                  Text([cart.customerName, cart.vehicle?.licensePlate]
                      .whereType<String>()
                      .join(' - ')),
                ],
              ),
          ],
        ),
      ),
      isThreeLine: true,
      onTap: onTap,
    );
  }
}
