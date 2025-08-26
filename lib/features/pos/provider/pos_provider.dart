import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/features/cart/model/cart.dart';
import 'package:selleri/features/cart/provider/cart_provider.dart'
    as cart_provider;
import 'package:selleri/features/shift/provider/shift_provider.dart';
import 'package:selleri/features/transaction/api/transaction_api.dart';
import 'package:selleri/features/transaction/provider/offline_transactions_provider.dart';
import 'package:selleri/features/transaction/provider/transactions_provider.dart';

part 'pos_provider.g.dart';

@Riverpod(keepAlive: true)
class Pos extends _$Pos {
  @override
  Future<bool> build() async {
    final offline = ref.watch(offlineTransactionsProvider()).value;
    log('SYNC TRANSACTIONS: $offline');
    if (offline != null && offline.isNotEmpty) {
      sync(offline);
    }
    return true;
  }

  Future<void> sync(List<Cart> offline) async {
    // if (state.isLoading) {
    //   log('SYNCINC STILL RUNNING');
    //   return;
    // }

    // ignore: avoid_manual_providers_as_generated_provider_dependency
    return ref.read(transactionApiProvider).storeTransaction(offline).then((_) {
      ref
          .read(offlineTransactionsProvider().notifier)
          .delete(offline.map((e) => e.transactionNo).toList());
      state = const AsyncData(true);
    }).catchError((e, st) {
      log('SYNC TRANSACTIONS FAILED: $e => $st');
      state = AsyncError(e, st);
    });
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
