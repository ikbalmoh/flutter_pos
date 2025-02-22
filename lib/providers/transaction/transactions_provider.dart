// ignore_for_file: avoid_manual_providers_as_generated_provider_dependency
import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/data/models/cart.dart';
import 'package:selleri/data/models/outlet_config.dart';
import 'package:selleri/data/models/pagination.dart';
import 'package:selleri/data/network/transaction.dart';
import 'package:selleri/providers/auth/auth_provider.dart';
import 'package:selleri/providers/outlet/outlet_provider.dart';
import 'package:selleri/providers/settings/printer_provider.dart';
import 'package:selleri/providers/shift/shift_provider.dart';
import 'package:selleri/utils/printer.dart' as util;

part 'transactions_provider.g.dart';

@riverpod
class Transactions extends _$Transactions {
  @override
  FutureOr<Pagination<Cart>> build() async {
    try {
      final api = ref.watch(transactionApiProvider);
      final outlet = ref.read(outletProvider).value as OutletSelected;
      String? shiftId = ref.watch(shiftProvider).value?.id;
      final transactions = await api.transactions(
          idOutlet: outlet.outlet.idOutlet, shiftId: shiftId);
      return transactions;
    } catch (e, stackTrace) {
      log('LIST TRANSCATION ERROR: $e\n=> $stackTrace');
      rethrow;
    }
  }

  Future<void> loadTransactions(
      {int page = 1, String search = '', bool? currentShift = false}) async {
    if (page == 1) {
      state = const AsyncLoading();
    } else {
      state = AsyncData(state.value!.copyWith(loading: true));
    }
    final api = ref.watch(transactionApiProvider);
    try {
      final outlet = ref.read(outletProvider).value as OutletSelected;
      String? shiftId;
      if (currentShift == true) {
        shiftId = ref.read(shiftProvider).value?.id;
      }
      var customers = await api.transactions(
          page: page,
          q: search,
          idOutlet: outlet.outlet.idOutlet,
          shiftId: shiftId);
      List<Cart> data = List.from(state.value?.data as Iterable<Cart>);
      if (page > 1) {
        data = data..addAll(customers.data as Iterable<Cart>);
        customers = customers.copyWith(data: data, loading: false);
      }
      state = AsyncData(customers);
    } catch (e, trace) {
      log('Load Transaction Error: $e\n$trace');
      state = AsyncError(e, trace);
    }
  }

  Future<void> printReceipt(Cart cart,
      {bool isHold = false, bool withPrice = true}) async {
    try {
      final printer = ref.read(printerProvider).value;
      if (printer == null) {
        throw 'printer_not_connected'.tr();
      }
      final AttributeReceipts? attributeReceipts =
          (ref.read(outletProvider).value as OutletSelected)
              .config
              .attributeReceipts;
      final outlet = ref.read(outletProvider).value as OutletSelected;

      final receipt = await util.Printer.buildReceiptBytes(
        cart,
        outlet: outlet.outlet,
        attributes: attributeReceipts,
        size: printer.size,
        isCopy: true,
        isHold: isHold,
        withPrice: withPrice,
        cut: printer.cut,
      );
      ref.read(printerProvider.notifier).print(receipt);
    } catch (error) {
      rethrow;
    }
  }

  Future<Cart> cancelTransaction(Cart cart,
      {required String deleteReason}) async {
    try {
      final api = ref.watch(transactionApiProvider);
      final userId =
          (ref.read(authProvider).value as Authenticated).user.user.idUser;

      final transaction = cart.copyWith(
          deletedAt: DateTime.now(),
          deleteReason: deleteReason,
          deletedBy: userId);

      log('DELETE TRANSACTION: $transaction');

      final res = await api.storeTransaction(transaction);

      if (res.isEmpty) {
        throw Exception('transaction_error'.tr());
      }

      final index = state.value?.data!
          .indexWhere((t) => t.idTransaction == transaction.idTransaction);

      final transactions = List<Cart>.from(state.value!.data!);
      if (index != null) {
        transactions[index] = transaction;
      }

      log('TRANSACTION DELETED: $index => $transaction');
      state = AsyncData(state.value!.copyWith(data: transactions));

      return transaction;
    } catch (e) {
      log('CANCEL TRANSACTION ERROR: $e');
      throw Exception(e);
    }
  }
}
