import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:selleri/data/models/item_adjustment.dart';
import 'package:selleri/providers/adjustment/adjustment_provider.dart';
import 'package:selleri/providers/item/fast_moving_item_provider.dart';
import 'package:selleri/ui/components/error_handler.dart';
import 'package:selleri/ui/components/generic/loading_placeholder.dart';

class FastMovingItems extends ConsumerWidget {
  const FastMovingItems({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<ItemAdjustment>> fastMovingItems =
        ref.watch(fastMovingItemsProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      height: MediaQuery.of(context).size.height * 0.8,
      child: switch (fastMovingItems) {
        AsyncData(:final value) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  itemBuilder: (context, index) {
                    final ItemAdjustment item = value[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          width: 0.5,
                          color: Colors.blueGrey.shade100,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item.itemName,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            item.qtyActual.toString(),
                            style: Theme.of(context).textTheme.bodyLarge,
                          )
                        ],
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
                      onPressed: () {
                        context.pop();
                        ref
                            .read(adjustmentProvider.notifier)
                            .addItemsToCart(value);
                      },
                      child: Text('select'.tr()),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
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
