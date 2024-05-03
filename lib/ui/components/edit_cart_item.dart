import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:selleri/data/models/item_cart.dart';
import 'package:selleri/ui/components/discount_type_toggle.dart';
import 'package:selleri/ui/components/qty_editor.dart';
import 'package:selleri/utils/app.dart';
import 'package:selleri/utils/formater.dart';

class EditCartItem extends StatefulWidget {
  final ItemCart item;
  const EditCartItem({super.key, required this.item});

  @override
  State<EditCartItem> createState() => _EditCartItemState();
}

class _EditCartItemState extends State<EditCartItem> {
  final noteController = TextEditingController();
  final priceController = TextEditingController();
  final discountController = TextEditingController();

  late double price;
  late double discount;
  late int qty;
  late bool discountIsPercent;

  @override
  void initState() {
    noteController.text = widget.item.note ?? '';
    priceController.text = widget.item.price.toString();
    discountController.text = widget.item.discount.toString();

    priceController.addListener(() {
      setState(() {
        price = double.tryParse(priceController.text) ?? 0;
      });
    });

    discountController.addListener(() {
      double disc = double.tryParse(discountController.text) ?? 0;
      if (discountIsPercent && disc > 100) {
        disc = 100;
        discountController.text = disc.toString();
      }
      setState(() {
        discount = disc;
      });
    });

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
    priceController.dispose();
    discountController.dispose();
    super.dispose();
  }

  void onChangeDiscountType() {
    if (!widget.item.manualDiscount) return;
    bool isPercent = !discountIsPercent;
    double disc = isPercent && discount > 100 ? 100 : discount;
    discountController.text = disc.toString();
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

  void submitUpdate(ItemCart item) async {
    // Submit update
    // close overlay
  }

  void onUpdateItem() async {
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
    submitUpdate(item);
  }

  void onDelete() {
    App.showConfirmDialog(
        title: "${'delete'} ${widget.item.itemName}",
        subtitle: 'are_you_sure',
        confirmLabel: 'delete',
        danger: true,
        onConfirm: () {
          // Close Overlay
        });
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
                child: Text(
                  itemName,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              TextFormField(
                controller: priceController,
                readOnly: widget.item.isManualPrice,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  enabled: !widget.item.isManualPrice,
                  contentPadding:
                      const EdgeInsets.only(left: 0, bottom: 15, right: 0),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  label: Text(
                    'price',
                    style: labelStyle,
                  ),
                  prefix: Text(
                    'price',
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
                      'quantity',
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
                controller: discountController,
                readOnly: !widget.item.manualDiscount,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  enabled: widget.item.manualDiscount,
                  contentPadding:
                      const EdgeInsets.only(left: 0, bottom: 15, right: 0),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  label: Text(
                    'discount',
                    style: labelStyle,
                  ),
                  prefix: Text(
                    'discount',
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
                  contentPadding: const EdgeInsets.only(
                      left: 0, top: 15, right: 0, bottom: 15),
                  // floatingLabelBehavior: FloatingLabelBehavior.never,
                  label: Text(
                    'Note',
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
              Expanded(
                flex: 1,
                child: Container(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    IconButton(
                      color: Colors.red,
                      onPressed: () => onDelete(),
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
                        onPressed: () => onUpdateItem(),
                        icon: const Icon(CupertinoIcons.checkmark_alt),
                        label: Text(
                          CurrencyFormat.currency(total()),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
