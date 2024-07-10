import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:selleri/data/models/item.dart';
import 'package:selleri/data/models/item_variant.dart';
import 'package:selleri/providers/cart/cart_provider.dart';
import 'package:selleri/providers/item/item_provider.dart';
import 'package:selleri/providers/settings/app_settings_provider.dart';
import 'package:selleri/ui/components/cart/shop_item_list.dart';
import 'package:selleri/ui/components/item/item_info.dart';
import 'package:selleri/ui/components/cart/item_variant_picker.dart';
import 'package:selleri/ui/components/cart/shop_item.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/ui/widgets/loading_widget.dart';
import 'package:selleri/utils/app_alert.dart';

class ItemContainer extends ConsumerWidget {
  final ScrollController? scrollController;

  final String idCategory;
  final String search;
  final bool? allowEmptyStock;

  const ItemContainer({
    this.scrollController,
    required this.idCategory,
    required this.search,
    this.allowEmptyStock,
    super.key,
  });

  void onAddToCart(BuildContext context, WidgetRef ref,
      {required Item item, ItemVariant? variant}) {
    double stock = variant?.stockItem ?? item.stockItem;
    if (stock <= 0 && allowEmptyStock == false) {
      AppAlert.snackbar(context, 'out_of_stock'.tr());
      return;
    }
    ref.read(cartNotiferProvider.notifier).addToCart(item, variant: variant);
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
    final items =
        ref.watch(itemsStreamProvider(idCategory: idCategory, search: search));

    return switch (items) {
      AsyncData(:final value) => value.isEmpty
          ? SingleChildScrollView(
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
            )
          : ref.watch(appSettingsNotifierProvider).itemLayoutGrid
              ? GridView.count(
                  crossAxisCount:
                      ResponsiveBreakpoints.of(context).largerOrEqualTo(TABLET)
                          ? 4
                          : 2,
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
                            onAddToCart(context, ref, item: item),
                        addQty: (idItem) => ref
                            .read(cartNotiferProvider.notifier)
                            .updateQty(idItem),
                        showVariants: (item) =>
                            showVariants(context, item, ref),
                        onLongPress: (item) => onLongPress(context, item),
                      );
                    },
                  ),
                )
              : ListView.builder(
                  controller: scrollController,
                  shrinkWrap: true,
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    final item = value[index];
                    int qtyOnCart = ref
                        .read(cartNotiferProvider.notifier)
                        .qtyOnCart(item.idItem);
                    return ShopItemList(
                      item: item,
                      qtyOnCart: qtyOnCart,
                      onAddToCart: (item) =>
                          onAddToCart(context, ref, item: item),
                      addQty: (idItem) => ref
                          .read(cartNotiferProvider.notifier)
                          .updateQty(idItem),
                      showVariants: (item) => showVariants(context, item, ref),
                      onLongPress: (item) => onLongPress(context, item),
                    );
                  },
                ),
      AsyncError(:final error) => Center(
          child: Text(error.toString()),
        ),
      _ => const LoadingIndicator(color: Colors.teal)
    };
  }
}
