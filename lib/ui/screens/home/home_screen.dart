import 'dart:async';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:selleri/data/models/item.dart';
import 'package:selleri/data/objectbox.dart';
import 'package:selleri/providers/auth/auth_provider.dart';
import 'package:selleri/providers/cart/cart_provider.dart';
import 'package:selleri/providers/item/item_provider.dart';
import 'package:selleri/providers/shift/shift_provider.dart';
import 'package:selleri/ui/components/app_drawer/app_drawer.dart';
import 'package:selleri/ui/components/barcode_scanner/barcode_scanner.dart';
import 'package:selleri/ui/components/cart/add_barcode_item.dart';
import 'package:selleri/ui/components/update_patcher.dart';
import 'package:selleri/ui/screens/cart/cart_screen.dart';
import 'package:selleri/ui/screens/home/components/bottom_action.dart';
import 'package:selleri/ui/screens/home/components/filter_items_sheet.dart';
import 'package:selleri/ui/screens/home/components/holded_baner.dart';
import 'package:selleri/ui/screens/home/components/home_menu.dart';
import 'package:selleri/ui/screens/home/components/shift_overlay.dart';
import 'package:selleri/ui/widgets/loading_widget.dart';
import 'package:selleri/utils/app_alert.dart';
import './components/item_categories.dart';
import 'package:selleri/ui/screens/home/components/item_container.dart';
import 'package:selleri/ui/components/search_app_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/providers/outlet/outlet_provider.dart';
import 'package:visibility_detector/visibility_detector.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with WidgetsBindingObserver {
  String idCategory = '';
  String search = '';
  Timer? _debounce;

  FilterStock filterStock = FilterStock.all;

  bool searchVisible = false;
  TextEditingController textEditingController = TextEditingController();
  ScrollController scrollController = ScrollController();
  FocusNode focusSearch = FocusNode();

  bool canListenBarcode = false;

  void onChangeCategory(String id) {
    setState(() {
      idCategory = id;
    });
    scrollController.animateTo(0,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

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

  @override
  void initState() {
    loadShift();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      refreshItems();
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  Future<void> refreshItems() async {
    return ref.read(itemsStreamProvider().notifier).syncItems();
  }

  Future<void> loadShift() async {
    final currentShift = ref.read(shiftProvider).value;
    if (currentShift == null) {
      ref.read(shiftProvider.notifier).initShift();
    }
  }

  void onFilterItems() async {
    FilterStock? result = await showModalBottomSheet(
        showDragHandle: true,
        backgroundColor: Colors.white,
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return FilterItemsSheet(selected: filterStock);
        });

    if (result != null && result != filterStock) {
      setState(() {
        filterStock = result;
      });
      scrollController.animateTo(0,
          duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    }
  }

  void onBarcodeCaptured(barcode, cb) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isDismissible: true,
      builder: (context) {
        return AddBarcodeItem(barcode: barcode);
      },
    );
    cb();
  }

  void onBarcodeScanned(barcode) {
    if (!canListenBarcode) return;
    log('barcodes canned: $barcode');
    ScanItemResult result = objectBox.getItemByBarcode(barcode);
    if (result.item != null) {
      final isStockAvailable = ref
          .read(ItemsStreamProvider().notifier)
          .isScannedItemStockAvailable(result);
      if (isStockAvailable == false) {
        AppAlert.confirm(
          context,
          title: result.item!.itemName,
          subtitle: 'x_stock_empty'.tr(args: [result.item!.itemName]),
        );
        return;
      }
      ref.read(cartProvider.notifier).addToCart(
            result.item!,
            variant: result.variant,
          );
      AppAlert.toast('x_added'.tr(args: [result.item!.itemName]));
    } else {
      AppAlert.snackbar(context, 'x_not_found'.tr(args: [barcode]));
    }
  }

  @override
  Widget build(BuildContext context) {
    final outlet = ref.watch(outletProvider);
    final cart = ref.watch(cartProvider);

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
            !isTablet ? HoldedBaner(cart: cart) : Container(),
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
                    textEditingController.text = '';
                  });
                  focusSearch.requestFocus();
                },
                allowEmptyStock: outlet.value is OutletSelected
                    ? (outlet.value as OutletSelected).config.stockMinus
                    : false,
              ),
            ),
            cart.items.isNotEmpty && !isTablet
                ? BottomActions(
                    cart: cart,
                  )
                : Container(),
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
                  textEditingController.text = '';
                  search = '';
                },
              ),
              focusNode: focusSearch,
              controller: textEditingController,
              onChanged: onSearchItems,
              actions: [
                IconButton(
                    onPressed: () {
                      showCupertinoModalPopup(
                          context: context,
                          builder: (context) {
                            return BarcodeScanner(
                              onCaptured: onBarcodeCaptured,
                            );
                          });
                    },
                    icon: const Icon(Icons.document_scanner_outlined))
              ],
            )
          : AppBar(
              title: Text(outlet.value is OutletSelected
                  ? (outlet.value as OutletSelected).outlet.outletName
                  : ''),
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
                ...ref.watch(shiftProvider).value == null
                    ? []
                    : [
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
                          tooltip: 'filter_items'.tr(),
                          onPressed: onFilterItems,
                          icon: Badge(
                            smallSize: 8,
                            backgroundColor: filterStock != FilterStock.all
                                ? Colors.teal
                                : Colors.transparent,
                            child: const Icon(Icons.filter_list_rounded),
                          ),
                        ),
                      ],
                const HomeMenu()
              ],
            ),
      body: Stack(
        children: [
          Row(
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: refreshItems,
                  child: itemContainer,
                ),
              ),
              isTablet
                  ? Container(
                      width:
                          ResponsiveBreakpoints.of(context).largerThan(TABLET)
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
                            child: const CartScreen(asWidget: true),
                          )),
                    )
                  : Container()
            ],
          ),
          const ShiftOverlay(),
          const UpdatePatcher(),
          ref.watch(authProvider).when(
                data: (_) => Container(),
                error: (_, stackTrace) => Container(),
                loading: () => Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.3),
                    child: const Center(
                      child: LoadingIndicator(color: Colors.teal),
                    ),
                  ),
                ),
              )
        ],
      ),
      drawer: const AppDrawer(),
    );
  }
}
