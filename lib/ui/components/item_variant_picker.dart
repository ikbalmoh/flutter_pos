import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selleri/models/item.dart';
import 'package:selleri/models/item_variant.dart';
import 'package:selleri/modules/cart/cart.dart';
import 'package:selleri/utils/formater.dart';

class ItemVariantPicker extends StatefulWidget {
  final Item item;
  const ItemVariantPicker({super.key, required this.item});

  @override
  State<ItemVariantPicker> createState() => _ItemVariantPickerState();
}

class _ItemVariantPickerState extends State<ItemVariantPicker> {
  CartController controller = Get.find();

  ItemVariant? selected;

  void onAddToCart() {
    controller.addToCart(widget.item, variant: selected);
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      margin: const EdgeInsets.all(0),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 12, right: 12, top: 10),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.only(
                    top: 8, left: 5, right: 5, bottom: 15),
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
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Icon(
                        Icons.close,
                        color: Colors.grey.shade500,
                        size: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 7.5,
              ),
              Text(
                'variants'.capitalize!,
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
                    ItemVariant variant = widget.item.variants[idx];
                    return VariantItem(
                        variant: variant,
                        selected: selected?.idVariant == variant.idVariant,
                        onSelect: (v) {
                          setState(() {
                            selected = v;
                          });
                        });
                  },
                  itemCount: widget.item.variants.length,
                  shrinkWrap: true,
                ),
              ),
              const SizedBox(
                height: 7.5,
              ),
              ElevatedButton(
                onPressed: selected != null ? onAddToCart : null,
                style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                  ),
                ),
                child: Text('add_to_cart'.tr),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class VariantItem extends StatelessWidget {
  const VariantItem(
      {super.key,
      required this.variant,
      this.selected = false,
      required this.onSelect});

  final ItemVariant variant;
  final bool selected;
  final Function(ItemVariant) onSelect;

  @override
  Widget build(BuildContext context) {
    Color textColor = selected ? Colors.teal : Colors.black;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Material(
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
