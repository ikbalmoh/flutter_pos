import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/features/cart/provider/cart_provider.dart'
    as cart_provider;
import 'package:selleri/features/shift/provider/shift_provider.dart';
import 'package:selleri/features/transaction/provider/offline_transactions_provider.dart';
import 'package:selleri/features/transaction/provider/transactions_provider.dart';
import 'package:selleri/shared/provider/connectivity_status_provider.dart';

part 'pos_provider.g.dart';

@Riverpod(keepAlive: true)
class Pos extends _$Pos {
  @override
  Future<bool> build() async {
    final offlineState = ref.watch(offlineTransactionsProvider);
    final connection = ref.watch(connectivityStatusProvider);

    if (offlineState.isLoading) return false;

    final offline = offlineState.value;

    log(
        'SYNC TRANSACTIONS\nconnection => $connection\ntransaction => ${offline?.map((tr) => tr.transactionNo).toList()}');

    return true;
  }

  Future<void> sync() async {
    await ref.read(offlineTransactionsProvider.notifier).sync();
  }

  Future<void> store() async {
    final shift = ref.read(shiftProvider).value;
    if (shift == null) {
      throw 'shift_not_opened'.tr();
    }

    final cart = ref.read(cart_provider.cartProvider);
    final transaction = cart.copyWith(
      shiftId: shift.id,
      isOffline: true,
    );

    await ref.read(offlineTransactionsProvider.notifier).store(transaction);

    ref.invalidate(transactionsProvider);
  }
}
