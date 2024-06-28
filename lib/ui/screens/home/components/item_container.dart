import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:selleri/data/models/item.dart';
import 'package:selleri/providers/cart/cart_provider.dart';
import 'package:selleri/providers/item/item_provider.dart';
import 'package:selleri/ui/components/item/item_info.dart';
import 'package:selleri/ui/components/cart/item_variant_picker.dart';
import 'package:selleri/ui/components/cart/shop_item.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/ui/widgets/loading_widget.dart';

class ItemContainer extends ConsumerWidget {
  final ScrollController? scrollController;

  final String idCategory;
  final String search;

  const ItemContainer({
    this.scrollController,
    required this.idCategory,
    required this.search,
    super.key,
  });

  void showVariants(BuildContext context, Item item, WidgetRef ref) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (BuildContext context) {
          return ItemVariantPicker(
            item: item,
            onSelect: (variant) => ref
                .read(cartNotiferProvider.notifier)
                .addToCart(item, variant: variant),
          );
        });
  }

  void onLongPress(BuildContext context, Item item) {
    showModalBottomSheet(
        context: context,
        isDismissible: true,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        useSafeArea: true,
        builder: (context) {
          return ItemInfo(item: item);
        });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTablet = ResponsiveBreakpoints.of(context).largerOrEqualTo(TABLET);
    final items =
        ref.watch(itemsStreamProvider(idCategory: idCategory, search: search));

    return switch (items) {
      AsyncData(:final value) => value.isNotEmpty
          ? GridView.count(
              crossAxisCount: isTablet ? 4 : 2,
              childAspectRatio: 0.9,
              padding: const EdgeInsets.all(7.5),
              crossAxisSpacing: 7.5,
              mainAxisSpacing: 7.5,
              controller: scrollController,
              children: List.generate(
                value.length,
                (index) {
                  final Item item = value[index];
                  int qtyOnCart = ref
                      .read(cartNotiferProvider.notifier)
                      .qtyOnCart(item.idItem);
                  return ShopItem(
                    item: item,
                    qtyOnCart: qtyOnCart,
                    onAddToCart: (item) =>
                        ref.read(cartNotiferProvider.notifier).addToCart(item),
                    addQty: (idItem) => ref
                        .read(cartNotiferProvider.notifier)
                        .updateQty(idItem),
                    showVariants: (item) => showVariants(context, item, ref),
                    onLongPress: (item) => onLongPress(context, item),
                  );
                },
              ),
            )
          : SingleChildScrollView(
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
                      'No Items',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(color: Colors.grey),
                    )
                  ],
                ),
              ),
            ),
      AsyncError(:final error) => Center(
          child: Text(error.toString()),
        ),
      _ => const LoadingIndicator(color: Colors.teal)
    };
  }
}
