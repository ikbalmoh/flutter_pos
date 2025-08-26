import 'dart:convert';
import 'dart:developer';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/features/cart/model/cart.dart' as model;
import 'package:selleri/shared/objectbox.dart';

part 'offline_transactions_provider.g.dart';

@Riverpod(keepAlive: true)
class OfflineTransactions extends _$OfflineTransactions {
  @override
  Future<List<model.Cart>> build(
      {String? shiftId, String? transactioNo}) async {
    final transactions = await objectBox.offlineTransactions();
    log('OFFLINE TRANSACTIONS: ${transactions.map((tr) => tr.transactionNo).toList()}');
    return transactions;
  }

  Future<void> store(model.Cart transaction) async {
    final List<model.Cart> currentTransactions = state.value ?? [];
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      final stored = await objectBox.putTransaction(transaction);
      log('New Offline $stored');
      state = AsyncData(stored);
    } catch (e) {
      log('Error storing offline transaction: $e');
      state = AsyncData(currentTransactions);
      throw 'Failed to store offline transaction: $e';
    }
  }

  Future<void> delete(List<String> transactionNos) async {
    int total = await objectBox.deleteOfflineTransactions(transactionNos);
    if (total > 0) {
      ref.invalidateSelf();
    }
  }
}
