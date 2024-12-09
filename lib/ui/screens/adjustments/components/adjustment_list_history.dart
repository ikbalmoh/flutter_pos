import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/providers/adjustment/adjustment_history_provider.dart';
import 'package:selleri/ui/components/error_handler.dart';
import 'package:selleri/ui/components/generic/item_list_skeleton.dart';
import 'package:selleri/ui/components/generic/loading_placeholder.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:selleri/data/models/adjustment_history.dart' as model;
import 'package:selleri/utils/formater.dart';

class AdjustmentListHistory extends ConsumerWidget {
  const AdjustmentListHistory({super.key, required this.controller});

  final ScrollController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(adjustmentHistoryProvider);

    controller.addListener(() {
      print(controller.position.extentAfter);
    });

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding:
              const EdgeInsets.only(top: 0, left: 15, right: 15, bottom: 15),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 0.5,
                color: Colors.blueGrey.shade100,
              ),
            ),
          ),
          child: Text(
            'adjustment_history'.tr(),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        Expanded(
          child: switch (history) {
            AsyncData(:final value) =>
              GroupedListView<model.AdjustmentHistory, String>(
                controller: controller,
                elements: value.data ?? [],
                padding: const EdgeInsets.symmetric(vertical: 7.5),
                groupBy: (element) => DateTimeFormater.dateToString(
                    element.adjustmentDate,
                    format: 'dd MMM Y'),
                groupHeaderBuilder: (model.AdjustmentHistory header) =>
                    Container(
                  width: double.maxFinite,
                  color: Colors.grey.shade100,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Text(DateTimeFormater.dateToString(
                      header.adjustmentDate,
                      format: 'dd MMM y')),
                ),
                itemComparator: (element1, element2) =>
                    element1.adjustmentDate.compareTo(element2.adjustmentDate),
                itemBuilder: (context, element) => Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              width: 0.5, color: Colors.grey.shade200))),
                  padding:
                      const EdgeInsets.symmetric(vertical: 7.5, horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        element.adjustmentNo,
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      Text(element.description,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.black87)),
                    ],
                  ),
                ),
                useStickyGroupSeparators: true,
                floatingHeader: true,
                footer: value.loading == true
                    ? const ItemListSkeleton(
                        leading: false,
                      )
                    : Padding(
                        padding: const EdgeInsets.all(20),
                        child: Center(
                          child: Text(
                            'x_data_displayed'.tr(args: [
                              CurrencyFormat.currency(
                                value.total,
                                symbol: false,
                              )
                            ]),
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: Colors.grey.shade500),
                          ),
                        ),
                      ),
              ),
            AsyncError(:final error, :final stackTrace) => ErrorHandler(
                error: error.toString(),
                stackTrace: stackTrace.toString(),
              ),
            _ => const LoadingPlaceholder(),
          },
        ),
      ],
    );
  }
}
