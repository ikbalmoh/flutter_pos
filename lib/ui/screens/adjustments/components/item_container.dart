import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:selleri/data/models/item_adjustment.dart';
import 'package:selleri/data/models/item_variant_adjustment.dart';
import 'package:selleri/providers/adjustment/adjustment_items_provider.dart';
import 'package:selleri/providers/adjustment/adjustment_provider.dart';
import 'package:selleri/providers/cart/cart_provider.dart';
import 'package:selleri/ui/components/generic/item_grid_skeleton.dart';
import 'package:selleri/ui/components/generic/item_list_skeleton.dart';
import 'package:selleri/ui/screens/adjustments/components/adjustment_item_form.dart';
import 'item_variant_adjustment_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/ui/screens/adjustments/components/item_grid.dart';
import 'package:selleri/ui/screens/adjustments/components/item_list.dart';

class ItemContainer extends ConsumerWidget {
  final ScrollController? scrollController;

  final String idCategory;
  final String search;
  final bool itemLayoutGrid;
  final Function clearSearch;

  const ItemContainer({
    this.scrollController,
    required this.idCategory,
    required this.search,
    required this.clearSearch,
    required this.itemLayoutGrid,
    super.key,
  });

  void onAddToCart(BuildContext context, WidgetRef ref,
      {required ItemAdjustment item}) {
    if (search.isNotEmpty &&
        [
          item.itemName.toLowerCase(),
        ].contains(search.toLowerCase())) {
      clearSearch();
    }
    showModalBottomSheet(
        backgroundColor: Colors.white,
        context: context,
        isScrollControlled: true,
        builder: (context) => AdjustmentItemForm(item: item));
  }

  void onAddVariantsToCart(BuildContext context, WidgetRef ref,
      {required ItemAdjustment item,
      required List<ItemVariantAdjustment> variants}) {
    if (search.isNotEmpty &&
        [
          item.itemName.toLowerCase(),
        ].contains(search.toLowerCase())) {
      clearSearch();
    }
    ref.read(adjustmentProvider.notifier).addToCart(item, variants: variants);
  }

  void showVariants(BuildContext context, ItemAdjustment item, WidgetRef ref) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (BuildContext context) {
          return ItemVariantAdjustmentPicker(
            item: item,
            onSelect: (variants) => onAddVariantsToCart(context, ref,
                item: item, variants: variants),
          );
        });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      final int gridColumn = width > 510
          ? 4
          : width > 400
              ? 3
              : 2;
      return ref.watch(adjustmentItemsProvider).when(
          data: (data) => data.data!.isEmpty
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
              : itemLayoutGrid
                  ? GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: gridColumn,
                        mainAxisSpacing: 7.5,
                        crossAxisSpacing: 8,
                      ),
                      controller: scrollController,
                      padding: const EdgeInsets.all(10),
                      itemCount: data.data!.length + 1,
                      itemBuilder: (context, index) {
                        if (index + 1 > data.data!.length) {
                          if (data.currentPage >= data.lastPage) {
                            return Container();
                          }
                          return const ItemGridSkeleton();
                        }
                        final ItemAdjustment item = data.data![index];
                        int qtyOnCart = ref
                            .read(cartProvider.notifier)
                            .qtyOnCart(item.idItem);
                        return ItemGrid(
                          item: item,
                          qtyOnCart: qtyOnCart,
                          onAddToCart: (item) =>
                              onAddToCart(context, ref, item: item),
                          addQty: (idItem) =>
                              ref.read(cartProvider.notifier).updateQty(idItem),
                          showVariants: (item) =>
                              showVariants(context, item, ref),
                        );
                      },
                    )
                  : ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: scrollController,
                      shrinkWrap: true,
                      itemCount: data.data!.length + 1,
                      itemBuilder: (context, index) {
                        if (index + 1 > data.data!.length) {
                          if (data.currentPage >= data.lastPage) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 10),
                              child: Center(
                                child: Text(
                                  'x_data_displayed'.tr(
                                    args: [data.total.toString()],
                                  ),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Colors.grey.shade600,
                                      ),
                                ),
                              ),
                            );
                          }
                          return const ItemListSkeleton(leading: false);
                        }
                        final item = data.data![index];
                        int qtyOnCart = ref
                            .read(cartProvider.notifier)
                            .qtyOnCart(item.idItem);
                        return ItemList(
                          item: item,
                          qtyOnCart: qtyOnCart,
                          onAddToCart: (item) =>
                              onAddToCart(context, ref, item: item),
                          showVariants: (item) =>
                              showVariants(context, item, ref),
                        );
                      },
                    ),
          error: (e, stack) => Center(
                child: Text(e.toString()),
              ),
          loading: () => ListView.builder(
                itemBuilder: (context, idx) {
                  return const ItemListSkeleton();
                },
                itemCount: 6,
              ));
    });
  }
}
