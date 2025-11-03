import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:selleri/features/item/model/item.dart';
import 'package:selleri/features/item/model/item_variant.dart';
import 'package:selleri/features/cart/provider/cart_provider.dart';
import 'package:selleri/features/item/provider/item_provider.dart';
import 'package:selleri/features/settings/provider/app_settings_provider.dart';
import 'package:selleri/features/cart/widget/components/shop_item_list.dart';
import 'package:selleri/shared/widget/generic/item_list_skeleton.dart';
import 'package:selleri/features/item/widget/components/item_info.dart';
import 'package:selleri/features/cart/widget/components/item_variant_picker.dart';
import 'package:selleri/features/cart/widget/components/shop_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/shared/utils/app_alert.dart';

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
      {required Item item,
      required List<ItemVariant> variants,
      ItemVariant? variant}) async {
    try {
      debugPrint(
          'onAddToCart: item: ${item.itemName} => variants: ${variants.map((v) => '${v.id} - ${v.variantName}')} => variant: ${variant?.variantName}');

      if (variant != null) {
        await ref.read(cartProvider.notifier).addToCart(item, variant: variant);
      } else if (variants.isNotEmpty) {
        for (var variant in variants) {
          await ref
              .read(cartProvider.notifier)
              .addToCart(item, variant: variant);
        }
      } else {
        await ref.read(cartProvider.notifier).addToCart(item);
      }
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
        AppAlert.snackbar(e.toString());
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
            onSelect: (variants) => onAddToCart(
              context,
              ref,
              item: item,
              variants: variants,
            ),
            onLongPress: (variant) {
              onLongPress(
                  context: context, item: item, ref: ref, variant: variant);
            },
          );
        });
  }

  void onLongPress({
    required BuildContext context,
    required Item item,
    required WidgetRef ref,
    ItemVariant? variant,
  }) {
    log('SHOW ITEM INFO $item');
    if (item.variants.isNotEmpty && variant == null) {
      showVariants(context, item, ref);
      return;
    }
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
          variant: variant,
          onSelect: () {
            while (context.canPop()) {
              context.pop();
            }
            if (variant != null) {
              onAddToCart(context, ref, item: item, variants: [variant]);
            } else if (item.variants.isNotEmpty) {
              showVariants(context, item, ref);
            } else {
              onAddToCart(context, ref, item: item, variants: []);
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
    final items = ref.watch(itemsProvider(
      idCategory: idCategory,
      search: search,
      filterStock: filterStock,
    ));

    return LayoutBuilder(builder: (context, constraints) {
      final breakpoints = ResponsiveBreakpoints.of(context);
      final int gridColumn = breakpoints.largerOrEqualTo(DESKTOP)
          ? 4
          : breakpoints.largerOrEqualTo(TABLET)
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
                      double qtyOnCart = ref
                          .read(cartProvider.notifier)
                          .qtyOnCart(item.idItem);
                      return ShopItem(
                        item: item,
                        qtyOnCart: qtyOnCart,
                        onAddToCart: (item) =>
                            onAddToCart(context, ref, item: item, variants: []),
                        showVariants: (item) =>
                            showVariants(context, item, ref),
                        onLongPress: (item) =>
                            onLongPress(context: context, item: item, ref: ref),
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
                      double qtyOnCart = ref
                          .read(cartProvider.notifier)
                          .qtyOnCart(item.idItem);
                      return ShopItemList(
                        item: item,
                        qtyOnCart: qtyOnCart,
                        onAddToCart: (item) =>
                            onAddToCart(context, ref, item: item, variants: []),
                        showVariants: (item) =>
                            showVariants(context, item, ref),
                        onLongPress: (item) =>
                            onLongPress(context: context, item: item, ref: ref),
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
