import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:selleri/data/models/receiving/purchase_item.dart';
import 'package:selleri/data/models/receiving/purchase_item_variant.dart';
import 'package:go_router/go_router.dart';

class PurchaseItemVariantPicker extends StatefulWidget {
  final PurchaseItem item;
  final String type;
  final Function(PurchaseItemVariant) onSelect;
  final ScrollController scrollController;

  const PurchaseItemVariantPicker(
      {super.key,
      required this.item,
      required this.onSelect,
      required this.scrollController,
      required this.type});

  @override
  State<PurchaseItemVariantPicker> createState() =>
      _PurchaseItemVariantPickerState();
}

class _PurchaseItemVariantPickerState extends State<PurchaseItemVariantPicker> {
  void onAddToCart(BuildContext context) {
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    List<PurchaseItemVariant> variants = widget.item.variants ?? [];
    return Padding(
      padding: const EdgeInsets.only(
        top: 10,
        left: 15,
        right: 15,
        bottom: 15,
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
          Expanded(
            child: ListView.builder(
              controller: widget.scrollController,
              itemBuilder: (context, idx) {
                PurchaseItemVariant variant = variants[idx];
                return VariantItem(
                  variant: variant,
                  onSelect: widget.onSelect,
                  type: widget.type,
                );
              },
              itemCount: variants.length,
              shrinkWrap: true,
            ),
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
    required this.onSelect,
    required this.type,
  });

  final PurchaseItemVariant variant;
  final String type;
  final Function(PurchaseItemVariant) onSelect;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.blueGrey.shade200, width: 0.5),
          borderRadius: const BorderRadius.all(Radius.circular(5)),
        ),
        child: InkWell(
          onTap: () => onSelect(variant),
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 10,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        variant.variantName,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        variant.skuNumber ?? '-',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.grey.shade700),
                      ),
                      Text(
                        "${variant.qtyReceived} ${'received'.tr()}",
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                ),
                TextButton.icon(
                    onPressed: () => onSelect(variant),
                    icon: Icon(type == '1'
                        ? CupertinoIcons.barcode_viewfinder
                        : CupertinoIcons.checkmark_alt),
                    label: Text('receive'.tr()))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
