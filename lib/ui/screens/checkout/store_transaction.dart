import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:selleri/providers/cart/cart_provider.dart';
import 'package:selleri/ui/components/generic/loading_placeholder.dart';
import 'package:selleri/utils/app_alert.dart';
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
  int printCounter = 0;
  String error = '';

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    submitTransaction();
    super.initState();
  }

  void resetCart() {
    // Reset Navigation
    while (context.canPop() == true) {
      context.pop();
    }
    ref.read(cartNotiferProvider.notifier).initCart();
  }

  void onPrintReceipt() async {
    try {
      await ref
          .read(cartNotiferProvider.notifier)
          .printReceipt(printCounter: printCounter);
      setState(() {
        printCounter++;
      });
    } catch (e) {
      log('PRINT TRANSACTION FAILED: $e');
      AppAlert.toast(e.toString());
    }
  }

  void submitTransaction() async {
    if (status != Status.loading) {
      setState(() {
        status = Status.loading;
      });
    }
    try {
      await ref.read(cartNotiferProvider.notifier).storeTransaction();
      setState(() {
        status = Status.success;
      });
      onPrintReceipt();
    } catch (e, stackTrace) {
      log('TRANSACTION ERROR: ${e.toString()}\n${stackTrace.toString()}');
      setState(() {
        status = Status.error;
        error = e.toString();
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
          ? const LoadingPlaceholder()
          : status == Status.success
              ? TransactionSuccess(
                  onReset: resetCart,
                  onPrintReceipt: onPrintReceipt,
                )
              : TransactionError(
                  onRetry: submitTransaction,
                  onReset: resetCart,
                  error: error,
                ),
    );
  }
}

class TransactionSuccess extends ConsumerWidget {
  final Function() onReset;
  final Function() onPrintReceipt;
  const TransactionSuccess({
    required this.onReset,
    required this.onPrintReceipt,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              onPressed: onPrintReceipt,
              child: Text('print_receipt'.tr()),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: ElevatedButton(
                onPressed: onReset,
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
  final Function() onReset;
  final Function() onRetry;
  final String? error;
  const TransactionError(
      {required this.onRetry, this.error, super.key, required this.onReset});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        const Icon(CupertinoIcons.exclamationmark_circle,
            color: Colors.red, size: 50),
        const SizedBox(height: 20),
        Text(
          'transaction_error'.tr(),
          style: textTheme.bodyLarge?.copyWith(color: Colors.red.shade700),
        ),
        const SizedBox(height: 14),
        Text(
          error ?? '',
          style: textTheme.bodySmall?.copyWith(color: Colors.grey.shade500),
        ),
        const SizedBox(height: 40),
        Row(
          children: [
            TextButton(
              style:
                  TextButton.styleFrom(foregroundColor: Colors.grey.shade600),
              onPressed: onReset,
              child: Text('new_transaction'.tr()),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                  ),
                ),
                icon: const Icon(CupertinoIcons.refresh),
                label: Text(
                  'try_again'.tr(),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
