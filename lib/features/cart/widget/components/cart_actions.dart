import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:selleri/features/promotion/model/promotion.dart';
import 'package:selleri/features/cart/provider/cart_provider.dart';
import 'package:selleri/features/outlet/provider/outlet_provider.dart';
import 'package:selleri/features/promotion/provider/promotions_provider.dart';
import 'package:selleri/shared/router/routes.dart';
import 'package:selleri/features/cart/widget/components/promotions/cart_promotions.dart';
import 'package:selleri/features/cart/widget/components/promotions/cart_promotions_list.dart';
import 'package:selleri/features/holded/widget/components/hold_button.dart';
import 'package:selleri/shared/utils/app_alert.dart';
import 'package:selleri/shared/utils/formater.dart';
import 'package:selleri/features/cart/model/cart.dart' as model;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/shared/widget/custom_fields_form.dart';

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

  void continueToPayment(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    try {
      final promotions = ref.read(promotionsProvider);
      final appliedPromotions = ref.read(cartProvider).promotions;
      if (promotions.isNotEmpty && appliedPromotions.isEmpty) {
        List<Promotion>? promotions = await showModalBottomSheet(
            backgroundColor: Colors.white,
            isScrollControlled: true,
            context: context,
            isDismissible: false,
            useSafeArea: true,
            builder: (context) {
              return CartPromotionsList(
                  confirmText: 'continue_without_promo'.tr());
            });

        log('promotions $promotions');

        if (promotions != null) {
          ref.read(cartProvider.notifier).applyPromotions(promotions);
          if (context.mounted) {
            context.push(Routes.checkout);
          }
        }
      } else {
        context.push(Routes.checkout);
      }
    } catch (e) {
      AppAlert.toast(e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void onCheckout(BuildContext context) async {
    final outletState = ref.read(outletProvider).value as OutletSelected;
    final config = outletState.config;

    final isCustomerRequired = config.customerTransMandatory ?? false;

    final customFieldConfig = config.customFields?.modules.transaction;
    final customFieldFilled = ref.read(cartProvider).customFields ?? [];

    final hasUnfilledRequired = ref.read(cartProvider).skipCustomField
        ? false
        : customFieldConfig?.any((c) {
              if (!c.isRequired) return false;
              final filled = customFieldFilled.where((f) => f.id == c.id);
              if (filled.isEmpty) return true;
              final value = filled.first.value;
              return value == null || value.toString().trim().isEmpty;
            }) ??
            false;

    if (isCustomerRequired && widget.cart.idCustomer == null) {
      AppAlert.toast('select_customer'.tr());
      context.push(Routes.customers);
    } else if (hasUnfilledRequired) {
      CustomFieldsForm(
        title: 'additional_information'.tr(),
        fields: customFieldFilled,
        onValuesChange: (values) {
          ref.read(cartProvider.notifier).setCustomField(values);
          continueToPayment(context);
        },
        onSkip: () {
          ref.read(cartProvider.notifier).setSkipCustomField(true);
          continueToPayment(context);
        },
      ).show(context);
    } else {
      continueToPayment(context);
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
