import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selleri/models/item.dart';
import 'package:selleri/modules/cart/cart.dart';
import 'package:selleri/ui/components/item_variant_picker.dart';
import 'package:selleri/ui/components/shop_item.dart';
import 'package:responsive_framework/responsive_framework.dart';

class ItemContainer extends StatefulWidget {
  final Stream<List<Item>> stream;
  final ScrollController? scrollController;

  const ItemContainer({required this.stream, this.scrollController, super.key});

  @override
  State<ItemContainer> createState() => _ItemContainerState();
}

class _ItemContainerState extends State<ItemContainer> {
  final CartController cartController = Get.find();

  void showVariants(Item item) {
    Get.bottomSheet(ItemVariantPicker(item: item));
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveBreakpoints.of(context).largerOrEqualTo(TABLET);
    return StreamBuilder<List<Item>>(
        stream: widget.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isNotEmpty) {
              List<Item> items = snapshot.data!;
              return GridView.count(
                crossAxisCount: isTablet ? 4 : 2,
                childAspectRatio: 0.9,
                padding: const EdgeInsets.all(7.5),
                crossAxisSpacing: 7.5,
                mainAxisSpacing: 7.5,
                controller: widget.scrollController,
                children: List.generate(
                  items.length,
                  (index) => ShopItem(
                    item: items[index],
                    qtyOnCart: cartController.cart?.items
                            .firstWhereOrNull(
                                (i) => i.idItem == items[index].idItem)
                            ?.quantity ??
                        0,
                    onAddToCart: (item) => item.variants.isNotEmpty ? showVariants(item) : cartController.addToCart(item),
                    addQty: (idItem) => cartController.addQty(idItem),
                  ),
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.only(top: 200),
              controller: widget.scrollController,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      CupertinoIcons.bag,
                      size: 60,
                      color: Colors.grey,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      'no_items'.tr,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(color: Colors.grey),
                    )
                  ],
                ),
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
