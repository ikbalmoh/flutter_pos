import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:selleri/data/models/item.dart';
import 'package:selleri/data/models/item_variant.dart';
import 'package:selleri/data/objectbox.dart';
import 'package:selleri/router/routes.dart';
import 'package:selleri/ui/components/cart/promotions/promotion_badge.dart';
import 'package:selleri/ui/components/cart/stock_badge.dart';
import 'package:selleri/utils/formater.dart';
import 'package:go_router/go_router.dart';

class ItemVariantPicker extends StatefulWidget {
  final Item item;
  final Function(List<ItemVariant>) onSelect;
  final Function(ItemVariant) onLongPress;

  const ItemVariantPicker(
      {super.key,
      required this.item,
      required this.onSelect,
      required this.onLongPress});

  @override
  State<ItemVariantPicker> createState() => _ItemVariantPickerState();
}

class _ItemVariantPickerState extends State<ItemVariantPicker> {
  List<ItemVariant> selectedVariants = [];

  void onAddToCart(BuildContext context) {
    widget.onSelect(selectedVariants);
    context.pop();
  }

  void onSelectVariant(ItemVariant variant) {
    List<ItemVariant> allSelected =
        List<ItemVariant>.from(selectedVariants).toList();

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
    List<ItemVariant> variants = objectBox.itemVariants(widget.item.idItem);
    List<ItemVariant> avaialableVariants = widget.item.stockControl
        ? variants.where((v) => v.stockItem > 1).toList()
        : variants;
    bool isAllSelected = selectedVariants.length == avaialableVariants.length;
    setState(() {
      selectedVariants = isAllSelected ? [] : avaialableVariants;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<ItemVariant> variants = objectBox.itemVariants(widget.item.idItem);
    List<ItemVariant> avaialableVariants = widget.item.stockControl
        ? variants.where((v) => v.stockItem > 1).toList()
        : variants;
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.item.itemName,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                IconButton(
                  padding: const EdgeInsets.all(5),
                  constraints: const BoxConstraints(),
                  onPressed: () => context.pushNamed(Routes.manageVariant,
                      pathParameters: {"idItem": widget.item.idItem}),
                  icon: Icon(
                    Icons.edit_note_rounded,
                    color: Colors.amber.shade800,
                  ),
                  iconSize: 26,
                  style: const ButtonStyle(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
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
                  value: selectedVariants.length == avaialableVariants.length,
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
                ItemVariant variant = variants[idx];
                ItemVariant? selected = selectedVariants
                    .firstWhereOrNull((v) => v.idVariant == variant.idVariant);
                return VariantItem(
                  variant: variant,
                  stockControl: widget.item.stockControl,
                  selected: selected?.idVariant == variant.idVariant,
                  onSelect: onSelectVariant,
                  onLongPress: widget.onLongPress,
                );
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
            child: Text('${'select_x'.tr(args: [
                  '${selectedVariants.length}'
                ])} ${'variants'.tr()}'),
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
    final bool isAvailable = stockControl ? variant.stockItem > 1 : true;
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
                          variant.promotions != null &&
                                  variant.promotions!.isNotEmpty
                              ? const PromotionBadge()
                              : Container(),
                          StockBadge(
                            stockItem: variant.stockItem,
                            stockControl: stockControl,
                          )
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
