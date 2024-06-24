import 'package:flutter/material.dart';
import 'package:selleri/utils/formater.dart';

class CashflowItem extends StatelessWidget {
  final String label;
  final double value;
  final DateTime date;
  final int type; // 1 = expense, 2 = income, 3 = deposit
  final Function()? onTap;

  const CashflowItem({
    super.key,
    required this.label,
    required this.value,
    required this.date,
    required this.type,
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
      onTap: () {},
      minTileHeight: 0,
      leading: Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
            color: getColor(type), borderRadius: BorderRadius.circular(25)),
        child: getIcon(type),
      ),
      title: Text(label),
      subtitle:
          Text(DateTimeFormater.dateToString(date, format: 'd MMM y, HH:mm')),
      trailing: Text(
        CurrencyFormat.currency(value),
        style: Theme.of(context).textTheme.titleSmall,
      ),
      subtitleTextStyle: Theme.of(context)
          .textTheme
          .labelSmall
          ?.copyWith(color: Colors.blueGrey.shade600),
    );
  }
}

class CashflowItemSkeleton extends StatelessWidget {
  const CashflowItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(0),
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.blueGrey.shade50.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(25)),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 70,
                      height: 20,
                      decoration: BoxDecoration(
                          color: Colors.blueGrey.shade50.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(5)),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      width: 120,
                      height: 15,
                      decoration: BoxDecoration(
                          color: Colors.blueGrey.shade50.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(5)),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 15),
              Container(
                width: 70,
                height: 20,
                decoration: BoxDecoration(
                    color: Colors.blueGrey.shade50.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(5)),
              ),
            ],
          )),
    );
  }
}
