import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:selleri/data/models/adjustment_history.dart';
import 'package:selleri/data/models/item_adjustment.dart';
import 'package:selleri/providers/adjustment/adjustment_details_provider.dart';
import 'package:selleri/providers/adjustment/adjustment_provider.dart';
import 'package:selleri/router/routes.dart';
import 'package:selleri/ui/components/error_handler.dart';
import 'package:selleri/ui/components/generic/item_list_skeleton.dart';
import 'package:selleri/ui/screens/adjustments/components/adjustment_status_badge.dart';
import 'package:selleri/utils/app_alert.dart';
import 'package:selleri/utils/formater.dart';

class AdjustmentPreview extends ConsumerWidget {
  const AdjustmentPreview({super.key, required this.adjustment, this.asWidget});

  final AdjustmentHistory adjustment;
  final bool? asWidget;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<ItemAdjustment>> items =
        ref.watch(adjustmentDetailItemsProvider(id: adjustment.idAdjustment));

    void duplicateAdjustment(List<ItemAdjustment> items) async {
      try {
        while (GoRouter.of(context)
                .routerDelegate
                .currentConfiguration
                .matches
                .last
                .matchedLocation !=
            Routes.adjustments) {
          if (!context.canPop()) {
            return;
          }
          context.pop();
        }
        await ref.read(adjustmentProvider.notifier).duplicateAdjustment(
              adjustment: adjustment,
            );
        if (context.mounted) {
          AppAlert.snackbar(
              context, 'duplicate_x'.tr(args: ['adjustment'.tr()]));
        }
      } on Exception catch (e) {
        AppAlert.toast(e.toString());
      }
    }

    void onDuplicate(List<ItemAdjustment> items) async {
      final current = ref.watch(adjustmentProvider);
      if (current.items.isNotEmpty) {
        AppAlert.confirm(
          context,
          shouldPop: false,
          title: 'duplicate_x'.tr(args: ['adjustment'.tr()]),
          subtitle: 'duplicate_adjustment_confirmation'.tr(),
          onConfirm: () => duplicateAdjustment(items),
        );
      } else {
        duplicateAdjustment(items);
      }
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(adjustment.adjustmentNo),
        iconTheme: const IconThemeData(color: Colors.black87),
        automaticallyImplyLeading: asWidget != true,
        titleTextStyle: const TextStyle(
            color: Colors.black87, fontWeight: FontWeight.w600, fontSize: 18),
      ),
      body: switch (items) {
        AsyncData(:final value) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(15),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 12.5),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      CupertinoIcons.calendar,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(DateTimeFormater.dateToString(
                                        adjustment.adjustmentDate,
                                        format: 'd MMM y')),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      CupertinoIcons.person_crop_circle,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(adjustment.createdName!),
                                  ],
                                ),
                                adjustment.description != null &&
                                        adjustment.description != ''
                                    ? Row(
                                        children: [
                                          const Icon(
                                            CupertinoIcons.text_quote,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            adjustment.description!,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                    color: Colors.black54),
                                          )
                                        ],
                                      )
                                    : Container()
                              ],
                            ),
                            AdjustmentStatusBadge(status: adjustment.approval),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Divider(
                          height: 1,
                          color: Colors.blueGrey.shade50,
                        ),
                        const SizedBox(height: 10),
                        value.isNotEmpty
                            ? ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  final item = value[index];
                                  return Container(
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                      width: 1,
                                      color: Colors.grey.shade100,
                                    ))),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 5,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    item.itemName,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "${'system'.tr()}: ${CurrencyFormat.currency(item.qtySystem, symbol: false)}",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleSmall
                                                            ?.copyWith(
                                                              color: Colors
                                                                  .black54,
                                                            ),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      Text(
                                                        "${'different'.tr()}: ${CurrencyFormat.currency(item.qtyDiff, symbol: false)}",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleSmall
                                                            ?.copyWith(
                                                              color: Colors
                                                                  .black54,
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.grey.shade100,
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 7.5,
                                                      vertical: 5),
                                              child: Text(
                                                CurrencyFormat.currency(
                                                  item.qtyActual,
                                                  symbol: false,
                                                ),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                            )
                                          ],
                                        ),
                                        item.note != null && item.note != ''
                                            ? Text(item.note!)
                                            : Container(),
                                      ],
                                    ),
                                  );
                                },
                                itemCount: value.length,
                              )
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 80,
                                  horizontal: 20,
                                ),
                                child: Center(
                                  child: Text(
                                    'no_items'.tr(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          color: Colors.black54,
                                        ),
                                  ),
                                ),
                              )
                      ],
                    ),
                  ),
                ),
              ),
              Card(
                elevation: 5,
                color: Colors.white,
                shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(25))),
                margin: asWidget == true
                    ? const EdgeInsets.symmetric(horizontal: 15)
                    : const EdgeInsets.all(0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: ElevatedButton.icon(
                    label: Text('duplicate_x'.tr(args: ['adjustment'.tr()])),
                    onPressed: () => onDuplicate(value),
                    icon: const Icon(
                      Icons.copy,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        AsyncError(:final error, :final stackTrace) => ErrorHandler(
            error: error.toString(),
            stackTrace: stackTrace.toString(),
          ),
        _ => ListView.builder(
            itemBuilder: (context, _) => const ItemListSkeleton(),
            itemCount: 10,
          ),
      },
    );
  }
}
