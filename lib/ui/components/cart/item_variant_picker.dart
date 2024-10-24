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
  final Function(ItemVariant) onSelect;

  const ItemVariantPicker(
      {super.key, required this.item, required this.onSelect});

  @override
  State<ItemVariantPicker> createState() => _ItemVariantPickerState();
}

class _ItemVariantPickerState extends State<ItemVariantPicker> {
  ItemVariant? selected;

  void onAddToCart(BuildContext context, ItemVariant variant) {
    widget.onSelect(variant);
    context.pop();
  }

  bool isAvailable() {
    if (selected != null) {
      if (widget.item.stockControl) {
        return selected!.stockItem > 0;
      }
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    List<ItemVariant> variants = objectBox.itemVariants(widget.item.idItem);
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
                ItemVariant variant = variants[idx];
                return VariantItem(
                    variant: variant,
                    stockControl: widget.item.stockControl,
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
            onPressed:
                isAvailable() ? () => onAddToCart(context, selected!) : null,
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
    required this.stockControl,
    required this.onSelect,
  });

  final ItemVariant variant;
  final bool selected;
  final bool stockControl;
  final Function(ItemVariant) onSelect;

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
