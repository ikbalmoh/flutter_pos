import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:selleri/data/models/item_adjustment.dart';
import 'package:selleri/providers/item/fast_moving_item_provider.dart';
import 'package:selleri/ui/screens/adjustments/components/fast_moving_items.dart';

class FastMovingItemBanner extends ConsumerWidget {
  const FastMovingItemBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<ItemAdjustment>> fastMovingItems =
        ref.watch(fastMovingItemsProvider);

    return switch (fastMovingItems) {
      AsyncData(:final value) => value.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10)
                  .copyWith(bottom: 5),
              child: Material(
                color: Colors.amber.shade100,
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1,
                      color: Colors.amber.shade500,
                    ),
                    borderRadius: BorderRadius.circular(10)),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () => {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => const FastMovingItems(),
                      backgroundColor: Colors.white,
                      isScrollControlled: true,
                    )
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 12.5,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          CupertinoIcons.text_badge_checkmark,
                          color: Colors.amber.shade800,
                          size: 20,
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: Text(
                            'x_fast_moving_items'
                                .tr(args: [value.length.toString()]),
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  color: Colors.amber.shade800,
                                ),
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Icon(
                          CupertinoIcons.chevron_down,
                          color: Colors.amber.shade700,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          : Container(),
      AsyncError() => Container(),
      _ => Container(),
    };
  }
}
