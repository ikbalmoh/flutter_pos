import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:selleri/data/models/cart.dart';
import 'package:selleri/data/models/item_cart.dart';
import 'package:selleri/providers/cart/cart_provider.dart';
import 'package:selleri/router/routes.dart';
import 'package:selleri/ui/components/cart_item.dart';
import 'package:selleri/ui/components/edit_cart_item.dart';
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
          title: "Delete ${item.itemName}",
          subtitle: 'Are you sure?',
          confirmLabel: 'Delete',
          danger: true, onConfirm: () {
        // Close Dialog
        ref.read(cartNotiferProvider.notifier).removeItem(item.identifier);
      });
    }

    void onPressItem(ItemCart item) {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) => EditCartItem(
          item: item,
          onDelete: () => onDeleteItem(item),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      appBar: AppBar(
        title: const Text('Cart'),
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
                CartActions(cart: cart),
              ],
            )
          : const Center(
              child: Text('Cart is Empty'),
            ),
    );
  }
}

class CartActions extends StatelessWidget {
  const CartActions({
    super.key,
    required this.cart,
  });

  final Cart cart;

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
                  Flexible(
                    flex: 1,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                      ),
                      onPressed: () {},
                      child: Text('hold'.toUpperCase()),
                    ),
                  ),
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
                      onPressed: () => context.push(Routes.checkout),
                      icon: const Icon(CupertinoIcons.creditcard_fill),
                      label: Text('checkout'.toUpperCase()),
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
