import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:selleri/providers/outlet/outlet_provider.dart';
import 'package:selleri/router/routes.dart';
import 'package:selleri/ui/components/cart/promotions/cart_promotions.dart';
import 'package:selleri/ui/components/hold/hold_button.dart';
import 'package:selleri/utils/app_alert.dart';
import 'package:selleri/utils/formater.dart';
import 'package:selleri/data/models/cart.dart' as model;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartActions extends ConsumerStatefulWidget {
  const CartActions({
    super.key,
    required this.cart,
  });

  final model.Cart cart;

  @override
  ConsumerState<CartActions> createState() => _CartActionsState();
}

class _CartActionsState extends ConsumerState<CartActions> {
  bool isLoading = false;

  void onCheckout(BuildContext context) async {
    final outletState = ref.read(outletProvider).value;
    bool isCustomerRequired = outletState is OutletSelected
        ? (outletState.config.customerTransMandatory ?? false)
        : false;

    if (isCustomerRequired && widget.cart.idCustomer == null) {
      AppAlert.toast('select_customer'.tr());
      context.push(Routes.customers);
    } else {
      setState(() {
        isLoading = true;
      });
      // await ref.read(cartProvider.notifier).checkPromotionByOrder();
      setState(() {
        isLoading = false;
      });
      if (context.mounted) {
        context.push(Routes.checkout);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      margin: const EdgeInsets.all(0),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CartPromotions(),
            Padding(
              padding: const EdgeInsets.all(15),
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
                        CurrencyFormat.currency(widget.cart.subtotal),
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
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                            ),
                          ),
                          onPressed:
                              isLoading ? null : () => onCheckout(context),
                          child: Text('payments'.tr().toUpperCase()),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
