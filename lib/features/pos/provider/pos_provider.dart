import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/features/cart/model/cart.dart';
import 'package:selleri/features/cart/provider/cart_provider.dart'
    as cart_provider;
import 'package:selleri/features/shift/provider/shift_provider.dart';
import 'package:selleri/features/transaction/api/transaction_api.dart';
import 'package:selleri/features/transaction/provider/offline_transactions_provider.dart';
import 'package:selleri/features/transaction/provider/transactions_provider.dart';
import 'package:selleri/shared/provider/connectivity_status_provider.dart';

part 'pos_provider.g.dart';

@Riverpod(keepAlive: true)
class Pos extends _$Pos {
  @override
  Future<bool> build() async {
    final offline = ref.watch(offlineTransactionsProvider()).value;
    final connection = ref.watch(connectivityStatusProvider);

    debugPrint(
        'SYNC TRANSACTIONS\nconnection => $connection\ntransaction => ${offline?.map((tr) => tr.transactionNo).toList()}');
    if (connection == ConnectivityState.connected &&
        offline != null &&
        offline.isNotEmpty) {
      sync();
    }
    return true;
  }

  Future<void> sync() async {
    try {
      final transactions = ref.read(offlineTransactionsProvider()).value;
      if (transactions == null || transactions.isEmpty) {
        return;
      }
      final syncedTransactions =
          // ignore: avoid_manual_providers_as_generated_provider_dependency
          await ref.read(transactionApiProvider).storeTransaction(transactions);
      debugPrint('TRANSACTION SYNCED: $syncedTransactions');
      if (syncedTransactions.isNotEmpty) {
        ref.read(offlineTransactionsProvider().notifier).delete(
            syncedTransactions
                .map((transaction) => transaction.transactionNo)
                .toList());
      }
      state = const AsyncData(true);
    } catch (e, st) {
      debugPrint('SYNC FAILED: $e => $st');
      state = AsyncData(false);
    }
  }

  Future<void> store() async {
    final shift = ref.read(shiftProvider).value;
    if (shift == null) {
      throw 'shift_not_opened'.tr();
    }

    final cart = ref.read(cart_provider.cartProvider);
    final transaction = cart.copyWith(shiftId: shift.id, isOffline: true);

    await ref.read(offlineTransactionsProvider().notifier).store(transaction);

    ref.invalidateSelf();
    ref.invalidate(transactionsProvider);
  }
}
