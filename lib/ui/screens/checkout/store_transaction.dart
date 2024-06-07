import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:selleri/providers/cart/cart_provider.dart';
import 'package:selleri/router/routes.dart';
import 'package:selleri/ui/widgets/loading_widget.dart';

class StoreTransaction extends ConsumerStatefulWidget {
  const StoreTransaction({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _StoreTransactionState();
}

enum Status { loading, success, error }

class _StoreTransactionState extends ConsumerState<StoreTransaction> {
  Status status = Status.loading;

  @override
  void initState() {
    submitTransaction();
    super.initState();
  }

  void resetCart(BuildContext context) {
    // Reset Navigation
    while (context.canPop() == true) {
      context.pop();
    }
    context.pushReplacementNamed(Routes.home);
    ref.read(cartNotiferProvider.notifier).initCart();
  }

  void submitTransaction() async {
    try {
      final data =
          await ref.read(cartNotiferProvider.notifier).storeTransaction();
      setState(() {
        status = Status.success;
      });
    } on Exception catch (e) {
      log('TRANSACTION ERROR: $e');
      setState(() {
        status = Status.error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 25),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: status == Status.loading
            ? [
                const LoadingIndicator(color: Colors.teal),
                const SizedBox(height: 20),
                Text('transaction_loading'.tr())
              ]
            : status == Status.success
                ? [
                    Text(
                      'transaction_done'.tr(),
                      style: textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () => resetCart(context),
                      style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                        ),
                      ),
                      child: Text(
                        'new_transaction'.tr(),
                      ),
                    )
                  ]
                : [
                    Text(
                      'transaction_error'.tr(),
                      style: textTheme.bodyLarge
                          ?.copyWith(color: Colors.red.shade700),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: submitTransaction,
                      style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                        ),
                      ),
                      child: Text(
                        'try_again'.tr(),
                      ),
                    )
                  ],
      ),
    );
  }
}
