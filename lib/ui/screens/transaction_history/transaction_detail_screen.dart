import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/data/models/cart.dart';
import 'package:selleri/ui/components/cart/order_summary.dart';

class TransactionDetailScreen extends ConsumerWidget {
  final Cart cart;

  const TransactionDetailScreen({required this.cart, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        child: OrderSummary(
          radius: const Radius.circular(5),
          cart: cart,
        ),
      ),
    );
  }
}
