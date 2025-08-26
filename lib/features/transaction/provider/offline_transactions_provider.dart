import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/features/cart/model/cart.dart' as model;
import 'package:selleri/features/pos/provider/pos_provider.dart';
import 'package:selleri/shared/objectbox.dart';

part 'offline_transactions_provider.g.dart';

@Riverpod(keepAlive: true)
class OfflineTransactions extends _$OfflineTransactions {
  @override
  Future<List<model.Cart>> build(
      {String? shiftId, String? transactioNo}) async {
    final transactions = await objectBox.offlineTransactions();
    debugPrint(
        'OFFLINE TRANSACTIONS UPDATED: ${transactions.map((tr) => tr.transactionNo).toList()}');
    return transactions;
  }

  Future<void> store(model.Cart transaction) async {
    final List<model.Cart> currentTransactions = state.value ?? [];
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      final stored = await objectBox.putTransaction(transaction);
      debugPrint('OFFLINE TRANSACTION STORED $stored');
      state = AsyncData(stored);
      ref.invalidate(offlineTransactionsProvider);
      ref.read(posProvider.notifier).sync();
    } catch (e) {
      debugPrint('Error storing offline transaction: $e');
      state = AsyncData(currentTransactions);
      throw 'Failed to store offline transaction: $e';
    }
  }

  Future<void> delete(List<String> transactionNos) async {
    await objectBox.deleteOfflineTransactions(transactionNos);
    ref.invalidateSelf();
    ref.invalidate(offlineTransactionsProvider);
  }
}
