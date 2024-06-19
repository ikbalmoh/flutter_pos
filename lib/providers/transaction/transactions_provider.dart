import 'dart:developer';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/data/models/cart.dart';
import 'package:selleri/data/models/pagination.dart';
import 'package:selleri/data/network/transaction.dart';
import 'package:selleri/providers/outlet/outlet_provider.dart';

part 'transactions_provider.g.dart';

@riverpod
class TransactionsNotifier extends _$TransactionsNotifier {
  @override
  FutureOr<Pagination<Cart>> build() async {
    try {
      final api = TransactionApi();
      final outlet = ref.read(outletNotifierProvider).value as OutletSelected;
      final transactions =
          await api.transactions(idOutlet: outlet.outlet.idOutlet);
      return transactions;
    } catch (e, stackTrace) {
      log('LIST TRANSCATION ERROR: $e\n=> $stackTrace');
      rethrow;
    }
  }

  void loadTransactions({int page = 1, String search = ''}) async {
    if (page == 1) {
      state = const AsyncLoading();
    } else {
      state = AsyncData(state.value!.copyWith(loading: true));
    }
    final api = TransactionApi();
    try {
      final outlet = ref.read(outletNotifierProvider).value as OutletSelected;
      var customers = await api.transactions(
          page: page, q: search, idOutlet: outlet.outlet.idOutlet);
      List<Cart> data = List.from(state.value?.data as Iterable<Cart>);
      if (page > 1) {
        data = data..addAll(customers.data as Iterable<Cart>);
        customers = customers.copyWith(data: data, loading: false);
      }
      state = AsyncData(customers);
    } catch (e, trace) {
      log('Load Transaction Error: $e');
      state = AsyncError(e, trace);
    }
  }
}
