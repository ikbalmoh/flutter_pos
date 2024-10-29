import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/data/models/category.dart';
import 'package:selleri/data/models/item_attribute_variant.dart';
import 'package:selleri/providers/item/category_provider.dart';
import 'package:selleri/ui/screens/item/add_variant_form.dart';
import 'package:selleri/ui/screens/item/store_item.dart';
import 'package:selleri/utils/formater.dart';

class AddItemScreen extends ConsumerStatefulWidget {
  const AddItemScreen({super.key});

  @override
  ConsumerState<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends ConsumerState<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _priceFormater = CurrencyFormat.currencyInput();
  final _stockFormater = CurrencyFormat.currencyInput();
  final _hppFormater = CurrencyFormat.currencyInput();

  final _itemNameController = TextEditingController();
  final _itemPriceController = TextEditingController();
  final _initialStockController = TextEditingController();
  final _hppItemController = TextEditingController();
  final _skuController = TextEditingController();
  final _barcodeController = TextEditingController();

  Category? category;
  double? itemPrice;
  double? initialStock;
  double? hppItem;
  List<AttributeVariant> attributes = [];

  void resetForm() {
    _formKey.currentState!.reset();
    _itemNameController.text = '';
    _itemPriceController.text = '';
    _initialStockController.text = '';
    _hppItemController.text = '';
    _skuController.text = '';
    _barcodeController.text = '';
    setState(() {
      category = null;
      itemPrice = null;
      hppItem = null;
      attributes = [];
    });
  }

  void _submitLogin() async {
    if (category == null) {
      return;
    }
    if (!_formKey.currentState!.validate()) {
      return;
    }
    Map<String, dynamic> itemPayload = {
      'id_category': category?.idCategory,
      'item_name': _itemNameController.text,
      'hpp_item': hppItem,
      'item_price': itemPrice,
      'sku': _skuController.text,
      'barcode': _barcodeController.text,
      'min_stock': 0,
      'initial_stock': _initialStockController.text,
    };

    final isStored = await showModalBottomSheet(
        context: context,
        isDismissible: false,
        isScrollControlled: true,
        enableDrag: false,
        backgroundColor: Colors.white,
        builder: (context) {
          return StoreItem(
            itemPayload: itemPayload,
            attributes: attributes,
          );
        });
    if (isStored) {
      resetForm();
    }
  }

  void onAddVariant() async {
    AttributeVariant? attribute = await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
        backgroundColor: Colors.white,
        builder: (context) {
          return const AddVariantForm();
        });

    if (attribute != null) {
      setState(() {
        attributes = attributes..add(attribute);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveBreakpoints.of(context).largerThan(MOBILE);
    TextStyle? labelStyle = Theme.of(context)
        .textTheme
        .bodyMedium
        ?.copyWith(color: Colors.blueGrey.shade600);

    Card addVariants = Card(
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'variants'.tr(),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                TextButton.icon(
                  style: TextButton.styleFrom(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                  onPressed: onAddVariant,
                  label: Text(
                    'add_variant'.tr(),
                  ),
                  icon: const Icon(
                    CupertinoIcons.add,
                    size: 16,
                  ),
                )
              ],
            ),
            Divider(
              color: Colors.blueGrey.shade50,
              height: 0,
            ),
            attributes.isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 100, horizontal: 30),
                    child: Column(
                      children: [
                        Text(
                          'no_variants_added'.tr(),
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(color: Colors.grey.shade500),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, idx) {
                      AttributeVariant attr = attributes[idx];
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 7.5),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.shade300,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  attr.attrName,
                                  style:
                                      labelStyle?.copyWith(color: Colors.black),
                                ),
                                GestureDetector(
                                  onTap: () => setState(() {
                                    attributes = attributes..removeAt(idx);
                                  }),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Icon(
                                      CupertinoIcons.delete,
                                      size: 16,
                                      color: Colors.red.shade600,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 7.5,
                              direction: Axis.horizontal,
                              children: attr.options
                                  .map((opt) => Chip(
                                        label: Text(opt),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          side: BorderSide(
                                            color: Colors.grey.shade500,
                                          ),
                                        ),
                                      ))
                                  .toList(),
                            )
                          ],
                        ),
                      );
                    },
                    itemCount: attributes.length,
                  ),
          ],
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      appBar: AppBar(
        title: Text('add_item'.tr()),
      ),
      body: Form(
        key: _formKey,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: SingleChildScrollView(
              padding: const EdgeInsets.all(10).copyWith(bottom: 80),
              child: Column(
                children: [
                  Card(
                    elevation: 0,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'item_data'.tr(),
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          Divider(
                            color: Colors.blueGrey.shade50,
                          ),
                          DropdownButton<Category>(
                            items: ref
                                .watch(categoriesStreamProvider)
                                .value
                                ?.map<DropdownMenuItem<Category>>(
                                    (Category category) {
                              return DropdownMenuItem<Category>(
                                value: category,
                                child: Text(category.categoryName),
                              );
                            }).toList(),
                            onChanged: (value) => setState(() {
                              category = value;
                            }),
                            value: category,
                            dropdownColor: Colors.white,
                            hint: Text('select_x'.tr(args: ['category'.tr()])),
                            underline: const SizedBox(),
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(
                                  left: 0, bottom: 5, right: 0),
                              label: Text(
                                'item_name'.tr(),
                                style: labelStyle,
                              ),
                              alignLabelWithHint: true,
                            ),
                            controller: _itemNameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'enter_x'.tr(args: ['item_name'.tr()]);
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(
                                  left: 0, top: 10, bottom: 5, right: 0),
                              label: Text(
                                'price'.tr(),
                                style: labelStyle,
                              ),
                              alignLabelWithHint: true,
                            ),
                            onChanged: (value) => setState(() {
                              itemPrice = _priceFormater
                                  .getUnformattedValue()
                                  .toDouble();
                            }),
                            controller: _itemPriceController,
                            inputFormatters: <TextInputFormatter>[
                              _priceFormater
                            ],
                            // initialValue: itemPrice != null
                            //     ? _priceFormater.formatDouble(itemPrice!)
                            //     : '',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'enter_x'.tr(args: ['price'.tr()]);
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(
                                  left: 0, top: 10, bottom: 5, right: 0),
                              label: Text(
                                'initial_stock'.tr(),
                                style: labelStyle,
                              ),
                              alignLabelWithHint: true,
                            ),
                            controller: _initialStockController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'enter_x'
                                    .tr(args: ['initial_stock'.tr()]);
                              }
                              return null;
                            },
                            inputFormatters: <TextInputFormatter>[
                              _stockFormater
                            ],
                          ),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(
                                  left: 0, top: 10, bottom: 5, right: 0),
                              label: Text(
                                'purchase_price'.tr(),
                                style: labelStyle,
                              ),
                              alignLabelWithHint: true,
                            ),
                            onChanged: (value) => setState(() {
                              hppItem =
                                  _hppFormater.getUnformattedValue().toDouble();
                            }),
                            inputFormatters: <TextInputFormatter>[_hppFormater],
                            controller: _hppItemController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'enter_x'
                                    .tr(args: ['initial_stock'.tr()]);
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(
                                  left: 0, top: 10, bottom: 5, right: 0),
                              label: Text(
                                'SKU',
                                style: labelStyle,
                              ),
                              alignLabelWithHint: true,
                            ),
                            controller: _skuController,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(
                                  left: 0, top: 10, bottom: 5, right: 0),
                              label: Text(
                                'Barcode',
                                style: labelStyle,
                              ),
                              alignLabelWithHint: true,
                            ),
                            controller: _barcodeController,
                          ),
                          const SizedBox(height: 15),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  isTablet ? Container() : addVariants
                ],
              ),
            )),
            isTablet
                ? SizedBox(
                    width: MediaQuery.of(context).size.width - 400,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: addVariants,
                    ),
                  )
                : Container(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.check),
        onPressed: category == null ? null : _submitLogin,
        label: Text('save'.tr()),
      ),
    );
  }
}
