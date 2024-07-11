import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide SearchBar;
import 'package:go_router/go_router.dart';
import 'package:selleri/providers/auth/auth_provider.dart';
import 'package:selleri/providers/cart/cart_provider.dart';
import 'package:selleri/providers/item/item_provider.dart';
import 'package:selleri/providers/shift/shift_provider.dart';
import 'package:selleri/router/routes.dart';
import 'package:selleri/ui/components/app_drawer/app_drawer.dart';
import 'package:selleri/ui/components/barcode_scanner/barcode_scanner.dart';
import 'package:selleri/ui/components/update_patcher.dart';
import 'package:selleri/ui/screens/home/components/bottom_action.dart';
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

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String idCategory = '';
  String search = '';
  Timer? _debounce;
  bool inSync = false;

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
    WidgetsFlutterBinding.ensureInitialized();
    loadShift();
    loadItems();
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

  Future<void> loadShift() async {
    final currentShift = ref.read(shiftNotifierProvider).value;
    if (currentShift == null) {
      ref.read(shiftNotifierProvider.notifier).initShift();
    }
  }

  @override
  Widget build(BuildContext context) {
    final outlet = ref.watch(outletNotifierProvider);
    final cart = ref.watch(cartNotiferProvider);

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
              leading: Builder(builder: (context) {
                return IconButton(
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    icon: const Icon(Icons.menu));
              }),
              actions: [
                ...ref.watch(shiftNotifierProvider).value == null
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
                          tooltip: 'holded_transactions'.tr(),
                          onPressed: () {
                            context.push(Routes.holded);
                          },
                          icon: const Icon(CupertinoIcons.folder),
                        ),
                      ],
                const HomeMenu()
              ],
            ),
      body: RefreshIndicator(
          onRefresh: loadItems,
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  ref.watch(cartNotiferProvider).holdAt == null
                      ? Container()
                      : Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade800,
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(0)),
                          ),
                          child: Text(
                            ref.watch(cartNotiferProvider).transactionNo,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
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
                      allowEmptyStock: outlet.value is OutletSelected
                          ? (outlet.value as OutletSelected).config.stockMinus
                          : false,
                    ),
                  ),
                  cart.items.isNotEmpty
                      ? BottomActions(
                          cart: cart,
                        )
                      : Container(),
                ],
              ),
              const ShiftOverlay(),
              const UpdatePatcher(),
              ref.watch(authNotifierProvider).when(
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
          )),
      drawer: const AppDrawer(),
    );
  }
}
