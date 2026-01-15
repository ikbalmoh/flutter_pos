import 'dart:async';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:selleri/features/item/model/item.dart';
import 'package:selleri/features/pos/provider/pos_provider.dart';
import 'package:selleri/shared/objectbox.dart';
import 'package:selleri/features/auth/provider/auth_provider.dart';
import 'package:selleri/features/cart/provider/cart_provider.dart';
import 'package:selleri/features/item/provider/item_provider.dart';
import 'package:selleri/features/shift/provider/shift_provider.dart';
import 'package:selleri/shared/widget/app_drawer/app_drawer.dart';
import 'package:selleri/shared/widget/barcode_scanner/barcode_scanner.dart';
import 'package:selleri/features/cart/widget/components/add_barcode_item.dart';
import 'package:selleri/shared/widget/connection_baner_widget.dart';
import 'package:selleri/shared/widget/update_patcher.dart';
import 'package:selleri/features/cart/widget/cart_screen.dart';
import 'package:selleri/features/pos/widget/components/bottom_action.dart';
import 'package:selleri/features/pos/widget/components/filter_items_sheet.dart';
import 'package:selleri/features/pos/widget/components/holded_baner.dart';
import 'package:selleri/features/pos/widget/components/home_menu.dart';
import 'package:selleri/features/pos/widget/components/shift_overlay.dart';
import 'package:selleri/shared/widget/loading_widget.dart';
import 'package:selleri/shared/utils/app_alert.dart';
import 'components/item_categories.dart';
import 'package:selleri/features/pos/widget/components/item_container.dart';
import 'package:selleri/shared/widget/search_app_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/features/outlet/provider/outlet_provider.dart';
import 'package:visibility_detector/visibility_detector.dart';

class PosScreen extends ConsumerStatefulWidget {
  const PosScreen({super.key});

  @override
  ConsumerState<PosScreen> createState() => _PosScreenState();
}

class _PosScreenState extends ConsumerState<PosScreen>
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
    WidgetsFlutterBinding.ensureInitialized();
    Future.delayed(Duration(seconds: 2), loadShift);
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      log('APP RESUMED');
      refreshData();
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  Future<void> refreshData() async {
    await ref.read(outletProvider.notifier).refreshConfig();
    if (!mounted) return;
    await ref.read(itemsProvider().notifier).syncItems();
    return;
  }

  Future<void> loadShift() async {
    await refreshData();
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
        useSafeArea: true,
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
      useSafeArea: true,
      builder: (context) {
        return AddBarcodeItem(barcode: barcode);
      },
    );
    if (!mounted) return;
    cb();
  }

  void onBarcodeScanned(barcode) {
    if (!canListenBarcode) return;
    log('barcodes canned: $barcode');
    ScanItemResult result = objectBox.getItemByBarcode(barcode);
    if (result.item != null) {
      final isStockAvailable = ref
          .read(itemsProvider().notifier)
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
      AppAlert.snackbar('x_not_found'.tr(args: [barcode]),
          alertType: AlertType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final outlet = ref.watch(outletProvider);
    final cart = ref.watch(cartProvider);

    ref.read(posProvider.notifier).build();

    final isTablet = ResponsiveBreakpoints.of(context).largerThan(MOBILE);

    var itemContainer = VisibilityDetector(
      onVisibilityChanged: (info) {
        if (context.mounted) {
          setState(() {
            canListenBarcode = info.visibleFraction > 0;
          });
        }
      },
      key: const Key('visible-detector-key'),
      child: BarcodeKeyboardListener(
        bufferDuration: const Duration(milliseconds: 200),
        onBarcodeScanned: onBarcodeScanned,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            ConnectionBanerWidget(),
            !isTablet ? HoldedBaner(cart: cart) : Container(),
            AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              height: searchVisible ? 0 : 56,
              child: ItemCategories(
                active: idCategory,
                filterStock: filterStock,
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
                allowStockMinus: outlet.value is OutletSelected
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
                    icon: const Icon(CupertinoIcons.barcode_viewfinder))
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
                          visualDensity: VisualDensity.comfortable,
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
                          visualDensity: VisualDensity.comfortable,
                        ),
                      ],
                const HomeMenu()
              ],
              actionsPadding: const EdgeInsets.only(right: 10),
            ),
      body: Stack(
        children: [
          SafeArea(
            child: Row(
              children: [
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: refreshData,
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
          ),
          const ShiftOverlay(),
          const UpdatePatcher(),
          ref.watch(authProvider).when(
                data: (_) => Container(),
                error: (_, stackTrace) => Container(),
                loading: () => Positioned.fill(
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.3),
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
