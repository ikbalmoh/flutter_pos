import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:selleri/providers/cart/cart_provider.dart';
import 'package:selleri/ui/widgets/loading_widget.dart';
import 'package:selleri/utils/formater.dart';

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

  void submitTransaction() async {
    try {
      Future.delayed(const Duration(seconds: 3), () {
        setState(() {
          status = Status.success;
        });
      });
      // final data =
      //     await ref.read(cartNotiferProvider.notifier).storeTransaction();
      // setState(() {
      //   status = Status.success;
      // });
    } on Exception catch (e) {
      log('TRANSACTION ERROR: $e');
      setState(() {
        status = Status.error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
      child: status == Status.loading
          ? const TransactionLoading()
          : status == Status.success
              ? const TransactionSuccess()
              : TransactionError(onRetry: submitTransaction),
    );
  }
}

class TransactionLoading extends StatelessWidget {
  const TransactionLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 30),
        const LoadingIndicator(color: Colors.teal),
        const SizedBox(height: 40),
        Text('transaction_loading'.tr()),
        const SizedBox(height: 30),
      ],
    );
  }
}

class TransactionSuccess extends ConsumerWidget {
  const TransactionSuccess({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void resetCart() {
      context.pop();

      // Reset Navigation
      // while (context.canPop() == true) {
      //   context.pop();
      // }
      // context.pushReplacementNamed(Routes.home);
      // ref.read(cartNotiferProvider.notifier).initCart();
    }

    TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'transaction_done'.tr(),
          style: textTheme.bodyLarge,
        ),
        const SizedBox(height: 30),
        Text(
          'change'.tr(),
          style: textTheme.bodyMedium?.copyWith(color: Colors.grey.shade800),
        ),
        const SizedBox(height: 5),
        Text(
          CurrencyFormat.currency(ref.watch(cartNotiferProvider).change),
          style: textTheme.displaySmall?.copyWith(
            fontSize: 30,
            fontWeight: FontWeight.w600,
            color: Colors.teal,
          ),
        ),
        const SizedBox(height: 40),
        Row(
          children: [
            TextButton(
              style:
                  TextButton.styleFrom(foregroundColor: Colors.grey.shade600),
              child: Text('print_receipt'.tr()),
              onPressed: () {},
            ),
            const SizedBox(width: 15),
            Expanded(
              child: ElevatedButton(
                onPressed: resetCart,
                style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                  ),
                ),
                child: Text(
                  'new_transaction'.tr(),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}

class TransactionError extends StatelessWidget {
  final Function() onRetry;
  const TransactionError({required this.onRetry, super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'transaction_error'.tr(),
          style: textTheme.bodyLarge?.copyWith(color: Colors.red.shade700),
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: onRetry,
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
    );
  }
}
