import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide SearchBar;
import 'package:go_router/go_router.dart';
import 'package:selleri/providers/auth/auth_provider.dart';
import 'package:selleri/providers/cart/cart_provider.dart';
import 'package:selleri/providers/item/item_provider.dart';
import 'package:selleri/router/routes.dart';
import 'package:selleri/ui/screens/home/components/bottom_action.dart';
import 'package:selleri/ui/screens/home/components/home_menu.dart';
import 'package:selleri/ui/screens/home/components/shift_overlay.dart';
import 'package:selleri/utils/app_alert.dart';
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
  void onSignOut() {
    AppAlert.confirm(context,
        title: 'logout'.tr(),
        subtitle: 'logout_confirmation'.tr(),
        onConfirm: () => ref.read(authNotifierProvider.notifier).logout(),
        confirmLabel: 'logout'.tr());
  }

  String idCategory = '';
  String search = '';
  Timer? _debounce;

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
      // do something with query
      setState(() {
        search = value;
      });
      // Filter handled by stream
      scrollController.animateTo(0,
          duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    });
  }

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    // Load items
    ref.read(itemsStreamProvider().notifier).loadItems();
    super.initState();
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
            )
          : AppBar(
              title: Text(outlet.value is OutletSelected
                  ? (outlet.value as OutletSelected).outlet.outletName
                  : ''),
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  tooltip: 'search'.tr(),
                  onPressed: () => setState(() {
                    searchVisible = true;
                  }),
                  icon: const Icon(Icons.search),
                ),
                IconButton(
                  tooltip: 'holded_transactions'.tr(),
                  onPressed: () {
                    context.push(Routes.holded);
                  },
                  icon: const Icon(CupertinoIcons.folder),
                ),
                const HomeMenu()
              ],
            ),
      body: Stack(
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
                ),
              ),
              cart.items.isNotEmpty
                  ? BottomActions(
                      cart: cart,
                    )
                  : Container(),
            ],
          ),
          const ShiftOverlay()
        ],
      ),
    );
  }
}
