import 'dart:convert';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/features/cart/model/cart.dart' as model;
import 'package:selleri/features/cart/provider/cart_provider.dart';
import 'package:selleri/features/shift/provider/current_shift_info_provider.dart';
import 'package:selleri/features/shift/provider/shift_notifier_provider.dart';
import 'package:selleri/features/transaction/api/transaction_api.dart';
import 'package:selleri/features/transaction/provider/transactions_provider.dart';
import 'package:selleri/shared/objectbox.dart';

part 'offline_transactions_provider.g.dart';

@Riverpod(keepAlive: true)
class OfflineTransactions extends _$OfflineTransactions {
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  FirebaseCrashlytics crashlytics = FirebaseCrashlytics.instance;

  @override
  Future<List<model.Cart>> build() async {
    final offlineTransactions = await objectBox.offlineTransactions();

    return offlineTransactions;
  }

  Future<void> storeCurrentTransaction() async {
    final cart = ref.read(cartProvider);
    final transaction = cart.copyWith(
      isOffline: true,
    );

    await store(transaction);
  }

  Future<void> store(model.Cart transaction) async {
    transaction = transaction.copyWith(
      isOffline: true,
      transactionNo: transaction.transactionNo.replaceFirst('BILL-', ''),
    );

    final List<model.Cart> currentTransactions = state.value ?? [];
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      final stored = await objectBox.putTransaction(transaction);
      state = AsyncData(stored);
      ref.read(transactionsProvider.notifier).appendTransaction(transaction);
    } catch (e, stack) {
      log('Error storing offline transaction: $e\n$stack');
      crashlytics.recordError(
        'Error storing offline transaction: $e',
        stack,
        fatal: false,
        information: [
          transaction.toTransactionPayload(),
        ],
      );
      state = AsyncData(currentTransactions);
      throw 'Failed to store offline transaction: $e';
    }
  }

  Future<void> syncOfflineTransactions() async {
    if (state.isLoading) return;

    final transactions = state.value ?? [];
    if (transactions.isEmpty) {
      return;
    }

    state = const AsyncLoading();

    try {
      final shift =
          await ref.read(shiftNotifierProvider.notifier).getCurrentShift();
      if (shift == null) {
        throw 'shift_inactive'.tr();
      }
      log('SYNC OFFLINE TRANSACTIONS: ${transactions.map(
        (tr) => {
          'transaction_no': tr.transactionNo,
          'shiftId': shift.id,
          'items': tr.items.length,
          'total': tr.grandTotal,
        },
      )}');

      analytics.logEvent(
        name: 'sync_transaction_start',
        parameters: {
          'transaction_count': transactions.length,
          'transactions': transactions
              .map((tr) => jsonEncode(tr.toTransactionPayload()))
              .toList(),
        },
      );

      final syncedTransactions =
          // ignore: avoid_manual_providers_as_generated_provider_dependency
          await ref.read(transactionApiProvider).storeTransaction(transactions);

      log('SYNC TRANSACTIONS SUCCESS: ${syncedTransactions.map((tr) => tr.transactionNo)}');
      if (syncedTransactions.isNotEmpty) {
        analytics.logEvent(
          name: 'sync_transaction_success',
          parameters: {
            'transaction_count': syncedTransactions.length,
          },
        );
        final ids = syncedTransactions
            .map((transaction) => transaction.transactionNo)
            .toList();
        log('delete transactions $ids');
        await objectBox.deleteOfflineTransactions(ids);
        ref
            .read(transactionsProvider.notifier)
            .updateTransactions(syncedTransactions);
      }
      state = AsyncData(await objectBox.offlineTransactions());
      ref.invalidate(currentShiftInfoNotifierProvider);
      analytics.logEvent(
        name: 'sync_transaction_finish',
        parameters: {
          'transaction_count': transactions.length,
          'synced_count': syncedTransactions.length,
        },
      );
      return;
    } catch (e, st) {
      log('SYNC TRANSACTIONS FAILED: $e => $st');
      crashlytics.recordError(
        "Sync transactions failed: $e",
        st,
        fatal: false,
        information: [
          transactions
              .map((tr) => tr.toTransactionPayload().toString())
              .toList()
              .toString(),
        ],
      );
      state = AsyncData(transactions);
      rethrow;
    }
  }

  Future<void> delete(List<String> transactionNos) async {
    await objectBox.deleteOfflineTransactions(transactionNos);
    ref.invalidateSelf();
  }
}
