import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide SearchBar;
import 'package:get/get.dart';
import 'package:selleri/data/objectbox.dart';
import 'package:selleri/models/item.dart';
import 'package:selleri/modules/auth/auth.dart';
import 'package:selleri/modules/cart/cart.dart';
import 'package:selleri/modules/item/item.dart';
import 'package:selleri/modules/outlet/outlet.dart';
import 'package:selleri/routes/routes.dart';
import 'package:selleri/utils/formater.dart';
import './components/item_categories.dart';
import 'package:selleri/ui/components/item_container.dart';
import 'package:selleri/ui/components/search_app_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthController authController = Get.find();
  final ItemController itemController = Get.find();
  final OutletController outletController = Get.find();
  final CartController cartController = Get.find();

  String idCategory = '';
  bool searchVisible = false;
  TextEditingController textEditingController = TextEditingController();
  ScrollController scrollController = ScrollController();

  Stream<List<Item>> itemStrem = objectBox.itemsStream();

  void onChangeCategory(String id) {
    setState(() {
      idCategory = id;
      itemStrem = objectBox.itemsStream(idCategory: id);
    });
    scrollController.animateTo(0,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  void onSearch(String search) {
    setState(() {
      itemStrem = objectBox.itemsStream(search: search);
    });
    scrollController.animateTo(0,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (authController.state is Authenticated) {
        return Scaffold(
          appBar: searchVisible
              ? SearchAppBar(
                  onBack: () => setState(() {
                    searchVisible = false;
                    textEditingController.text = '';
                    itemStrem = objectBox.itemsStream(idCategory: idCategory);
                  }),
                  controller: textEditingController,
                  onChanged: onSearch,
                )
              : AppBar(
                  title: Text(
                      outletController.activeOutlet.value?.outletName ?? ''),
                  automaticallyImplyLeading: false,
                  actions: [
                    IconButton(
                      onPressed: () => setState(() {
                        searchVisible = true;
                      }),
                      icon: const Icon(Icons.search),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.more_vert_rounded),
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
                  stream: itemStrem,
                  scrollController: scrollController,
                ),
              ),
            ],
          ),
          floatingActionButton: cartController.totalQty > 0
              ? FloatingActionButton.extended(
                  tooltip: 'cart'.tr,
                  onPressed: () => Get.toNamed(Routes.cart),
                  label: Text(
                    CurrencyFormat.currency(cartController.cart?.subtotal),
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: Colors.white),
                  ),
                  extendedIconLabelSpacing: 20,
                  icon: Badge(
                    label: Text(
                      cartController.totalQty.toString(),
                    ),
                    child: const Icon(CupertinoIcons.shopping_cart),
                  ),
                )
              : null,
        );
      }

      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    });
  }
}
