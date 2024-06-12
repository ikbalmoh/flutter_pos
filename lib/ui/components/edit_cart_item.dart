import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:selleri/data/models/item_cart.dart';
import 'package:selleri/providers/cart/cart_provider.dart';
import 'package:selleri/ui/components/discount_type_toggle.dart';
import 'package:selleri/ui/components/qty_editor.dart';
import 'package:selleri/utils/formater.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class EditCartItem extends ConsumerStatefulWidget {
  final ItemCart item;
  final Function onDelete;

  const EditCartItem({super.key, required this.item, required this.onDelete});

  @override
  ConsumerState<EditCartItem> createState() => _EditCartItemState();
}

class _EditCartItemState extends ConsumerState<EditCartItem> {
  final noteController = TextEditingController();

  final _priceFormater = CurrencyFormat.currencyInput();
  final _discountFormater = CurrencyFormat.currencyInput();

  late double price;
  late double discount;
  late int qty;
  late bool discountIsPercent;

  @override
  void initState() {
    super.initState();

    noteController.text = widget.item.note;

    setState(() {
      price = widget.item.price;
      discount = widget.item.discount;
      qty = widget.item.quantity;
      discountIsPercent = widget.item.discountIsPercent;
    });
    super.initState();
  }

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  void onChangeDiscountValue(String _) {
    double disc = _discountFormater.getUnformattedValue().toDouble();
    if (discountIsPercent && disc > 100) {
      disc = 100;
    }
    setState(() {
      discount = disc;
    });
  }

  void onChangeDiscountType() {
    if (!widget.item.manualDiscount) return;
    bool isPercent = !discountIsPercent;
    double disc = isPercent && discount > 100 ? 100 : discount;
    setState(() {
      discountIsPercent = isPercent;
      discount = disc;
    });
  }

  double discountTotal() {
    return discountIsPercent ? (price * (discount / 100)) : discount;
  }

  double total() {
    double total = (price - discountTotal()) * qty;
    return total;
  }

  void onUpdateItem(BuildContext context) async {
    ItemCart item = widget.item.copyWith(
      quantity: qty,
      price: price,
      discount: discount,
      discountIsPercent: discountIsPercent,
      discountTotal: discountTotal(),
      total: total(),
      note: noteController.text,
    );
    // Update Item
    ref.read(cartNotiferProvider.notifier).updateItem(item);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle? labelStyle = Theme.of(context)
        .textTheme
        .bodyMedium
        ?.copyWith(color: Colors.blueGrey.shade600);

    String itemName = widget.item.itemName;
    if (widget.item.variantName != '') {
      itemName += ' - ${widget.item.variantName}';
    }
    return Padding(
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
              itemName,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          TextFormField(
            inputFormatters: <TextInputFormatter>[_priceFormater],
            initialValue: _priceFormater.formatDouble(widget.item.price),
            onChanged: (value) {
              setState(() {
                price = _priceFormater.getUnformattedValue().toDouble();
              });
            },
            // controller: priceController,
            readOnly: widget.item.isManualPrice,
            textAlign: TextAlign.right,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              enabled: !widget.item.isManualPrice,
              contentPadding:
                  const EdgeInsets.only(left: 0, bottom: 15, right: 0),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              label: Text(
                'price'.tr(),
                style: labelStyle,
              ),
              prefix: Text(
                'price'.tr(),
                style: labelStyle,
              ),
              alignLabelWithHint: true,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  width: 0.5,
                  color: Colors.blueGrey.shade100,
                ),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  width: 0.5,
                  color: Colors.teal,
                ),
              ),
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
                  'quantity'.tr(),
                  style: labelStyle,
                ),
                QtyEditor(
                    qty: qty,
                    onChange: (value) {
                      setState(() {
                        qty = value;
                      });
                    }),
              ],
            ),
          ),
          TextFormField(
            inputFormatters: [_discountFormater],
            initialValue: _discountFormater.formatDouble(widget.item.discount),
            onChanged: onChangeDiscountValue,
            readOnly: !widget.item.manualDiscount,
            textAlign: TextAlign.right,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              enabled: widget.item.manualDiscount,
              contentPadding:
                  const EdgeInsets.only(left: 0, bottom: 15, right: 0),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              label: Text(
                'discount'.tr(),
                style: labelStyle,
              ),
              prefix: Text(
                'discount'.tr(),
                style: labelStyle,
              ),
              alignLabelWithHint: true,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  width: 0.5,
                  color: Colors.blueGrey.shade100,
                ),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  width: 0.5,
                  color: Colors.teal,
                ),
              ),
              suffix: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: DiscountTypeToggle(
                  isPercent: discountIsPercent,
                  onChange: onChangeDiscountType,
                ),
              ),
            ),
          ),
          TextFormField(
            controller: noteController,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.only(left: 0, top: 15, right: 0, bottom: 15),
              label: Text(
                'note'.tr(),
                style: labelStyle,
              ),
              alignLabelWithHint: true,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  width: 0.5,
                  color: Colors.blueGrey.shade100,
                ),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  width: 0.5,
                  color: Colors.teal,
                ),
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
                  onPressed: () => onUpdateItem(context),
                  icon: const Icon(CupertinoIcons.checkmark_alt),
                  label: Text(
                    CurrencyFormat.currency(total()),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
