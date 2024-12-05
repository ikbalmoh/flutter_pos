import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:selleri/data/models/item_adjustment.dart';
import 'package:selleri/data/models/item_variant_adjustment.dart';
import 'package:selleri/ui/components/cart/stock_badge.dart';
import 'package:go_router/go_router.dart';

class ItemVariantAdjustmentPicker extends StatefulWidget {
  final ItemAdjustment item;
  final Function(ItemVariantAdjustment) onSelect;

  const ItemVariantAdjustmentPicker(
      {super.key, required this.item, required this.onSelect});

  @override
  State<ItemVariantAdjustmentPicker> createState() =>
      _ItemVariantAdjustmentPickerState();
}

class _ItemVariantAdjustmentPickerState
    extends State<ItemVariantAdjustmentPicker> {
  ItemVariantAdjustment? selected;

  void onAddToCart(BuildContext context, ItemVariantAdjustment variant) {
    context.pop();
    widget.onSelect(variant);
  }

  @override
  Widget build(BuildContext context) {
    List<ItemVariantAdjustment> variants = widget.item.variants ?? [];
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
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
            child: Text(
              widget.item.itemName,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            'select_variant'.tr(),
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.blueGrey.shade600),
          ),
          const SizedBox(
            height: 7.5,
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, idx) {
                ItemVariantAdjustment variant = variants[idx];
                return VariantItem(
                    variant: variant,
                    selected: selected?.idVariant == variant.idVariant,
                    onSelect: (v) {
                      setState(() {
                        selected = v;
                      });
                    });
              },
              itemCount: variants.length,
              shrinkWrap: true,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          ElevatedButton(
            onPressed: selected != null ? () => onAddToCart(context, selected!) : null,
            style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
            ),
            child: Text('choose'.tr()),
          ),
          const SizedBox(
            height: 7.5,
          ),
        ],
      ),
    );
  }
}

class VariantItem extends StatelessWidget {
  const VariantItem({
    super.key,
    required this.variant,
    this.selected = false,
    required this.onSelect,
  });

  final ItemVariantAdjustment variant;
  final bool selected;
  final Function(ItemVariantAdjustment) onSelect;

  @override
  Widget build(BuildContext context) {
    Color textColor = selected ? Colors.teal : Colors.black;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: () => onSelect(variant),
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
                Expanded(
                  child: Text(
                    variant.variantName,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: textColor),
                  ),
                ),
                StockBadge(
                  stockItem: variant.stockItem,
                  stockControl: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
