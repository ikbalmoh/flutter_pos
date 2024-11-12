import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:selleri/data/models/item_adjustment.dart';
import 'package:selleri/providers/adjustment/adjustment_provider.dart';
import 'package:selleri/ui/components/generic/qty_editor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AdjustmentItemForm extends ConsumerStatefulWidget {
  final ItemAdjustment item;
  final Function onDelete;

  const AdjustmentItemForm(
      {super.key, required this.item, required this.onDelete});

  @override
  ConsumerState<AdjustmentItemForm> createState() => _AdjustmentItemFormState();
}

class _AdjustmentItemFormState extends ConsumerState<AdjustmentItemForm> {
  final noteController = TextEditingController();

  late double qty;

  @override
  void initState() {
    super.initState();

    setState(() {
      qty = widget.item.qtyActual;
    });

    noteController.text = widget.item.note ?? '';

    super.initState();
  }

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  void onSave(BuildContext context) async {
    ItemAdjustment item = widget.item.copyWith();
    // Update Item
    ref.read(adjustmentProvider.notifier).addToCart(item);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle? labelStyle = Theme.of(context)
        .textTheme
        .bodyMedium
        ?.copyWith(color: Colors.blueGrey.shade600);

    String itemName = widget.item.itemName;
    if (widget.item.variantName != null) {
      itemName += ' - ${widget.item.variantName}';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      height: (MediaQuery.of(context).size.height *
          (MediaQuery.of(context).viewInsets.bottom > 0 ? 0.95 : 0.7)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding:
                const EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 0.5,
                  color: Colors.blueGrey.shade100,
                ),
              ),
            ),
            child: Text(
              itemName,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                      width: 0.5,
                      color: Colors.blueGrey.shade100,
                    ))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'quantity'.tr(),
                          style: labelStyle,
                        ),
                        QtyEditor(
                            qty: qty.toInt(),
                            onChange: (value) {
                              setState(() {
                                qty = value.toDouble();
                              });
                            }),
                      ],
                    ),
                  ),
                  TextFormField(
                    controller: noteController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(
                          left: 0, top: 10, right: 0, bottom: 10),
                      label: Text(
                        'note'.tr(),
                        style: labelStyle,
                      ),
                      alignLabelWithHint: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              IconButton(
                color: Colors.red,
                onPressed: () => widget.onDelete(),
                icon: const Icon(
                  CupertinoIcons.trash,
                  size: 20,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
                      ),
                    ),
                  ),
                  onPressed: () => onSave(context),
                  icon: const Icon(CupertinoIcons.checkmark_alt),
                  label: Text('save'.tr()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
