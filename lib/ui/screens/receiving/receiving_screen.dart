import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:selleri/data/models/receiving/purchase_item.dart';
import 'package:selleri/data/models/receiving/purchase_item_variant.dart';
import 'package:selleri/data/models/receiving/receiving_item.dart';
import 'package:selleri/providers/receiving/purchase_info_provider.dart';
import 'package:selleri/providers/receiving/receiving_provider.dart';
import 'package:selleri/router/routes.dart';
import 'package:selleri/ui/components/app_drawer/app_drawer.dart';
import 'package:selleri/ui/components/barcode_scanner/barcode_scanner.dart';
import 'package:selleri/ui/components/error_handler.dart';
import 'package:selleri/ui/components/generic/item_list_skeleton.dart';
import 'package:selleri/ui/screens/receiving/components/enter_purchase_item_code.dart';
import 'package:selleri/ui/screens/receiving/components/purchase_item_variant_picker.dart';
import 'package:selleri/ui/screens/receiving/components/receive_item_form.dart';
import 'package:selleri/ui/screens/receiving/components/purchase_item_list.dart';
import 'package:selleri/ui/screens/receiving/components/receiving_cart.dart';
import 'package:selleri/utils/app_alert.dart';
import 'package:selleri/utils/formater.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ReceivingScreen extends ConsumerStatefulWidget {
  const ReceivingScreen({super.key, required this.type, this.code});

  final String type;
  final String? code;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ReceivingScreenState();
}

class _ReceivingScreenState extends ConsumerState<ReceivingScreen> {
  String type = '1';
  TextEditingController codeController = TextEditingController();
  FocusNode codeFocus = FocusNode();
  bool canListenBarcode = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      String initialCode = widget.code?.trim() ?? '';
      setState(() {
        type = widget.type;
        codeController.text = initialCode;
      });
      if (initialCode.isNotEmpty) {
        submitCode();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    codeController.dispose();
    codeFocus.dispose();
    super.dispose();
  }

  void onChangeType(String value) {
    codeFocus.unfocus();
    final info = ref.watch(purchaseInfoProvider);
    if (type == value) return;
    if (info.value!.items.isNotEmpty) {
      AppAlert.confirm(context,
          title: 'change_receiving_type'.tr(),
          subtitle: 'change_receiving_type_note'.tr(), onConfirm: () {
        setState(() {
          type = value;
          codeController.text = '';
        });
        ref.read(purchaseInfoProvider.notifier).reset();
      });
    } else {
      setState(() {
        type = value;
        codeController.text = '';
      });
      ref.read(purchaseInfoProvider.notifier).reset();
    }
  }

  void onClearCode() {
    setState(() {
      codeController.text = '';
    });
    ref.read(purchaseInfoProvider.notifier).reset();
  }

  void submitCode() {
    codeFocus.unfocus();
    if (codeController.text.isEmpty) {
      return;
    }
    ref
        .read(purchaseInfoProvider.notifier)
        .loadInfo(search: codeController.text, type: int.parse(type));
  }

  void onBarcodeScanned(barcode) {
    if (!canListenBarcode) return;
    log('barcode scanned: $barcode');
    codeController.text = barcode;
    submitCode();
  }

  void onDeleteItem(ReceivingItem item) {
    if (context.canPop()) {
      context.pop();
    }
    AppAlert.confirm(context,
        title: "${'delete'.tr()} ${item.itemName}",
        subtitle: 'are_you_sure'.tr(),
        confirmLabel: 'delete'.tr(),
        danger: true, onConfirm: () async {
      ref
          .read(receivingProvider.notifier)
          .removeItem(item.itemId, variantId: item.variantId);
    });
  }

  void showReceiveItemForm(PurchaseItem item, {PurchaseItemVariant? variant}) {
    if (item.variantId == null && variant != null) {
      item = item.copyWith(
        itemName: '${item.itemName} - ${variant.variantName}',
        variantId: variant.variantId,
      );
    }
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        builder: (context) {
          return ReceiveItemForm(
            item: item,
            onDelete: () => onDeleteItem(ReceivingItem.fromPurchaseItem(item)),
          );
        });
  }

  void onItemScanned(PurchaseItem item,
      {PurchaseItemVariant? variant, required String barcode}) {
    context.pop();
    if (variant != null) {
      item = item.copyWith(skuNumber: variant.skuNumber);
    }
    if (item.skuNumber != barcode) {
      AppAlert.confirm(
        context,
        title: 'sku_item_different'.tr(),
        subtitle: 'sku_item_different_note'.tr(),
        onConfirm: () {
          context.pop();
          showReceiveItemForm(item.copyWith(skuNumber: barcode),
              variant: variant);
        },
        confirmLabel: 'repalce_sku'.tr(),
        shouldPop: false,
      );
    } else {
      showReceiveItemForm(item, variant: variant);
    }
  }

  void onItemNeedTobeScanned(PurchaseItem item,
      {PurchaseItemVariant? variant}) {
    String itemName = item.itemName;
    if (variant != null) {
      itemName += ' - ${variant.variantName}';
    }
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        isScrollControlled: true,
        builder: (context) {
          return EnterPurchaseItemCode(
              itemName: itemName,
              onSubmit: (code) {
                onItemScanned(item, variant: variant, barcode: code);
              });
        });
  }

  void onReceiveItem(PurchaseItem item, {PurchaseItemVariant? variant}) {
    if (variant == null && item.variants != null && item.variants!.isNotEmpty) {
      showModalBottomSheet(
          context: context,
          backgroundColor: Colors.white,
          isScrollControlled: true,
          useSafeArea: true,
          builder: (BuildContext context) {
            return DraggableScrollableSheet(
              builder: (context, controller) => PurchaseItemVariantPicker(
                scrollController: controller,
                item: item,
                onSelect: (variant) {
                  context.pop();
                  onReceiveItem(item, variant: variant);
                },
                type: type,
              ),
              minChildSize: 0.3,
              maxChildSize: 0.9,
              expand: false,
            );
          });
      return;
    }
    if (type == '1') {
      onItemNeedTobeScanned(item, variant: variant);
    } else {
      showReceiveItemForm(item, variant: variant);
    }
  }

  void pickReceiveDate() async {
    DateTime date = DateTime.now();
    DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: date.subtract(const Duration(days: 180)),
      lastDate: DateTime.now(),
      initialDate: date,
    );
    if (pickedDate != null) {
      ref.read(receivingProvider.notifier).setDate(pickedDate);
    }
  }

  void onBarcodeCaptured(String code, Function cb) {
    setState(() {
      codeController.text = code;
    });
    submitCode();
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveBreakpoints.of(context).largerThan(MOBILE);

    AsyncValue purchaseInfo = ref.watch(purchaseInfoProvider);

    Widget typeSelector = Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: ActionChip(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: type == '1'
                ? Colors.teal.shade400
                : Colors.teal.shade50.withValues(alpha: 0.5),
            labelStyle: TextStyle(
              color: type == '1' ? Colors.white : Colors.teal,
            ),
            onPressed: () => onChangeType('1'),
            label: Text('purchase'.tr()),
            side: const BorderSide(color: Colors.transparent),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: ActionChip(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: type == '2'
                ? Colors.teal.shade400
                : Colors.teal.shade50.withValues(alpha: 0.5),
            labelStyle: TextStyle(
              color: type == '2' ? Colors.white : Colors.teal,
            ),
            onPressed: () => onChangeType('2'),
            label: Text('transfer'.tr()),
            side: const BorderSide(color: Colors.transparent),
          ),
        ),
      ],
    );

    Widget codeSearchInput = TextFormField(
      textInputAction: TextInputAction.search,
      controller: codeController,
      readOnly: purchaseInfo is AsyncLoading ||
          (purchaseInfo is AsyncData && purchaseInfo.value!.items.isNotEmpty),
      onChanged: (value) => setState(() {
        codeController.text = value;
      }),
      onEditingComplete: submitCode,
      focusNode: codeFocus,
      decoration: InputDecoration(
        labelText: 'search_x'.tr(
            args: [type == '1' ? 'purchase_code'.tr() : 'transfer_code'.tr()]),
        hintText: type == '1' ? 'purchase_code'.tr() : "transfer_code".tr(),
        labelStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.grey.shade600,
            ),
        suffixIcon: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            codeController.text != ''
                ? IconButton(
                    onPressed: onClearCode,
                    icon: const Icon(
                      CupertinoIcons.xmark,
                      size: 16,
                    ),
                  )
                : Container()
          ],
        ),
        prefixIcon: const Icon(Icons.search),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 15,
        ),
        alignLabelWithHint: false,
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
          borderSide: BorderSide(
            width: 1,
            color: Colors.grey.shade400,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
          borderSide: BorderSide(
            width: 1,
            color: Colors.teal.shade400,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
          borderSide: BorderSide(
            width: 1,
            color: Colors.red.shade400,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
          borderSide: BorderSide(
            width: 1,
            color: Colors.teal.shade400,
          ),
        ),
      ),
    );

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('receiving'.tr()),
          leading: Builder(builder: (context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(Icons.menu),
            );
          }),
          elevation: 1,
          actions: [
            isTablet
                ? TextButton.icon(
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.teal.shade50),
                    onPressed: pickReceiveDate,
                    label: Text(DateTimeFormater.dateToString(
                        ref.watch(receivingProvider).receiveDate,
                        format: 'd MMM y')),
                    icon: const Icon(CupertinoIcons.calendar),
                  )
                : Container(),
            MenuAnchor(
              style: MenuStyle(backgroundColor:
                  WidgetStateProperty.resolveWith<Color?>(
                      (Set<WidgetState> states) {
                return Colors.white;
              })),
              builder: (BuildContext context, MenuController controller,
                  Widget? child) {
                return IconButton(
                  onPressed: () {
                    if (controller.isOpen) {
                      controller.close();
                    } else {
                      controller.open();
                    }
                  },
                  icon: const Icon(Icons.more_vert),
                  tooltip: 'show_menu'.tr(),
                );
              },
              menuChildren: [
                MenuItemButton(
                  leadingIcon: const Icon(CupertinoIcons.square_list),
                  onPressed: () => context.push(Routes.receivingHistory),
                  child: Text('receiving_history'.tr()),
                ),
              ],
            )
          ]),
      body: Row(
        children: [
          Expanded(
            child: VisibilityDetector(
              onVisibilityChanged: (info) {
                if (context.mounted) {
                  setState(() {
                    canListenBarcode = info.visibleFraction > 0;
                  });
                }
              },
              key: const Key('receiving-visible-detector-key'),
              child: BarcodeKeyboardListener(
                bufferDuration: const Duration(milliseconds: 200),
                onBarcodeScanned: onBarcodeScanned,
                child: Column(
                  children: [
                    isTablet
                        ? Container()
                        : Material(
                            color: Colors.teal.shade50,
                            child: InkWell(
                              onTap: pickReceiveDate,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Row(
                                  children: [
                                    Icon(CupertinoIcons.calendar,
                                        color: Colors.teal.shade600),
                                    const SizedBox(width: 10),
                                    Text(
                                      DateTimeFormater.dateToString(
                                          ref
                                              .watch(receivingProvider)
                                              .receiveDate,
                                          format: 'd MMM y'),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: Colors.teal.shade600,
                                          ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: typeSelector,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Expanded(child: codeSearchInput),
                          const SizedBox(width: 5),
                          IconButton(
                            onPressed: () {
                              showCupertinoModalPopup(
                                  context: context,
                                  builder: (context) {
                                    return BarcodeScanner(
                                      onCaptured: onBarcodeCaptured,
                                      title: 'scan_x'.tr(args: [
                                        type == '1'
                                            ? 'purchase_code'.tr()
                                            : 'transfer_code'.tr()
                                      ]),
                                    );
                                  });
                            },
                            icon: const Icon(CupertinoIcons.barcode_viewfinder),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: ref.watch(purchaseInfoProvider).when(
                            data: (value) => value.items.isEmpty
                                ? SingleChildScrollView(
                                    padding: const EdgeInsets.only(top: 200),
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    child: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            CupertinoIcons.doc_text_search,
                                            size: 60,
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Text(
                                            'enter_x'.tr(args: [
                                              type == '1'
                                                  ? 'purchase_code'.tr()
                                                  : 'transfer_code'.tr()
                                            ]),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall
                                                ?.copyWith(color: Colors.grey),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    itemCount: value.items.length,
                                    itemBuilder: (context, index) {
                                      PurchaseItem item = value.items[index];
                                      int receiveQty = ref
                                          .watch(receivingProvider.notifier)
                                          .itemQtyReceived(item.itemId,
                                              variantId: item.variantId);
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 3),
                                        child: PurchaseItemList(
                                          item: item,
                                          onReceive: onReceiveItem,
                                          receiveQty: receiveQty,
                                          type: type,
                                        ),
                                      );
                                    },
                                  ),
                            error: (error, stackTrace) => Padding(
                              padding: const EdgeInsets.only(top: 100),
                              child: ErrorHandler(
                                error: 'code_not_found'.tr(),
                                stackTrace: 'please_scan_another_code'.tr(),
                              ),
                            ),
                            loading: () => ListView.builder(
                              shrinkWrap: true,
                              itemBuilder: (context, _) =>
                                  const ItemListSkeleton(
                                leading: false,
                              ),
                              itemCount: 10,
                            ),
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          isTablet
              ? Container(
                  width: ResponsiveBreakpoints.of(context).largerThan(TABLET)
                      ? 400
                      : MediaQuery.of(context).size.width * 0.5,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    border: Border(
                      left: BorderSide(
                        width: 1,
                        color: Colors.grey.shade200,
                      ),
                    ),
                  ),
                  child: const ReceivingCart(
                    asWidget: true,
                  ),
                )
              : Container()
        ],
      ),
      floatingActionButton:
          !isTablet && ref.watch(receivingProvider).items.isNotEmpty
              ? FloatingActionButton.extended(
                  onPressed: () => showCupertinoModalPopup(
                      context: context,
                      builder: (context) => const ReceivingCart()),
                  label: Text('received_items'.tr()),
                  icon: Badge(
                    label: Text(ref
                        .watch(receivingProvider)
                        .items
                        .map((item) => item.qtyReceive)
                        .reduce((a, b) => a + b)
                        .toString()),
                    child: const Icon(CupertinoIcons.cart_fill),
                  ))
              : null,
    );
  }
}
