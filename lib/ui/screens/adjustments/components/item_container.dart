import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:selleri/data/models/item_adjustment.dart';
import 'package:selleri/data/models/item_variant_adjustment.dart';
import 'package:selleri/providers/adjustment/adjustment_items_provider.dart';
import 'package:selleri/providers/cart/cart_provider.dart';
import 'package:selleri/ui/components/generic/item_list_skeleton.dart';
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
      {required ItemAdjustment item, ItemVariantAdjustment? variant}) {
    if (search.isNotEmpty &&
        [
          item.itemName.toLowerCase(),
        ].contains(search.toLowerCase())) {
      clearSearch();
    }
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
            onSelect: (variant) => onAddToCart(
              context,
              ref,
              item: item,
              variant: variant,
            ),
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
                  ? GridView.count(
                      physics: const AlwaysScrollableScrollPhysics(),
                      crossAxisCount: gridColumn,
                      childAspectRatio: 0.9,
                      padding: const EdgeInsets.all(7.5),
                      crossAxisSpacing: 7.5,
                      mainAxisSpacing: 7.5,
                      controller: scrollController,
                      children: List.generate(
                        data.data!.length,
                        (index) {
                          final ItemAdjustment item = data.data![index];
                          int qtyOnCart = ref
                              .read(cartProvider.notifier)
                              .qtyOnCart(item.idItem);
                          return ItemGrid(
                            item: item,
                            qtyOnCart: qtyOnCart,
                            onAddToCart: (item) =>
                                onAddToCart(context, ref, item: item),
                            addQty: (idItem) => ref
                                .read(cartProvider.notifier)
                                .updateQty(idItem),
                            showVariants: (item) =>
                                showVariants(context, item, ref),
                          );
                        },
                      ),
                    )
                  : ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: scrollController,
                      shrinkWrap: true,
                      itemCount: data.data!.length,
                      itemBuilder: (context, index) {
                        final item = data.data![index];
                        int qtyOnCart = ref
                            .read(cartProvider.notifier)
                            .qtyOnCart(item.idItem);
                        return ItemList(
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
