import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide SearchBar;
import 'package:selleri/data/objectbox.dart';
import 'package:selleri/data/models/item.dart';
import 'package:selleri/providers/item/category_provider.dart';
import 'package:selleri/providers/item/item_provider.dart';
import 'package:selleri/utils/formater.dart';
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
  void onSignOut() {}

  String idCategory = '';
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

  void onSearch(String search) {
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

    return Scaffold(
      appBar: searchVisible
          ? SearchAppBar(
              onBack: () => setState(() {
                searchVisible = false;
                textEditingController.text = '';
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
                scrollController: scrollController, idCategory: idCategory),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        tooltip: 'cart',
        onPressed: () => {},
        label: Text(
          CurrencyFormat.currency(0),
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: Colors.white),
        ),
        extendedIconLabelSpacing: 20,
        icon: const Badge(
          label: Text(
            '0',
          ),
          child: Icon(CupertinoIcons.shopping_cart),
        ),
      ),
    );
  }
}
