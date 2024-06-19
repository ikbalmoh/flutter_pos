import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/data/models/cart.dart';
import 'package:selleri/providers/transaction/transactions_provider.dart';
import 'package:selleri/ui/components/cart/order_summary.dart';

class TransactionDetailScreen extends ConsumerWidget {
  final Cart cart;

  const TransactionDetailScreen({required this.cart, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void onPrintReceipt() {
      try {
        ref.read(transactionsNotifierProvider.notifier).printReceipt(cart);
      } catch (e) {
        log('PRINT FAILED: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }

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
        title: Text(cart.transactionNo),
      ),
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: OrderSummary(
                    radius: const Radius.circular(5),
                    cart: cart,
                  ),
                ),
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.print),
                onPressed: onPrintReceipt,
                label: Text('print_receipt'.tr()),
              )
            ],
          )),
    );
  }
}
