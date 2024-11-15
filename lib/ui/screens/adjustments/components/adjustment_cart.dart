import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:selleri/data/models/item_adjustment.dart';
import 'package:selleri/data/models/item_cart.dart';
import 'package:selleri/providers/adjustment/adjustment_provider.dart';
import 'package:selleri/providers/cart/cart_provider.dart';
import 'package:selleri/ui/components/cart/edit_cart_item_form.dart';
import 'package:selleri/utils/app_alert.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdjustmentCart extends ConsumerWidget {
  const AdjustmentCart({super.key, this.asWidget});

  final bool? asWidget;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(adjustmentProvider);

    void onDeleteItem(ItemCart item) {
      if (context.canPop()) {
        context.pop();
      }
      AppAlert.confirm(context,
          title: "${'delete'.tr()} ${item.itemName}",
          subtitle: 'are_you_sure'.tr(),
          confirmLabel: 'delete'.tr(),
          danger: true, onConfirm: () async {
        await ref.read(cartProvider.notifier).removeItem(item.identifier!);
      });
    }

    void onPressItem(ItemCart item) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        builder: (BuildContext context) => EditCartItemForm(
          item: item,
          onDelete: () => onDeleteItem(item),
        ),
      );
    }

    void confirmDeleteTransaction(BuildContext context) {
      AppAlert.confirm(
        context,
        title: 'delete_transaction'.tr(),
        subtitle: 'delete_transaction_confirmation'.tr(),
        confirmLabel: 'delete'.tr(),
        onConfirm: () => ref.read(cartProvider.notifier).removeHoldedCart(),
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
                      return ListTile(
                        tileColor: Colors.white,
                        title: Text(item.itemName),
                        trailing: Text(item.qtyActual.toString()),
                        subtitle: item.note != null ? Text(item.note!) : null,
                        dense: true,
                      );
                    },
                    itemCount: cart.items.length,
                  ),
                ),
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(15),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                    ),
                    onPressed: () => {},
                    child: Text('continue'.tr().toUpperCase()),
                  ),
                )
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
