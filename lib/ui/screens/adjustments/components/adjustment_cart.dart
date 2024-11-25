import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:selleri/data/models/item_adjustment.dart';
import 'package:selleri/providers/adjustment/adjustment_provider.dart';
import 'package:selleri/ui/screens/adjustments/components/adjustment_item_form.dart';
import 'package:selleri/utils/app_alert.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
                      return ListTile(
                        tileColor: Colors.white,
                        title: Text(itemName),
                        trailing: Text(
                          item.qtyActual.toString(),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        subtitle: item.note != '' ? Text(item.note!) : null,
                        dense: true,
                        onTap: () => onPressItem(item),
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
                      TextButton(
                          onPressed: () => {}, child: const Text('Reset')),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                            ),
                          ),
                          onPressed: () => {},
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
