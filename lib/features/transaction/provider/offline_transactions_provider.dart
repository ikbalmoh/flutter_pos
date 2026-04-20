import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/features/cart/model/cart.dart' as model;
import 'package:selleri/features/cart/provider/cart_provider.dart';
import 'package:selleri/features/shift/provider/shift_provider.dart';
import 'package:selleri/features/transaction/api/transaction_api.dart';
import 'package:selleri/features/transaction/provider/transactions_provider.dart';
import 'package:selleri/shared/objectbox.dart';

part 'offline_transactions_provider.g.dart';

@Riverpod(keepAlive: true)
class OfflineTransactions extends _$OfflineTransactions {
  @override
  Future<List<model.Cart>> build() async {
    final offlineTransactions = await objectBox.offlineTransactions();

    return offlineTransactions;
  }

  Future<void> storeCurrentTransaction() async {
    final shift = ref.read(shiftProvider).value;
    if (shift == null) {
      throw 'shift_not_opened'.tr();
    }

    final cart = ref.read(cartProvider);
    final transaction = cart.copyWith(
      shiftId: shift.id,
      isOffline: true,
    );

    await store(transaction);
  }

  Future<void> store(model.Cart transaction) async {
    transaction = transaction.copyWith(isOffline: true);

    final List<model.Cart> currentTransactions = state.value ?? [];
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      final stored = await objectBox.putTransaction(transaction);
      state = AsyncData(stored);
      ref.read(transactionsProvider.notifier).appendTransaction(transaction);
    } catch (e) {
      log('Error storing offline transaction: $e');
      state = AsyncData(currentTransactions);
      throw 'Failed to store offline transaction: $e';
    }
  }

  Future<void> sync() async {
    if (state.isLoading) return;

    final transactions = state.value ?? [];
    if (transactions.isEmpty) {
      return;
    }
    state = const AsyncLoading();
    try {
      log('SYNC OFFLINE TRANSACTIONS: ${transactions.map(
        (tr) => {
          'transaction_no': tr.transactionNo,
          'shiftId': tr.shiftId,
          'items': tr.items.length,
          'total': tr.grandTotal,
        },
      )}');
      final syncedTransactions =
          // ignore: avoid_manual_providers_as_generated_provider_dependency
          await ref.read(transactionApiProvider).storeTransaction(transactions);

      log('SYNC TRANSACTIONS SUCCESS: ${syncedTransactions.map((tr) => tr.transactionNo)}');
      if (syncedTransactions.isNotEmpty) {
        final ids = syncedTransactions
            .map((transaction) => transaction.transactionNo)
            .toList();
        log('delete transactions $ids');
        await objectBox.deleteOfflineTransactions(ids);
        ref
            .read(transactionsProvider.notifier)
            .updateTransactions(syncedTransactions);
      }
      state = AsyncData([]);
    } catch (e, st) {
      log('SYNC TRANSACTIONS FAILED: $e => $st');
      state = AsyncData(transactions);
    }
  }

  Future<void> delete(List<String> transactionNos) async {
    await objectBox.deleteOfflineTransactions(transactionNos);
    ref.invalidateSelf();
  }
}
