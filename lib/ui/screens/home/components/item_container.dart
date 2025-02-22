import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:selleri/data/models/item.dart';
import 'package:selleri/data/models/item_variant.dart';
import 'package:selleri/providers/cart/cart_provider.dart';
import 'package:selleri/providers/item/item_provider.dart';
import 'package:selleri/providers/settings/app_settings_provider.dart';
import 'package:selleri/ui/components/cart/shop_item_list.dart';
import 'package:selleri/ui/components/generic/item_list_skeleton.dart';
import 'package:selleri/ui/components/item/item_info.dart';
import 'package:selleri/ui/components/cart/item_variant_picker.dart';
import 'package:selleri/ui/components/cart/shop_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/utils/app_alert.dart';

class ItemContainer extends ConsumerWidget {
  final ScrollController? scrollController;

  final String idCategory;
  final String search;
  final FilterStock filterStock;
  final bool? allowEmptyStock;
  final Function clearSearch;

  const ItemContainer({
    this.scrollController,
    required this.idCategory,
    required this.search,
    required this.filterStock,
    required this.clearSearch,
    this.allowEmptyStock,
    super.key,
  });

  void onAddToCart(BuildContext context, WidgetRef ref,
      {required Item item, ItemVariant? variant}) async {
    try {
      await ref.read(cartProvider.notifier).addToCart(item, variant: variant);
      if (search.isNotEmpty &&
          [
            item.itemName.toLowerCase(),
            item.sku?.toLowerCase(),
            item.barcode?.toLowerCase()
          ].contains(search.toLowerCase())) {
        clearSearch();
      }
    } catch (e) {
      if (context.mounted) {
        AppAlert.snackbar(context, e.toString());
      }
    }
  }

  void showVariants(BuildContext context, Item item, WidgetRef ref) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (BuildContext context) {
          return ItemVariantPicker(
            item: item,
            onSelect: (variant) => onAddToCart(
              context,
              ref,
              item: item,
              variant: variant,
            ),
          );
        });
  }

  void onLongPress(BuildContext context, Item item, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      useSafeArea: true,
      builder: (context) => DraggableScrollableSheet(
        builder: (context, controller) => ItemInfo(
          scrollController: controller,
          item: item,
          onSelect: () {
            context.pop();
            if (item.variants.isNotEmpty) {
              showVariants(context, item, ref);
            } else {
              onAddToCart(context, ref, item: item);
            }
          },
        ),
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(itemsStreamProvider(
      idCategory: idCategory,
      search: search,
      filterStock: filterStock,
    ));

    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      final int gridColumn = width > 510
          ? 4
          : width > 400
              ? 3
              : 2;
      return switch (items) {
        AsyncData(:final value) => value.isEmpty
            ? SingleChildScrollView(
                padding: const EdgeInsets.only(top: 200),
                controller: scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
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
              )
            : ref.watch(appSettingsProvider).itemLayoutGrid
                ? GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: gridColumn,
                      mainAxisSpacing: 7.5,
                      crossAxisSpacing: 8,
                    ),
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(7.5),
                    controller: scrollController,
                    itemCount: value.length,
                    itemBuilder: (context, index) {
                      final Item item = value[index];
                      int qtyOnCart = ref
                          .read(cartProvider.notifier)
                          .qtyOnCart(item.idItem);
                      return ShopItem(
                        item: item,
                        qtyOnCart: qtyOnCart,
                        onAddToCart: (item) =>
                            onAddToCart(context, ref, item: item),
                        showVariants: (item) =>
                            showVariants(context, item, ref),
                        onLongPress: (item) => onLongPress(context, item, ref),
                      );
                    },
                  )
                : ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: scrollController,
                    shrinkWrap: true,
                    itemCount: value.length,
                    itemBuilder: (context, index) {
                      final item = value[index];
                      int qtyOnCart = ref
                          .read(cartProvider.notifier)
                          .qtyOnCart(item.idItem);
                      return ShopItemList(
                        item: item,
                        qtyOnCart: qtyOnCart,
                        onAddToCart: (item) =>
                            onAddToCart(context, ref, item: item),
                        showVariants: (item) =>
                            showVariants(context, item, ref),
                        onLongPress: (item) => onLongPress(context, item, ref),
                      );
                    },
                  ),
        AsyncError(:final error) => Center(
            child: Text(error.toString()),
          ),
        _ => ListView.builder(
            itemBuilder: (context, idx) {
              return const ItemListSkeleton();
            },
            itemCount: 6,
          )
      };
    });
  }
}
