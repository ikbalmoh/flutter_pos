import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:selleri/data/models/item.dart';
import 'package:selleri/utils/formater.dart';

class ItemInfo extends StatelessWidget {
  final Item item;

  const ItemInfo({required this.item, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 10,
        left: 15,
        right: 15,
        bottom: MediaQuery.of(context).viewInsets.bottom + 15,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding:
                const EdgeInsets.only(top: 8, left: 5, right: 5, bottom: 15),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 0.5,
                  color: Colors.blueGrey.shade100,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.itemName,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                GestureDetector(
                  onTap: () => context.pop(),
                  child: Icon(
                    Icons.close,
                    color: Colors.grey.shade500,
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          Text(
            CurrencyFormat.currency(item.stockItem, symbol: false),
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .displayMedium
                ?.copyWith(color: Colors.teal, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 5),
          Text(
            'current_quantity'.tr(),
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.grey.shade700),
          ),
          const SizedBox(height: 25),
        ],
      ),
    );
  }
}
