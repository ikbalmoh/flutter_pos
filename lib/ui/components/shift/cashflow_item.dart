import 'package:flutter/material.dart';
import 'package:selleri/data/models/shift_cashflow.dart';
import 'package:selleri/utils/formater.dart';

class CashflowItem extends StatelessWidget {
  final ShiftCashflow cashflow;
  final Function()? onTap;

  const CashflowItem({
    super.key,
    required this.cashflow,
    this.onTap,
  });

  Color getColor(int type) {
    switch (type) {
      case 1:
        return Colors.red.shade50;
      case 2:
        return Colors.green.shade50;
      default:
    }
    return Colors.blue.shade50;
  }

  Icon getIcon(int type) {
    switch (type) {
      case 1:
        return const Icon(
          Icons.arrow_outward,
          color: Colors.red,
          size: 16,
        );
      case 2:
        return const Icon(
          Icons.arrow_downward_sharp,
          color: Colors.green,
          size: 16,
        );
      default:
        return const Icon(
          Icons.account_balance_wallet,
          color: Colors.blue,
          size: 16,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      minTileHeight: 0,
      leading: Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
            color: getColor(cashflow.status),
            borderRadius: BorderRadius.circular(25)),
        child: getIcon(cashflow.status),
      ),
      title: Text(cashflow.codeCf),
      subtitle: Text(DateTimeFormater.dateToString(cashflow.transDate,
          format: 'd MMM y, HH:mm')),
      trailing: Text(
        CurrencyFormat.currency(cashflow.amount),
        style: Theme.of(context).textTheme.titleSmall,
      ),
      subtitleTextStyle: Theme.of(context)
          .textTheme
          .labelSmall
          ?.copyWith(color: Colors.blueGrey.shade600),
    );
  }
}
