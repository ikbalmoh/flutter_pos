import 'dart:developer';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/features/cart/model/cart.dart' as model;
import 'package:selleri/features/transaction/api/transaction_api.dart';
import 'package:selleri/shared/objectbox.dart';

import 'package:selleri/shared/provider/connectivity_status_provider.dart';

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
    final List<model.Cart> currentTransactions = state.value ?? [];
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      final stored = await objectBox.putTransaction(transaction);
      log('OFFLINE TRANSACTION STORED $stored');
      state = AsyncData(stored);
    } catch (e) {
      log('Error storing offline transaction: $e');
      state = AsyncData(currentTransactions);
      throw 'Failed to store offline transaction: $e';
    }
  }

  Future<void> sync() async {
    if (state.isLoading) return;
    final connection = ref.read(connectivityStatusProvider);
    if (connection != ConnectivityState.connected) return;

    final transactions = state.value;
    state = const AsyncLoading();
    try {
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
        await objectBox.deleteOfflineTransactions(ids);
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
  }
}
