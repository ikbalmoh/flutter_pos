import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:selleri/features/item/model/item_adjustment.dart';
import 'package:selleri/features/adjustment/provider/adjustment_provider.dart';
import 'package:selleri/features/item/provider/fast_moving_item_provider.dart';
import 'package:selleri/shared/widget/error_handler.dart';
import 'package:selleri/shared/widget/generic/loading_placeholder.dart';
import 'package:selleri/shared/utils/formater.dart';

class FastMovingItems extends ConsumerStatefulWidget {
  const FastMovingItems({super.key, required this.scrollController});

  final ScrollController scrollController;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FastMovingItemsState();
}

class _FastMovingItemsState extends ConsumerState<FastMovingItems> {
  List<ItemAdjustment> selectedItems = [];

  void onSelectItem(ItemAdjustment item) {
    List<ItemAdjustment> allSelected =
        List<ItemAdjustment>.from(selectedItems).toList();

    int existIdx = allSelected.indexWhere(
        (i) => i.idItem == item.idItem && i.variantId == item.variantId);

    if (existIdx < 0) {
      allSelected.add(item);
    } else {
      allSelected.removeAt(existIdx);
    }
    setState(() {
      selectedItems = allSelected;
    });
  }

  void onSelectAll(bool isAllSelected) {
    setState(() {
      selectedItems =
          isAllSelected ? [] : ref.read(fastMovingItemsProvider).value ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<ItemAdjustment>> fastMovingItems =
        ref.watch(fastMovingItemsProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      height: MediaQuery.of(context).size.height * 0.8,
      child: switch (fastMovingItems) {
        AsyncData(:final value) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 7.5,
            children: [
              Container(
                padding: const EdgeInsets.only(
                    top: 5, left: 5, right: 5, bottom: 12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 0.5,
                      color: Colors.blueGrey.shade100,
                    ),
                  ),
                ),
                child: Text(
                  'x_fast_moving_items'.tr(args: [value.length.toString()]),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Checkbox(
                      visualDensity:
                          const VisualDensity(horizontal: -4, vertical: -4),
                      value: selectedItems.length == value.length,
                      onChanged: (_) =>
                          onSelectAll(selectedItems.length == value.length),
                    ),
                    const SizedBox(width: 7),
                    Text(
                      'select_x'.tr(args: ['all'.tr()]),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.black87, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: widget.scrollController,
                  itemBuilder: (context, index) {
                    final ItemAdjustment item = value[index];
                    bool isSelected = selectedItems.firstWhereOrNull((i) =>
                            i.idItem == item.idItem &&
                            i.variantId == item.variantId) !=
                        null;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Material(
                        borderRadius: BorderRadius.circular(5),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(5),
                          onTap: () => onSelectItem(item),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 10),
                            decoration: BoxDecoration(
                              // color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                width: 0.5,
                                color: isSelected
                                    ? Colors.teal
                                    : Colors.blueGrey.shade200,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              spacing: 5,
                              children: [
                                Checkbox(
                                    visualDensity: const VisualDensity(
                                        horizontal: -4, vertical: -4),
                                    value: isSelected,
                                    onChanged: (_) => onSelectItem(item)),
                                Expanded(
                                  child: Text(
                                    item.itemName,
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(right: 5),
                                  decoration: BoxDecoration(
                                      color: Colors.blue.shade50,
                                      borderRadius: BorderRadius.circular(5)),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 7.5, vertical: 5),
                                  child: Text(
                                    CurrencyFormat.currency(
                                      item.qtyActual,
                                      symbol: false,
                                    ),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue.shade600),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: value.length,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Flexible(
                    child: OutlinedButton(
                        onPressed: () => context.pop(),
                        child: Text('cancel'.tr())),
                  ),
                  const SizedBox(width: 12.5),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: selectedItems.isEmpty
                          ? null
                          : () {
                              context.pop();
                              ref
                                  .read(adjustmentProvider.notifier)
                                  .addItemsToCart(selectedItems);
                            },
                      child: Text('select'.tr()),
                    ),
                  ),
                ],
              ),
            ],
          ),
        AsyncError(:final error, :final stackTrace) => ErrorHandler(
            error: error.toString(),
            stackTrace: stackTrace.toString(),
          ),
        _ => const LoadingPlaceholder(),
      },
    );
  }
}
