import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:selleri/shared/utils/formater.dart';

class CashPaymentShortcut extends StatelessWidget {
  const CashPaymentShortcut({
    required this.onSelected,
    this.padding,
    this.transactionAmount,
    super.key,
  });
  final Function(double? value) onSelected;
  final EdgeInsetsGeometry? padding;
  final double? transactionAmount;

  @override
  Widget build(BuildContext context) {
    Set<double> shortcuts = {};
    const multipliers = [10000.0, 20000.0, 50000.0, 100000.0];

    if (transactionAmount != null) {
      for (var multiplier in multipliers) {
        if (transactionAmount! < multiplier) {
          shortcuts.add(multiplier);
        } else {
          double nextMultiple =
              (transactionAmount! / multiplier).ceil() * multiplier;
          if (nextMultiple > transactionAmount!) {
            shortcuts.add(nextMultiple);
          }
        }
      }
    }

    final shortcutList = shortcuts.toList()..sort();

    return Container(
      padding: padding,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          if (transactionAmount != null)
            TextButton.icon(
              onPressed: () => onSelected(transactionAmount),
              style: TextButton.styleFrom(
                minimumSize: Size.zero,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                backgroundColor: Colors.grey.shade100,
              ),
              icon: const Icon(Icons.check, size: 16),
              label: Text('exact_change'.tr()),
            ),
          ...shortcutList.map(
            (v) => TextButton(
              onPressed: () => onSelected(v.toDouble()),
              style: TextButton.styleFrom(
                minimumSize: Size.zero,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                backgroundColor: Colors.grey.shade100,
              ),
              child: Text(v == transactionAmount
                  ? 'exact_change'.tr()
                  : CurrencyFormat.currency(v)),
            ),
          ),
          TextButton.icon(
            onPressed: () => onSelected(null),
            style: TextButton.styleFrom(
              minimumSize: Size.zero,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              backgroundColor: Colors.grey.shade100,
            ),
            icon: const Icon(Icons.edit, size: 16),
            label: Text('add_nominal'.tr()),
          )
        ],
      ),
    );
  }
}
