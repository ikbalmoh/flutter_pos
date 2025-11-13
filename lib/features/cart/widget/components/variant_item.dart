import 'package:flutter/material.dart';
import 'package:selleri/features/cart/widget/components/promotions/promotion_badge.dart';
import 'package:selleri/features/cart/widget/components/stock_badge.dart';
import 'package:selleri/features/item/model/item_variant.dart';
import 'package:selleri/shared/utils/formater.dart';

class VariantItem extends StatelessWidget {
  const VariantItem({
    super.key,
    required this.variant,
    this.selected = false,
    required this.stockControl,
    required this.onSelect,
    required this.onLongPress,
  });

  final ItemVariant variant;
  final bool selected;
  final bool stockControl;
  final Function(ItemVariant) onSelect;
  final Function(ItemVariant) onLongPress;

  @override
  Widget build(BuildContext context) {
    Color textColor = selected ? Colors.teal : Colors.black;
    final bool isAvailable = stockControl ? variant.stockItem > 0 : true;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Material(
        color: isAvailable ? Colors.white : Colors.grey.shade100,
        child: InkWell(
          onLongPress: () => onLongPress(variant),
          onTap: isAvailable ? () => onSelect(variant) : null,
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 10,
            ),
            decoration: BoxDecoration(
                border: Border.all(
                    color: selected ? Colors.teal : Colors.blueGrey.shade200,
                    width: 0.5),
                borderRadius: const BorderRadius.all(Radius.circular(5))),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  visualDensity:
                      const VisualDensity(horizontal: -4, vertical: -4),
                  value: selected,
                  onChanged: isAvailable ? (_) => onSelect(variant) : null,
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        variant.variantName,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: textColor),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Wrap(
                        spacing: 5,
                        children: [
                          if (variant.promotions != null &&
                              variant.promotions!.isNotEmpty)
                            const PromotionBadge(),
                          StockBadge(
                            stockItem: variant.stockItem,
                            stockControl: stockControl,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Text(
                  CurrencyFormat.currency(variant.itemPrice),
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600, color: textColor),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
