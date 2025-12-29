import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:selleri/features/item/model/item_cart.dart';
import 'package:selleri/features/cart/provider/cart_provider.dart';
import 'package:selleri/features/cart/widget/components/cart_item.dart';
import 'package:selleri/features/cart/widget/components/cart_actions.dart';
import 'package:selleri/features/cart/widget/components/edit_cart_item_form.dart';
import 'package:selleri/features/pos/widget/components/holded_baner.dart';
import 'package:selleri/shared/router/routes.dart';
import 'package:selleri/shared/utils/app_alert.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key, this.asWidget});

  final bool? asWidget;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);

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
        useSafeArea: true,
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
        automaticallyImplyLeading: asWidget != true,
        title: Text(
          'cart'.tr(),
          style: asWidget == true
              ? Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  )
              : null,
        ),
        leading: asWidget == true
            ? const Icon(
                CupertinoIcons.shopping_cart,
                size: 20,
              )
            : null,
        foregroundColor: asWidget == true ? Colors.black87 : Colors.teal,
        actionsPadding: EdgeInsets.only(right: 10),
        actions: [
          TextButton.icon(
            style: TextButton.styleFrom(
                backgroundColor: cart.idCustomer != null
                    ? Colors.teal.shade50.withValues(alpha: .4)
                    : Colors.white,
                foregroundColor: cart.idCustomer != null
                    ? Colors.teal
                    : Colors.grey.shade700,
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.only(
                    right: cart.idCustomer != null ? 0 : 10, left: 10)),
            onPressed: () => context.push(Routes.customers),
            icon: Icon(
                cart.vehicle != null ? Icons.drive_eta_rounded : Icons.person),
            label: cart.idCustomer != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 15,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(cart.customerName!.trim()),
                          if (cart.vehicle != null)
                            Text(
                              cart.vehicle!.licensePlate,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(color: Colors.teal.shade400),
                            )
                        ],
                      ),
                      IconButton(
                          style: IconButton.styleFrom(
                            visualDensity: VisualDensity.compact,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            overlayColor: Colors.red,
                          ),
                          onPressed: () => ref
                              .read(cartProvider.notifier)
                              .selectCustomer(null),
                          icon: Icon(
                            Icons.clear,
                            color: Colors.red,
                          )),
                    ],
                  )
                : Text('walk_in'.tr()),
          ),
          if (cart.holdAt != null)
            IconButton(
              onPressed: () => confirmDeleteTransaction(context),
              icon: const Icon(
                CupertinoIcons.trash,
              ),
              color: Colors.red,
              iconSize: 18,
              tooltip: 'delete_transaction'.tr(),
              visualDensity: VisualDensity.compact,
            )
        ],
      ),
      body: cart.items.isNotEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              children: [
                HoldedBaner(cart: cart),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, idx) {
                      ItemCart item = cart.items[idx];
                      return CartItem(
                        item: item,
                        onPress: onPressItem,
                      );
                    },
                    itemCount: cart.items.length,
                  ),
                ),
                CartActions(
                  cart: cart,
                ),
              ],
            )
          : Center(
              child: Text(
                'cart_empty'.tr(),
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
