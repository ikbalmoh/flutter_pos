import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/data/models/cart.dart';
import 'package:selleri/data/models/outlet_config.dart';
import 'package:selleri/data/models/pagination.dart';
import 'package:selleri/data/network/transaction.dart';
import 'package:selleri/providers/outlet/outlet_provider.dart';
import 'package:selleri/providers/settings/printer_provider.dart';
import 'package:selleri/utils/printer.dart';

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

  Future<void> loadTransactions({int page = 1, String search = ''}) async {
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

  Future<void> printReceipt(Cart cart) async {
    try {
      final printer = ref.read(printerNotifierProvider).value;
      if (printer == null) {
        throw Exception('printer_not_connected'.tr());
      }
      final AttributeReceipts? attributeReceipts =
          (ref.read(outletNotifierProvider).value as OutletSelected)
              .config
              .attributeReceipts;
      final receipt = await Printer.buildReceiptBytes(cart,
          attributes: attributeReceipts, size: printer.size, isCopy: true);
      ref.read(printerNotifierProvider.notifier).print(receipt);
    } catch (error) {
      rethrow;
    }
  }
}
