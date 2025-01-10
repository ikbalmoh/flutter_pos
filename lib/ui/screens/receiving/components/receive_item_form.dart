import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:selleri/data/models/receiving/purchase_item.dart';
import 'package:selleri/providers/receiving/receiving_provider.dart';
import 'package:selleri/ui/components/generic/qty_editor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:selleri/utils/formater.dart';

class ReceiveItemForm extends ConsumerStatefulWidget {
  final PurchaseItem item;
  final Function? onDelete;

  const ReceiveItemForm(
      {super.key, required this.item, this.onDelete});

  @override
  ConsumerState<ReceiveItemForm> createState() => _ReceiveItemFormState();
}

class _ReceiveItemFormState extends ConsumerState<ReceiveItemForm> {
  late int qty;

  @override
  void initState() {
    super.initState();

    setState(() {
      qty = widget.item.qtyRequest - widget.item.qtyReceived;
    });

    super.initState();
  }

  void onSave(BuildContext context) async {
    ref.read(receivingProvider.notifier).receiveItem(
          widget.item,
          qtyReceive: qty,
        );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle? labelStyle = Theme.of(context)
        .textTheme
        .bodyMedium
        ?.copyWith(color: Colors.blueGrey.shade600);

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
              widget.item.itemName,
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
                          'SKU'.tr(),
                          style: labelStyle,
                        ),
                        Text(widget.item.skuNumber ?? '-'),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
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
                          'receive'.tr(),
                          style: labelStyle,
                        ),
                        QtyEditor(
                            qty: qty.toInt(),
                            onChange: (value) {
                              setState(() {
                                qty = value;
                              });
                            }),
                      ],
                    ),
                  ),
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
                          'request'.tr(),
                          style: labelStyle,
                        ),
                        Text(CurrencyFormat.currency(widget.item.qtyRequest,
                            symbol: false)),
                      ],
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
              widget.onDelete != null &&
                      (widget.item.qtyReceive != null &&
                          widget.item.qtyReceive! > 0)
                  ? IconButton(
                      color: Colors.red,
                      onPressed: () => widget.onDelete!(),
                      icon: const Icon(
                        CupertinoIcons.trash,
                        size: 20,
                      ),
                    )
                  : Container(),
              widget.onDelete != null ? const SizedBox(width: 10) : Container(),
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
