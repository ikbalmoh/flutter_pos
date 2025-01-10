import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:selleri/data/models/item_cart.dart';
import 'package:selleri/data/models/outlet_config.dart';
import 'package:selleri/providers/cart/cart_provider.dart';
import 'package:selleri/ui/components/generic/discount_type_toggle.dart';
import 'package:selleri/ui/components/generic/qty_editor.dart';
import 'package:selleri/ui/components/pic_picker.dart';
import 'package:selleri/utils/formater.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class EditCartItemForm extends ConsumerStatefulWidget {
  final ItemCart item;
  final Function onDelete;

  const EditCartItemForm(
      {super.key, required this.item, required this.onDelete});

  @override
  ConsumerState<EditCartItemForm> createState() => _EditCartItemFormState();
}

class _EditCartItemFormState extends ConsumerState<EditCartItemForm> {
  final priceController = TextEditingController();
  final noteController = TextEditingController();

  final _priceFormater = CurrencyFormat.currencyInput();
  final _discountFormater = CurrencyFormat.currencyInput();

  late double price;
  late double discount;
  late int qty;
  late bool discountIsPercent;
  String? picDetailId;
  String? picName;

  @override
  void initState() {
    super.initState();

    setState(() {
      price = widget.item.price;
      discount = widget.item.discount;
      qty = widget.item.quantity;
      discountIsPercent = widget.item.discountIsPercent;
      picDetailId = widget.item.picDetailId;
      picName = widget.item.picName;
    });

    priceController.text = _priceFormater.formatDouble(widget.item.price);
    noteController.text = widget.item.note ?? '';

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
      picDetailId: picDetailId,
      picName: picName,
    );
    // Update Item
    ref.read(cartProvider.notifier).updateItem(item);
    context.pop();
  }

  void onSelectPic() async {
    PersonInCharge? pic = await showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.white,
        context: context,
        enableDrag: true,
        builder: (context) {
          return PicPicker(
            selected: widget.item.picDetailId,
          );
        });

    if (pic != null) {
      setState(() {
        picDetailId = pic.id;
        picName = pic.name;
      });
    }
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    itemName,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                picDetailId != null
                    ? Chip(
                        label: Text(picName ?? 'pic'.tr()),
                        deleteIcon: const Icon(
                          Icons.close,
                          size: 16,
                        ),
                        avatar: const Icon(
                          CupertinoIcons.person_circle_fill,
                          color: Colors.teal,
                          size: 22,
                        ),
                        deleteIconColor: Colors.red,
                        onDeleted: () => setState(() {
                          picDetailId = null;
                          picName = null;
                        }),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: const BorderSide(
                            color: Colors.teal,
                          ),
                        ),
                      )
                    : ActionChip(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        label: Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Text('pic'.tr()),
                        ),
                        avatar: Icon(
                          CupertinoIcons.person_circle,
                          color: Colors.grey.shade600,
                          size: 22,
                        ),
                        onPressed: onSelectPic,
                      )
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                children: [
                  TextFormField(
                    inputFormatters: <TextInputFormatter>[_priceFormater],
                    onChanged: (value) {
                      setState(() {
                        price = _priceFormater.getUnformattedValue().toDouble();
                      });
                    },
                    readOnly: !widget.item.isManualPrice,
                    textAlign: TextAlign.right,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      enabled: widget.item.isManualPrice,
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
                    ),
                    controller: priceController,
                    onTap: () => priceController.selection = TextSelection(
                      baseOffset: 0,
                      extentOffset: priceController.value.text.length,
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
                    initialValue:
                        _discountFormater.formatDouble(widget.item.discount),
                    onChanged: onChangeDiscountValue,
                    readOnly: !widget.item.manualDiscount,
                    textAlign: TextAlign.right,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      enabled: widget.item.manualDiscount &&
                          widget.item.promotion == null,
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
                      suffix: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: DiscountTypeToggle(
                          isPercent: discountIsPercent,
                          onChange: widget.item.promotion == null
                              ? onChangeDiscountType
                              : null,
                        ),
                      ),
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
