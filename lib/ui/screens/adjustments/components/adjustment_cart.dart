import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:selleri/data/models/item_adjustment.dart';
import 'package:selleri/providers/adjustment/adjustment_provider.dart';
import 'package:selleri/ui/screens/adjustments/components/adjustment_item_form.dart';
import 'package:selleri/ui/screens/adjustments/components/submit_adjustment_sheet.dart';
import 'package:selleri/utils/app_alert.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/utils/formater.dart';

class AdjustmentCart extends ConsumerWidget {
  const AdjustmentCart({super.key, this.asWidget});

  final bool? asWidget;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(adjustmentProvider);

    void onDeleteItem(ItemAdjustment item) {
      if (context.canPop()) {
        context.pop();
      }
      AppAlert.confirm(context,
          title: "${'delete'.tr()} ${item.itemName}",
          subtitle: 'are_you_sure'.tr(),
          confirmLabel: 'delete'.tr(),
          danger: true, onConfirm: () async {
        ref.read(adjustmentProvider.notifier).removeItem(item.idItem);
      });
    }

    void onPressItem(ItemAdjustment item) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        builder: (BuildContext context) => AdjustmentItemForm(
          item: item,
          onDelete: () => onDeleteItem(item),
        ),
      );
    }

    void onSubmit() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        isDismissible: false,
        enableDrag: false,
        builder: (BuildContext context) => const SubmitAdjustmentSheet(),
      );
    }

    void onReset() {
      AppAlert.confirm(context,
          title: 'Reset',
          subtitle: 'are_you_sure'.tr(),
          onConfirm: () => ref.read(adjustmentProvider.notifier).resetForm());
    }

    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      appBar: AppBar(
        elevation: 1,
        automaticallyImplyLeading: asWidget != true,
        title: Text(
          'item_list'.tr(),
          style:
              TextStyle(color: asWidget == true ? Colors.black87 : Colors.teal),
        ),
        leading: asWidget == true
            ? const Icon(CupertinoIcons.list_number_rtl)
            : null,
        foregroundColor: asWidget == true ? Colors.black87 : Colors.teal,
      ),
      body: cart.items.isNotEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, idx) {
                      ItemAdjustment item = cart.items[idx];
                      String itemName = item.itemName;
                      if (item.variantName != null) {
                        itemName += ' - ${item.variantName}';
                      }
                      return Material(
                        shape: Border(
                          bottom: BorderSide(
                            color: Colors.blueGrey.shade50,
                          ),
                        ),
                        color: Colors.white,
                        child: InkWell(
                          onTap: () => onPressItem(item),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 10,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                            itemName,
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
                                                      color: Colors.black54,
                                                    ),
                                              ),
                                              const SizedBox(width: 10),
                                              Text(
                                                "${'different'.tr()}: ${CurrencyFormat.currency(item.qtyDiff, symbol: false)}",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall
                                                    ?.copyWith(
                                                      color: Colors.black54,
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
                          ),
                        ),
                      );
                    },
                    itemCount: cart.items.length,
                  ),
                ),
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      Flexible(
                        fit: FlexFit.loose,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            foregroundColor: Colors.blue,
                            side: const BorderSide(color: Colors.blue),
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                            ),
                          ),
                          onPressed: onReset,
                          child: const Text('Reset'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                            ),
                          ),
                          onPressed: onSubmit,
                          child: Text('save'.tr().toUpperCase()),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Center(
              child: Text(
                'select_items'.tr(),
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.blueGrey.shade500),
                textAlign: TextAlign.center,
              ),
            ),
    );
  }
}
