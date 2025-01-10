import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:selleri/data/models/item_cart.dart';
import 'package:selleri/providers/cart/cart_provider.dart';
import 'package:selleri/ui/components/generic/qty_editor.dart';
import 'package:selleri/utils/formater.dart';
import 'package:uuid/uuid.dart';

class AddExtraItemForm extends ConsumerStatefulWidget {
  const AddExtraItemForm({super.key, this.scrollController});

  final ScrollController? scrollController;

  @override
  ConsumerState<AddExtraItemForm> createState() => _AddExtraItemFormState();
}

class _AddExtraItemFormState extends ConsumerState<AddExtraItemForm> {
  final _formKey = GlobalKey<FormState>();
  final _priceFormater = CurrencyFormat.currencyInput();
  final _purchasePriceFormater = CurrencyFormat.currencyInput();

  final _itemNameController = TextEditingController();
  final _itemSellingPriceController = TextEditingController();
  final _purchasePriceController = TextEditingController();

  double itemSellingPrice = 0;
  double itemPurchasePrice = 0;
  double initialStock = 1;
  int qty = 1;

  void resetForm() {
    _formKey.currentState!.reset();
    _itemNameController.text = '';
    _itemSellingPriceController.text = '';
    _purchasePriceController.text = '';
    setState(() {
      itemSellingPrice = 0;
      itemPurchasePrice = 0;
    });
  }

  void _submitItem() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    var uuid = const Uuid();

    String identifier = uuid.v4();

    ItemCart item = ItemCart(
      idItem: identifier,
      identifier: identifier,
      idCategory: null,
      itemName: _itemNameController.text,
      extraName: _itemNameController.text,
      isExtraItem: true,
      isPackage: false,
      isManualPrice: true,
      price: itemSellingPrice,
      purchasePrice: itemPurchasePrice,
      total: itemSellingPrice * qty,
      manualDiscount: false,
      note: '',
      quantity: qty,
      discount: 0,
      discountIsPercent: true,
      discountTotal: 0,
      details: [],
    );

    ref.read(cartProvider.notifier).addItemCart(item);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle? labelStyle = Theme.of(context)
        .textTheme
        .bodyMedium
        ?.copyWith(color: Colors.blueGrey.shade600);

    return SizedBox(
      height: (MediaQuery.of(context).size.height *
          (MediaQuery.of(context).viewInsets.bottom > 0 ? 0.95 : 0.6)),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.only(
                  top: 5, left: 12.5, right: 12.5, bottom: 5),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                color: Colors.white,
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
                    'add_extra_item'.tr(),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.close),
                  )
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(10).copyWith(
                    bottom: MediaQuery.of(context).viewInsets.bottom + 10),
                child: Card(
                  elevation: 0,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
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
                          autofocus: true,
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
                            itemPurchasePrice = _purchasePriceFormater
                                .getUnformattedValue()
                                .toDouble();
                          }),
                          inputFormatters: <TextInputFormatter>[
                            _purchasePriceFormater
                          ],
                          controller: _purchasePriceController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'enter_x'
                                  .tr(args: ['purchase_price'.tr()]);
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
                              'selling_price'.tr(),
                              style: labelStyle,
                            ),
                            alignLabelWithHint: true,
                          ),
                          onChanged: (value) => setState(() {
                            itemSellingPrice =
                                _priceFormater.getUnformattedValue().toDouble();
                          }),
                          controller: _itemSellingPriceController,
                          inputFormatters: <TextInputFormatter>[_priceFormater],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'enter_x'.tr(args: ['price'.tr()]);
                            }
                            return null;
                          },
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
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(30),
                    ),
                  ),
                ),
                onPressed: _submitItem,
                label: Text('add'.tr(args: ['extra_item'.tr()])),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
