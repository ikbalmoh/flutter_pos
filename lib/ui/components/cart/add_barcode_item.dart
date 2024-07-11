import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:selleri/data/models/item.dart';
import 'package:selleri/data/objectbox.dart';
import 'package:selleri/providers/cart/cart_provider.dart';
import 'package:selleri/ui/components/cart/stock_badge.dart';
import 'package:selleri/ui/components/generic/loading_placeholder.dart';
import 'package:selleri/utils/app_alert.dart';
import 'package:selleri/utils/formater.dart';

class AddBarcodeItem extends ConsumerStatefulWidget {
  const AddBarcodeItem({required this.barcode, super.key});

  final String barcode;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddBarcodeItemState();
}

class _AddBarcodeItemState extends ConsumerState<AddBarcodeItem> {
  bool searching = true;
  ScanItemResult result = const ScanItemResult(item: null, variant: null);

  @override
  void initState() {
    searchItem();
    super.initState();
  }

  void searchItem() async {
    final ScanItemResult scanResult =
        objectBox.getItemByBarcode(widget.barcode);
    setState(() {
      searching = false;
      result = scanResult;
    });
  }

  void onAddToCart() {
    ref.read(cartNotiferProvider.notifier).addToCart(
          result.item!,
          variant: result.variant,
        );
    context.pop();
    AppAlert.toast('x_added'.tr(args: [
      result.variant != null
          ? [result.item!.itemName, result.variant!.variantName].join(' - ')
          : result.item!.itemName
    ]));
  }

  bool isAvailable() {
    if (result.item != null) {
      if (result.item!.stockControl == false) {
        return false;
      }
      if (result.variant != null) {
        return result.variant!.stockItem > 0;
      }
      return result.item!.stockItem > 0;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: EdgeInsets.only(
        top: 20,
        left: 15,
        right: 15,
        bottom: MediaQuery.of(context).viewInsets.bottom + 15,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Header(barcode: widget.barcode, textTheme: textTheme),
          const SizedBox(height: 20),
          searching
              ? LoadingPlaceholder(
                  label: 'searching'.tr(),
                )
              : result.item != null
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: 1,
                              color: Colors.teal,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      result.variant != null
                                          ? [
                                              result.item!.itemName,
                                              result.variant?.variantName
                                            ].join(' - ')
                                          : result.item!.itemName,
                                      style: textTheme.bodyLarge,
                                    ),
                                    const SizedBox(height: 5),
                                    StockBadge(
                                        stockItem: result.variant != null
                                            ? result.variant!.stockItem
                                            : result.item!.stockItem,
                                        stockControl:
                                            result.item!.stockControl),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                CurrencyFormat.currency(
                                  result.variant?.itemPrice ??
                                      result.item!.itemPrice,
                                ),
                                style: textTheme.bodyMedium
                                    ?.copyWith(color: Colors.black54),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        isAvailable()
                            ? TextButton(
                                onPressed: onAddToCart,
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.teal,
                                  foregroundColor: Colors.white,
                                  disabledBackgroundColor: Colors.grey,
                                  disabledForegroundColor: Colors.white,
                                ),
                                child: Text('add_to_cart'.tr()),
                              )
                            : TextButton.icon(
                                onPressed: () => context.pop(),
                                icon:
                                    const Icon(Icons.document_scanner_outlined),
                                label: Text('scan_another_item'.tr()),
                              )
                      ],
                    )
                  : const ItemNotFound()
        ],
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({
    super.key,
    required this.barcode,
    required this.textTheme,
  });

  final String barcode;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Icon(
          CupertinoIcons.barcode,
          size: 20,
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(
            barcode,
            style: textTheme.bodyLarge,
          ),
        ),
        IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.close,
            color: Colors.grey.shade700,
          ),
        )
      ],
    );
  }
}

class ItemNotFound extends StatelessWidget {
  const ItemNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: 15,
        ),
        Icon(
          CupertinoIcons.doc_text_search,
          size: 45,
          color: Colors.blueGrey.shade300,
        ),
        const SizedBox(
          height: 15,
        ),
        Text(
          'x_not_found'.tr(args: ['item'.tr()]),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.blueGrey.shade300,
              ),
        ),
        const SizedBox(
          height: 20,
        ),
        TextButton.icon(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.document_scanner_outlined),
          label: Text('scan_another_item'.tr()),
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }
}
