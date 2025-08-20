import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/features/cart/model/cart.dart' as model;
import 'package:selleri/shared/objectbox.dart';

part 'offline_transactions_provider.g.dart';

@riverpod
class OfflineTransactions extends _$OfflineTransactions {
  @override
  Future<List<model.Cart>> build(
      {String? shiftId, String? transactioNo}) async {
    final offlineStream = objectBox.getOfflineTransactions(
        shiftId: shiftId, transactionNo: transactioNo);
    final offline = await offlineStream.first;
    List<model.Cart> transactions = [];
    for (var i = 0; i < offline.length; i++) {
      model.Cart cart = model.Cart.fromJson(jsonDecode(offline[i].transaction));
      transactions.add(cart);
    }
    return transactions;
  }

  Future<void> store(model.Cart transaction) async {
    await Future.delayed(const Duration(milliseconds: 500));
    await objectBox.putTransaction(transaction);
    ref.invalidateSelf();
  }

  Future<void> delete(List<String> transactionNos) async {
    int total = await objectBox.deleteOfflineTransactions(transactionNos);
    if (total > 0) {
      ref.invalidateSelf();
    }
  }
}
