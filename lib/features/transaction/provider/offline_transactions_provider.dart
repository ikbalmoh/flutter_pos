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

  /// Set to true when a transaction is stored while a sync is in progress.
  /// After the current sync completes, another cycle is triggered automatically.
  bool _syncNeeded = false;

  /// Tracks consecutive sync failures for exponential backoff on background
  /// syncs. Reset to 0 on success.
  int _retryCount = 0;
  static const int _initialBackoffMs = 1000;
  static const int _maxBackoffMs = 60000;

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
    try {
      final stored = await objectBox.putTransaction(transaction);
      state = AsyncData(stored);

      try {
        // ignore: avoid_manual_providers_as_generated_provider_dependency
        ref
            .read(transactionsProvider.notifier)
            .appendTransaction(transaction);
      } catch (e, stack) {
        // Non-fatal — ObjectBox write is already committed.
        // The in-memory provider will reconcile on its next refresh.
        log('appendTransaction failed (non-fatal): $e\n$stack');
      }

      // Flag for re-sync if a sync cycle is currently in flight.
      if (state.isLoading) {
        _syncNeeded = true;
      }
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

  /// Background sync with exponential backoff.
  ///
  /// Intended for use by connectivity and offline-list listeners — errors
  /// are logged but not propagated to avoid unhandled exceptions in
  /// fire-and-forget contexts.
  Future<void> syncBackground() async {
    await _applyBackoffIfNeeded();
    try {
      await syncOfflineTransactions();
    } catch (_) {
      // Background sync errors are expected (no network, shift closed, etc.),
      // and are already logged inside syncOfflineTransactions.
      // The listener will retry on the next connectivity change or manual
      // trigger.
    }
  }

  /// Syncs all pending offline transactions to the server.
  ///
  /// Safe to call from both background listeners (via [syncBackground]) and
  /// user-initiated actions (shift close, manual sync button). Errors are
  /// propagated to the caller so UI-facing callers can show feedback.
  Future<void> syncOfflineTransactions() async {
    if (state.isLoading) return;

    final transactions = state.value ?? [];
    if (transactions.isEmpty) {
      _retryCount = 0;
      return;
    }

    state = const AsyncLoading();
    _syncNeeded = false;

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

      _retryCount = 0;

      // If new transactions arrived during this sync, retrigger immediately.
      if (_syncNeeded) {
        _syncNeeded = false;
        syncOfflineTransactions();
      }
    } catch (e, st) {
      _retryCount++;
      log('SYNC TRANSACTIONS FAILED (attempt $_retryCount): $e => $st');
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

  /// Waits with exponential backoff when retrying a failed background sync.
  /// Only applies when [_retryCount] > 0 (i.e. after a previous failure).
  Future<void> _applyBackoffIfNeeded() async {
    if (_retryCount > 0) {
      final delay = (_initialBackoffMs * (1 << (_retryCount - 1)))
          .clamp(0, _maxBackoffMs);
      log('Sync retry backoff: ${delay}ms (attempt $_retryCount)');
      await Future.delayed(Duration(milliseconds: delay));
    }
  }
}
