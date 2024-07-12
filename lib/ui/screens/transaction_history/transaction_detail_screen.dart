import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/data/models/cart.dart';
import 'package:selleri/providers/shift/shift_provider.dart';
import 'package:selleri/providers/transaction/transactions_provider.dart';
import 'package:selleri/ui/components/cart/cancel_transaction_form.dart';
import 'package:selleri/ui/components/cart/order_summary.dart';
import 'package:selleri/utils/app_alert.dart';
import 'package:selleri/utils/formater.dart';

class TransactionDetailScreen extends ConsumerStatefulWidget {
  final Cart cart;

  const TransactionDetailScreen({required this.cart, super.key});

  @override
  ConsumerState<TransactionDetailScreen> createState() =>
      _TransactionDetailScreenState();
}

class _TransactionDetailScreenState
    extends ConsumerState<TransactionDetailScreen> {
  void onPrintReceipt() async {
    try {
      await ref.read(transactionsNotifierProvider.notifier).printReceipt(widget.cart);
    } catch (e) {
      log('PRINT FAILED: $e');
      // ignore: use_build_context_synchronously
      AppAlert.snackbar(context, e.toString());
    }
  }

  void onCancelTransaction() async {
    await showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        enableDrag: false,
        isDismissible: false,
        isScrollControlled: true,
        builder: (context) {
          return CancelTransactionForm(
            cart: widget.cart,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final currentShift = ref.read(shiftNotifierProvider).value;
    final transaction = ref
        .watch(transactionsNotifierProvider)
        .value
        ?.data!
        .firstWhere((cart) => cart.transactionNo == widget.cart.transactionNo);

    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        titleTextStyle: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
        title: Text(widget.cart.transactionNo),
        actions: [
          transaction?.deletedAt == null &&
                  transaction?.shiftId == currentShift?.id
              ? MenuAnchor(
                  style: MenuStyle(backgroundColor:
                      WidgetStateProperty.resolveWith<Color?>(
                          (Set<WidgetState> states) {
                    return Colors.white;
                  })),
                  menuChildren: [
                    MenuItemButton(
                      onPressed: onCancelTransaction,
                      leadingIcon: const Icon(
                        CupertinoIcons.xmark_circle_fill,
                        color: Colors.red,
                      ),
                      child: Text('cancel_transaction'.tr()),
                    ),
                  ],
                  builder: (BuildContext context, MenuController controller,
                      Widget? child) {
                    return IconButton(
                      onPressed: () {
                        if (controller.isOpen) {
                          controller.close();
                        } else {
                          controller.open();
                        }
                      },
                      icon: const Icon(Icons.more_vert),
                      tooltip: 'show_menu'.tr(),
                    );
                  },
                )
              : Container()
        ],
      ),
      body: transaction == null
          ? Container()
          : Column(
              children: [
                transaction.deletedAt != null
                    ? Container(
                        color: Colors.red.shade500,
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        child: Text(
                          '${'canceled'.tr()} ${DateTimeFormater.dateToString(transaction.deletedAt!, format: 'dd MMM y HH:mm')}',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.white),
                        ),
                      )
                    : Container(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 15),
                    child: OrderSummary(
                      radius: const Radius.circular(5),
                      cart: transaction,
                      isDone: true,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  child: ElevatedButton(
                    onPressed: onPrintReceipt,
                    child: Text('print_receipt'.tr()),
                  ),
                )
              ],
            ),
    );
  }
}
