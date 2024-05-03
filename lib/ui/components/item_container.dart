import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:selleri/data/models/item.dart';
import 'package:selleri/ui/components/item_variant_picker.dart';
import 'package:selleri/ui/components/shop_item.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ItemContainer extends ConsumerWidget {
  final Stream<List<Item>> stream;
  final ScrollController? scrollController;

  const ItemContainer({required this.stream, this.scrollController, super.key});

  void showVariants(BuildContext context, Item item) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return ItemVariantPicker(item: item);
        });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTablet = ResponsiveBreakpoints.of(context).largerOrEqualTo(TABLET);
    return StreamBuilder<List<Item>>(
        stream: stream,
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
                controller: scrollController,
                children: List.generate(
                  items.length,
                  (index) => ShopItem(
                    item: items[index],
                    qtyOnCart: 0,
                    onAddToCart: (item) => {},
                    addQty: (idItem) => {},
                    showVariants: (item) => showVariants(context, item),
                  ),
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.only(top: 200),
              controller: scrollController,
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
                      'no_items',
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
