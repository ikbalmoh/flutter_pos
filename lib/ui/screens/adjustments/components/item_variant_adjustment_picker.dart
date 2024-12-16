import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:selleri/data/models/item_adjustment.dart';
import 'package:selleri/data/models/item_variant_adjustment.dart';
import 'package:selleri/ui/components/cart/stock_badge.dart';
import 'package:go_router/go_router.dart';
import 'package:selleri/ui/components/generic/qty_editor.dart';

class ItemVariantAdjustmentPicker extends StatefulWidget {
  final ItemAdjustment item;
  final Function(List<ItemVariantAdjustment>) onSelect;

  const ItemVariantAdjustmentPicker(
      {super.key, required this.item, required this.onSelect});

  @override
  State<ItemVariantAdjustmentPicker> createState() =>
      _ItemVariantAdjustmentPickerState();
}

class _ItemVariantAdjustmentPickerState
    extends State<ItemVariantAdjustmentPicker> {
  List<ItemVariantAdjustment> selectedVariants = [];

  void onAddToCart(BuildContext context) {
    context.pop();
    widget.onSelect(selectedVariants);
  }

  void onSelectVariant(ItemVariantAdjustment variant) {
    List<ItemVariantAdjustment> allSelected =
        List<ItemVariantAdjustment>.from(selectedVariants).toList();

    int existIdx =
        allSelected.indexWhere((v) => v.idVariant == variant.idVariant);

    if (existIdx < 0) {
      allSelected.add(variant);
    } else {
      allSelected.removeAt(existIdx);
    }
    setState(() {
      selectedVariants = allSelected;
    });
  }

  void onSelectAll() {
    bool isAllSelected =
        selectedVariants.length == widget.item.variants?.length;
    setState(() {
      selectedVariants = isAllSelected ? [] : widget.item.variants ?? [];
    });
  }

  void onChangeVariantQty(int idVariant, int qty) {
    int existIdx = selectedVariants.indexWhere((v) => v.idVariant == idVariant);
    if (existIdx < 0) {
      return;
    }
    List<ItemVariantAdjustment> allSelected =
        List<ItemVariantAdjustment>.from(selectedVariants).toList();

    allSelected[existIdx] =
        allSelected[existIdx].copyWith(qtyActual: qty.toDouble());

    setState(() {
      selectedVariants = allSelected;
    });
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Checkbox(
                  visualDensity:
                      const VisualDensity(horizontal: -4, vertical: -4),
                  value:
                      selectedVariants.length == widget.item.variants?.length,
                  onChanged: (_) => onSelectAll(),
                ),
                const SizedBox(width: 7),
                Text(
                  'select_x'.tr(args: ['all'.tr()]),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.black87, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 7.5,
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, idx) {
                ItemVariantAdjustment variant = variants[idx];
                ItemVariantAdjustment? selected = selectedVariants
                    .firstWhereOrNull((v) => v.idVariant == variant.idVariant);
                return VariantItem(
                    variant: variant,
                    selected: selected != null,
                    onSelect: onSelectVariant,
                    onChangeQty: (qty) =>
                        onChangeVariantQty(variant.idVariant, qty));
              },
              itemCount: variants.length,
              shrinkWrap: true,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          ElevatedButton(
            onPressed:
                selectedVariants.isNotEmpty ? () => onAddToCart(context) : null,
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
    required this.onChangeQty,
  });

  final ItemVariantAdjustment variant;
  final bool selected;
  final Function(ItemVariantAdjustment) onSelect;
  final Function(int) onChangeQty;

  @override
  Widget build(BuildContext context) {
    Color textColor = selected ? Colors.teal : Colors.black;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
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
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Checkbox(
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
              value: selected,
              onChanged: (_) => onSelect(variant),
            ),
            const SizedBox(width: 7),
            Expanded(
              child: Text(
                variant.variantName,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: textColor),
              ),
            ),
            selected
                ? QtyEditor(
                    qty: variant.stockItem.toInt(), onChange: onChangeQty)
                : StockBadge(
                    stockItem: variant.stockItem,
                    stockControl: true,
                  ),
          ],
        ),
      ),
    );
  }
}
