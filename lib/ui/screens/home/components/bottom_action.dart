import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:selleri/data/models/cart.dart';
import 'package:selleri/router/routes.dart';
import 'package:selleri/utils/formater.dart';

class BottomActions extends StatelessWidget {
  const BottomActions({
    super.key,
    required this.cart,
  });

  final Cart cart;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      margin: const EdgeInsets.all(0),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 12,
          ),
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.blue,
                      ),
                      onPressed: () {},
                      child: Text('hold'.tr().toUpperCase()),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 3,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                      ),
                      onPressed: () => context.push(Routes.cart),
                      icon: Badge(
                        label: Text(
                          cart.items.length.toString(),
                        ),
                        child: const Icon(CupertinoIcons.shopping_cart),
                      ),
                      label: Text(
                        CurrencyFormat.currency(cart.subtotal),
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(color: Colors.white),
                      ),
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
