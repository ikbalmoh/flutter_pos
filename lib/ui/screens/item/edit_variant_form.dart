import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:selleri/data/models/item_variant.dart';
import 'package:selleri/utils/formater.dart';

class EditVariantForm extends StatefulWidget {
  final ItemVariant variant;

  const EditVariantForm({super.key, required this.variant});

  @override
  State<EditVariantForm> createState() => _EditVariantFormState();
}

class _EditVariantFormState extends State<EditVariantForm> {
  final _formKey = GlobalKey<FormState>();
  final _priceFormater = CurrencyFormat.currencyInput();

  final _priceController = TextEditingController();
  final _skuController = TextEditingController();
  final _barcodeController = TextEditingController();

  double price = 0;

  @override
  void initState() {
    _priceController.text =
        _priceFormater.formatDouble(widget.variant.itemPrice);
    _skuController.text = widget.variant.skuNumber.toString();
    _barcodeController.text = widget.variant.barcodeNumber.toString();

    setState(() {
      price = widget.variant.itemPrice;
    });
    super.initState();
  }

  void onSubmit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    ItemVariant attribute = ItemVariant(
      id: widget.variant.id,
      idItem: widget.variant.idItem,
      idVariant: widget.variant.idVariant,
      itemPrice: price,
      variantName: widget.variant.variantName,
      stockItem: widget.variant.stockItem,
      skuNumber: _skuController.text,
      barcodeNumber: _barcodeController.text,
    );
    context.pop(attribute);
  }

  @override
  Widget build(BuildContext context) {
    TextStyle? labelStyle = Theme.of(context)
        .textTheme
        .bodyMedium
        ?.copyWith(color: Colors.blueGrey.shade600);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      height: MediaQuery.of(context).size.height *
          (MediaQuery.of(context).viewInsets.bottom > 0 ? 0.9 : 0.7),
      child: Column(
        children: [
          Container(
            width: double.infinity,
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
              widget.variant.variantName,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          Expanded(
              child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    inputFormatters: <TextInputFormatter>[_priceFormater],
                    onChanged: (value) {
                      setState(() {
                        price = _priceFormater.getUnformattedValue().toDouble();
                      });
                    },
                    textAlign: TextAlign.right,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
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
                    controller: _priceController,
                    onTap: () => _priceController.selection = TextSelection(
                      baseOffset: 0,
                      extentOffset: _priceController.value.text.length,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'field_required'
                            .tr(args: ['price'.tr().toLowerCase()]);
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    textAlign: TextAlign.right,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.only(left: 0, bottom: 15, right: 0),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      label: Text(
                        'SKU'.tr(),
                        style: labelStyle,
                      ),
                      prefix: Text(
                        'SKU'.tr(),
                        style: labelStyle,
                      ),
                      alignLabelWithHint: true,
                    ),
                    controller: _skuController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'field_required'
                            .tr(args: ['SKU'.tr().toLowerCase()]);
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    textAlign: TextAlign.right,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.only(left: 0, bottom: 15, right: 0),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      label: Text(
                        'Barcode'.tr(),
                        style: labelStyle,
                      ),
                      prefix: Text(
                        'Barcode'.tr(),
                        style: labelStyle,
                      ),
                      alignLabelWithHint: true,
                    ),
                    controller: _barcodeController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'field_required'
                            .tr(args: ['Barcode'.tr().toLowerCase()]);
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          )),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              TextButton(
                style:
                    TextButton.styleFrom(foregroundColor: Colors.grey.shade600),
                onPressed: () => context.pop(),
                child: Text('cancel'.tr()),
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
                  onPressed: onSubmit,
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
