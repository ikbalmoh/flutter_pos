import 'package:easy_localization/easy_localization.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/features/cart/model/cart.dart' as model;
import 'package:selleri/features/cart/provider/cart_provider.dart';
import 'package:selleri/features/shift/provider/shift_provider.dart';
import 'package:selleri/shared/objectbox.dart';

part 'offline_transactions_provider.g.dart';

@riverpod
class OfflineTransactions extends _$OfflineTransactions {
  @override
  List<model.Cart> build() {
    final offlineTransactions = objectBox.getOfflineTransactions();

    return offlineTransactions;
  }

  Future<void> store() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final shift = ref.read(shiftProvider).value;
    if (shift == null) {
      throw 'shift_not_opened'.tr();
    }

    final cart = ref.read(cartProvider);
    final transaction = cart.copyWith(
      shiftId: shift.id,
    );

    objectBox.putTransaction(transaction);
    state = [...state, transaction];
  }
}
