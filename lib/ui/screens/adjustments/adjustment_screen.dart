import 'dart:async';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:selleri/data/models/item.dart';
import 'package:selleri/data/objectbox.dart';
import 'package:selleri/ui/components/barcode_scanner/barcode_scanner.dart';
import 'package:selleri/ui/components/search_app_bar.dart';
import 'package:selleri/ui/screens/adjustments/components/item_container.dart';
import 'package:selleri/ui/screens/home/components/item_categories.dart';
import 'package:selleri/utils/app_alert.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';

class AdjustmentScreen extends ConsumerStatefulWidget {
  const AdjustmentScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AdjustmentScreenState();
}

class _AdjustmentScreenState extends ConsumerState<AdjustmentScreen> {
  ScrollController scrollController = ScrollController();

  bool searchVisible = false;
  bool itemLayoutGrid = false;
  String idCategory = '';
  String search = '';

  Timer? _debounce;
  bool canListenBarcode = false;
  FilterStock filterStock = FilterStock.all;
  TextEditingController textSearchController = TextEditingController();
  FocusNode focusSearch = FocusNode();

  void onSearchItems(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        search = value;
      });
      scrollController.animateTo(0,
          duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    });
  }

  void onBarcodeScanned(barcode) {
    if (!canListenBarcode) return;
    log('barcodes canned: $barcode');
    ScanItemResult result = objectBox.getItemByBarcode(barcode);
    if (result.item != null) {
      // ADD TO CART
      AppAlert.toast('x_added'.tr(args: [result.item!.itemName]));
    } else {
      AppAlert.snackbar(context, 'x_not_found'.tr(args: [barcode]));
    }
  }

  void onChangeCategory(String id) {
    setState(() {
      idCategory = id;
    });
    scrollController.animateTo(0,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveBreakpoints.of(context).largerThan(MOBILE);

    var itemContainer = VisibilityDetector(
      onVisibilityChanged: (info) {
        setState(() {
          canListenBarcode = info.visibleFraction > 0;
        });
      },
      key: const Key('visible-detector-key'),
      child: BarcodeKeyboardListener(
        bufferDuration: const Duration(milliseconds: 200),
        onBarcodeScanned: onBarcodeScanned,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              height: searchVisible ? 0 : 56,
              child: ItemCategories(
                active: idCategory,
                onChange: onChangeCategory,
              ),
            ),
            Expanded(
              child: ItemContainer(
                scrollController: scrollController,
                idCategory: idCategory,
                search: search,
                filterStock: filterStock,
                clearSearch: () {
                  setState(() {
                    search = '';
                    textSearchController.text = '';
                  });
                  focusSearch.requestFocus();
                },
                itemLayoutGrid: itemLayoutGrid,
              ),
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      appBar: searchVisible
          ? SearchAppBar(
              onBack: () => setState(
                    () {
                      searchVisible = false;
                      textSearchController.text = '';
                      search = '';
                    },
                  ),
              onChanged: onSearchItems,
              controller: textSearchController)
          : AppBar(
              title: Text('stock_adjustments'.tr()),
              automaticallyImplyLeading: false,
              elevation: 1,
              leading: Builder(builder: (context) {
                return IconButton(
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    icon: const Icon(Icons.menu));
              }),
              actions: [
                IconButton(
                  tooltip: 'search'.tr(),
                  onPressed: () {
                    setState(() {
                      searchVisible = true;
                    });
                    focusSearch.requestFocus();
                  },
                  icon: const Icon(CupertinoIcons.search),
                ),
                IconButton(
                    onPressed: () {
                      showCupertinoModalPopup(
                          context: context,
                          builder: (context) {
                            return const BarcodeScanner();
                          });
                    },
                    icon: const Icon(Icons.document_scanner_outlined)),
                IconButton(
                  onPressed: () {
                    setState(() {
                      itemLayoutGrid = !itemLayoutGrid;
                    });
                  },
                  icon: Icon(
                    itemLayoutGrid
                        ? CupertinoIcons.rectangle_grid_1x2
                        : CupertinoIcons.square_grid_2x2_fill,
                  ),
                )
              ],
            ),
      body: Row(
        children: [
          Expanded(child: itemContainer),
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
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
