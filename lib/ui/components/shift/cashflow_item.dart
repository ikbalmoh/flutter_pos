import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:selleri/data/models/shift_cashflow.dart';
import 'package:selleri/utils/formater.dart';

class CashflowItem extends StatelessWidget {
  final ShiftCashflow cashflow;
  final Function()? onTap;
  final bool editable;

  const CashflowItem({
    super.key,
    required this.cashflow,
    this.onTap,
    required this.editable,
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
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            CurrencyFormat.currency(cashflow.amount),
            style: Theme.of(context).textTheme.titleSmall,
          ),
          cashflow.approval != 'new'
              ? Container(
                  margin: const EdgeInsets.only(top: 2),
                  decoration: BoxDecoration(
                      color: cashflow.approval == 'approve'
                          ? Colors.green
                          : Colors.red,
                      borderRadius: BorderRadius.circular(3)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                  child: Text(
                    cashflow.approval == 'approve' ? 'approved'.tr() : 'rejected'.tr(),
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.white, fontSize: 10),
                  ),
                )
              : const SizedBox(width: 0, height: 0)
        ],
      ),
      subtitleTextStyle: Theme.of(context)
          .textTheme
          .labelSmall
          ?.copyWith(color: Colors.blueGrey.shade600),
    );
  }
}
