import 'dart:async';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide SearchBar;
import 'package:responsive_framework/responsive_framework.dart';
import 'package:selleri/data/models/item.dart';
import 'package:selleri/providers/auth/auth_provider.dart';
import 'package:selleri/providers/cart/cart_provider.dart';
import 'package:selleri/providers/item/item_provider.dart';
import 'package:selleri/providers/shift/shift_provider.dart';
import 'package:selleri/ui/components/app_drawer/app_drawer.dart';
import 'package:selleri/ui/components/barcode_scanner/barcode_scanner.dart';
import 'package:selleri/ui/components/update_patcher.dart';
import 'package:selleri/ui/screens/cart/cart_screen.dart';
import 'package:selleri/ui/screens/home/components/bottom_action.dart';
import 'package:selleri/ui/screens/home/components/filter_items_sheet.dart';
import 'package:selleri/ui/screens/home/components/holded_baner.dart';
import 'package:selleri/ui/screens/home/components/home_menu.dart';
import 'package:selleri/ui/screens/home/components/shift_overlay.dart';
import 'package:selleri/ui/widgets/loading_widget.dart';
import './components/item_categories.dart';
import 'package:selleri/ui/screens/home/components/item_container.dart';
import 'package:selleri/ui/components/search_app_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/providers/outlet/outlet_provider.dart';

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
  bool inSync = false;

  FilterStock filterStock = FilterStock.all;

  bool searchVisible = false;
  TextEditingController textEditingController = TextEditingController();
  ScrollController scrollController = ScrollController();

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

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    loadItems();
    if (!ref.read(shiftNotifierProvider).hasValue) {
      ref.read(shiftNotifierProvider.notifier).initShift();
    }
    super.initState();
  }

  Future<void> loadItems() async {
    if (inSync) return;
    setState(() {
      inSync = true;
    });
    await ref.read(itemsStreamProvider().notifier).loadItems();
    setState(() {
      inSync = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final outlet = ref.watch(outletProvider);
    final cart = ref.watch(cartProvider);

    final isTablet = ResponsiveBreakpoints.of(context).largerThan(MOBILE);

    var itemContainer = Column(
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
    );

    final int itemsOnCart = ref.watch(cartNotiferProvider).items.length;

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
              controller: textEditingController,
              onChanged: onSearchItems,
              actions: [
                IconButton(
                    onPressed: () {
                      showCupertinoModalPopup(
                          context: context,
                          builder: (context) {
                            return const BarcodeScanner();
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
                          onPressed: () => setState(() {
                            searchVisible = true;
                          }),
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
                  : Container(),
            ],
          )),
      drawer: const AppDrawer(),
    );
  }
}
