import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide SearchBar;
import 'package:selleri/data/objectbox.dart';
import 'package:selleri/data/models/item.dart';
import 'package:selleri/providers/cart/cart_provider.dart';
import 'package:selleri/providers/item/item_provider.dart';
import 'package:selleri/router/routes.dart';
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
  void onSignOut() {}

  String idCategory = '';
  String search = '';

  bool searchVisible = false;
  TextEditingController textEditingController = TextEditingController();
  ScrollController scrollController = ScrollController();

  Stream<List<Item>> itemStrem = objectBox.itemsStream();

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
                IconButton(
                  onPressed: () => onSignOut(),
                  icon: const Icon(Icons.logout_outlined),
                )
              ],
            ),
      body: Column(
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
