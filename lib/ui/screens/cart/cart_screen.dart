import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:selleri/data/models/cart.dart';
import 'package:selleri/data/models/item_cart.dart';
import 'package:selleri/providers/cart/cart_provider.dart';
import 'package:selleri/providers/outlet/outlet_provider.dart';
import 'package:selleri/router/routes.dart';
import 'package:selleri/ui/components/cart/cart_item.dart';
import 'package:selleri/ui/components/cart/edit_cart_item_form.dart';
import 'package:selleri/ui/components/hold/hold_button.dart';
import 'package:selleri/utils/app_alert.dart';
import 'package:selleri/utils/formater.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartNotiferProvider);

    void onDeleteItem(ItemCart item) {
      if (context.canPop()) {
        context.pop();
      }
      AppAlert.confirm(context,
          title: "${'delete'.tr()} ${item.itemName}",
          subtitle: 'are_you_sure'.tr(),
          confirmLabel: 'delete'.tr(),
          danger: true, onConfirm: () async {
        await ref
            .read(cartNotiferProvider.notifier)
            .removeItem(item.identifier!);
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

    void onCheckout() {
      final outletState = ref.read(outletNotifierProvider).value;
      bool isCustomerRequired = outletState is OutletSelected
          ? (outletState.config.customerTransMandatory ?? false)
          : false;

      if (isCustomerRequired && cart.idCustomer == null) {
        AppAlert.toast('select_customer'.tr());
        context.push(Routes.customers);
      } else {
        context.push(Routes.checkout);
      }
    }

    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      appBar: AppBar(
        title: Text('cart'.tr()),
      ),
      body: cart.items.isNotEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              children: [
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
                  onSubmit: onCheckout,
                ),
              ],
            )
          : Center(
              child: Text('cart_empty'.tr()),
            ),
    );
  }
}

class CartActions extends StatelessWidget {
  const CartActions({
    super.key,
    required this.cart,
    required this.onSubmit,
  });

  final Cart cart;
  final Function() onSubmit;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      margin: const EdgeInsets.all(0),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 15,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Subtotal',
                    style: TextStyle(color: Colors.blueGrey.shade700),
                  ),
                  Text(
                    CurrencyFormat.currency(cart.subtotal),
                    style: Theme.of(context).textTheme.bodyLarge,
                  )
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const HoldButton(),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                      ),
                      onPressed: onSubmit,
                      icon: const Icon(CupertinoIcons.creditcard_fill),
                      label: Text('payments'.tr().toUpperCase()),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
