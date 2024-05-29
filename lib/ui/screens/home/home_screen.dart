import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide SearchBar;
import 'package:selleri/providers/auth/auth_provider.dart';
import 'package:selleri/providers/cart/cart_provider.dart';
import 'package:selleri/providers/item/item_provider.dart';
import 'package:selleri/providers/shift/shift_provider.dart';
import 'package:selleri/router/routes.dart';
import 'package:selleri/ui/components/open_shift.dart';
import 'package:selleri/utils/app_alert.dart';
import 'package:selleri/utils/formater.dart';
import './components/item_categories.dart';
import 'package:selleri/ui/screens/home/components/item_container.dart';
import 'package:selleri/ui/components/search_app_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/providers/outlet/outlet_provider.dart';
import 'package:go_router/go_router.dart';

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

  bool searchVisible = false;
  TextEditingController textEditingController = TextEditingController();
  ScrollController scrollController = ScrollController();

  void onChangeCategory(String id) {
    setState(() {
      idCategory = id;
      // filter by category
    });
    scrollController.animateTo(0,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  void onSearch(String value) {
    setState(() {
      search = value;
    });
    // Filter by search
    scrollController.animateTo(0,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    // Load items
    ref.read(itemsStreamProvider().notifier).loadItems();
    super.initState();
  }

  void showOpenShift(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return const OpenShift();
        });
  }

  @override
  Widget build(BuildContext context) {
    final outlet = ref.watch(outletNotifierProvider);
    final cart = ref.watch(cartNotiferProvider);
    final shift = ref.watch(shiftNotifierProvider);

    // Check if shift opened
    ref.listen(shiftNotifierProvider, (previous, next) {
      next.whenData((value) {
        if (value == null) {
          showOpenShift(context);
        }
      });
    });

    return Scaffold(
      appBar: searchVisible
          ? SearchAppBar(
              onBack: () => setState(() {
                searchVisible = false;
                textEditingController.text = '';
                search = '';
              }),
              controller: textEditingController,
              onChanged: onSearch,
            )
          : AppBar(
              title: Text(outlet.value is OutletSelected
                  ? (outlet.value as OutletSelected).outlet.outletName
                  : ''),
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  onPressed: () => setState(() {
                    searchVisible = true;
                  }),
                  icon: const Icon(Icons.search),
                ),
                MenuAnchor(
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
                        onPressed: () => context.push(Routes.customers),
                        leadingIcon: Icon(
                          Icons.account_box,
                          color: cart.idCustomer == null
                              ? Colors.grey.shade800
                              : Colors.green.shade600,
                        ),
                        child:
                            Text(cart.customerName ?? 'select_customer'.tr()),
                      ),
                      MenuItemButton(
                        onPressed: onSignOut,
                        leadingIcon: const Icon(
                          Icons.logout,
                          color: Colors.red,
                        ),
                        child: Text('logout'.tr()),
                      ),
                    ])
              ],
            ),
      body: Stack(
        children: [
          Column(
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
                ),
              ),
            ],
          ),
          switch (shift) {
            AsyncData(:final value) => value == null
                ? Positioned.fill(
                    child: Container(
                      color: Colors.black.withOpacity(0.3),
                      child: Center(
                        child: SizedBox(
                          width: 150,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.playlist_add_sharp),
                            label: Text('open_shift'.tr()),
                            onPressed: () => showOpenShift(context),
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(),
            AsyncError(:final error) => Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                  child: Center(
                    child: Text(
                      error.toString(),
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            _ => const Center(
                child: CircularProgressIndicator(),
              )
          },
        ],
      ),
      floatingActionButton: cart.items.isNotEmpty
          ? FloatingActionButton.extended(
              tooltip: 'cart',
              onPressed: () => context.push(Routes.cart),
              label: Text(
                CurrencyFormat.currency(cart.subtotal),
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: Colors.white),
              ),
              extendedIconLabelSpacing: 20,
              icon: Badge(
                label: Text(
                  cart.items.length.toString(),
                ),
                child: const Icon(CupertinoIcons.shopping_cart),
              ),
            )
          : Container(),
    );
  }
}
