import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/features/cart/model/cart.dart' as model;
import 'package:selleri/features/transaction/api/transaction_api.dart';
import 'package:selleri/shared/objectbox.dart';

part 'offline_transactions_provider.g.dart';

@Riverpod(keepAlive: true)
class OfflineTransactions extends _$OfflineTransactions {
  @override
  Future<List<model.Cart>> build() async {
    final transactions = await objectBox.offlineTransactions();
    log(
        'OFFLINE TRANSACTIONS UPDATED: ${transactions.map((tr) => tr.transactionNo).toList()}');
    return transactions;
  }

  Future<void> store(model.Cart transaction) async {
    state = const AsyncLoading();
    final List<model.Cart> currentTransactions = state.value ?? [];
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      final stored = await objectBox.putTransaction(transaction);
      log('OFFLINE TRANSACTION STORED $stored');
      state = AsyncData(stored);
      // ref.invalidateSelf();
      // ref.read(posProvider.notifier).sync();
    } catch (e) {
      log('Error storing offline transaction: $e');
      state = AsyncData(currentTransactions);
      throw 'Failed to store offline transaction: $e';
    }
  }

  Future<void> sync() async {
    state = const AsyncLoading();
    try {
      final transactions = ref.read(offlineTransactionsProvider).value;
      if (transactions == null || transactions.isEmpty) {
        return;
      }
      final syncedTransactions =
          // ignore: avoid_manual_providers_as_generated_provider_dependency
          await ref.read(transactionApiProvider).storeTransaction(transactions);
      log('TRANSACTIONS TO SYNC: $syncedTransactions');
      if (syncedTransactions.isNotEmpty) {
        final ids = syncedTransactions
            .map((transaction) => transaction.transactionNo)
            .toList();
        log('delete transactions $ids');
        ref.read(offlineTransactionsProvider.notifier).delete(ids);
      }
      ref.invalidateSelf();
    } catch (e, st) {
      log('SYNC FAILED: $e => $st');
      ref.invalidateSelf();
    }
  }

  Future<void> delete(List<String> transactionNos) async {
    await objectBox.deleteOfflineTransactions(transactionNos);
    ref.invalidateSelf();
    ref.invalidate(offlineTransactionsProvider);
  }
}
