import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:selleri/data/models/cart_holded.dart';
import 'package:selleri/utils/formater.dart';

class HoldedItem extends StatelessWidget {
  final CartHolded hold;
  final Function(CartHolded) onSelect;

  const HoldedItem({required this.hold, required this.onSelect, super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return ListTile(
      titleAlignment: ListTileTitleAlignment.top,
      title: Text(hold.transactionNo.trim()),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            CurrencyFormat.currency(hold.dataHold.grandTotal),
            style: textTheme.bodyMedium,
          ),
          Text(
            '${'cashier'.tr()}: ${hold.createdName ?? '-'}',
            style: textTheme.bodySmall?.copyWith(color: Colors.black54),
          ),
          hold.customerName != null && hold.customerName != ''
              ? Text(
                  '${'customer'.tr()}: ${hold.customerName}',
                  style: textTheme.bodySmall?.copyWith(color: Colors.black54),
                )
              : Container(),
          hold.description != null
              ? Text(
                  '${'note'.tr()}: ${hold.description}',
                  style: textTheme.bodySmall?.copyWith(color: Colors.black54),
                )
              : Container(),
        ],
      ),
      shape: Border(
        bottom: BorderSide(
          width: 0.5,
          color: Colors.blueGrey.shade50,
        ),
      ),
      onTap: () => onSelect(hold),
      leading: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: hold.dataHold.isApp
            ? Icon(
                Icons.smartphone,
                color: Colors.green.shade700,
                size: 20,
              )
            : const Icon(
                Icons.laptop,
                color: Colors.black45,
                size: 20,
              ),
      ),
      trailing: Text(
        DateTimeFormater.dateToString(hold.createdAt, format: 'dd/MM HH:mm'),
        style: textTheme.bodySmall,
      ),
    );
  }
}
