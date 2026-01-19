// ignore_for_file: avoid_manual_providers_as_generated_provider_dependency
import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/features/cart/model/cart.dart';
import 'package:selleri/features/outlet/model/outlet_config.dart';
import 'package:selleri/features/transaction/provider/offline_transactions_provider.dart';
import 'package:selleri/shared/model/pagination.dart';
import 'package:selleri/features/transaction/api/transaction_api.dart';
import 'package:selleri/features/auth/provider/auth_provider.dart';
import 'package:selleri/features/outlet/provider/outlet_provider.dart';
import 'package:selleri/features/settings/provider/printer_provider.dart';
import 'package:selleri/features/shift/provider/shift_provider.dart';
import 'package:selleri/shared/provider/connectivity_status_provider.dart';
import 'package:selleri/shared/utils/authorization_helper.dart';
import 'package:selleri/shared/utils/printer.dart' as util;

part 'transactions_provider.g.dart';

@Riverpod(keepAlive: false)
class Transactions extends _$Transactions {
  @override
  FutureOr<Pagination<Cart>> build() async {
    ref.watch(connectivityStatusProvider);
    loadTransactions(page: 1, currentShift: true);
    return future;
  }

  Future<void> loadTransactions({
    int page = 1,
    String search = '',
    bool? currentShift = false,
    String? table,
  }) async {
    final offlineTransactions =
        ref.read(offlineTransactionsProvider).value ?? [];
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
      var transactions = await api.transactions(
        page: page,
        q: search,
        idOutlet: outlet.outlet.idOutlet,
        shiftId: shiftId,
        table: table,
      );
      List<Cart> data =
          state.hasValue ? List.from(state.value?.data as Iterable<Cart>) : [];
      if (page == 1) {
        final offlineTransactions =
            ref.read(offlineTransactionsProvider).value ?? [];
        if (offlineTransactions.isNotEmpty) {
          List<String> offlineTransactionNsNo =
              offlineTransactions.map((t) => t.transactionNo).toList();
          List<Cart> transactionsData =
              List<Cart>.from(transactions.data ?? []);

          transactionsData.removeWhere(
              (t) => offlineTransactionNsNo.contains(t.transactionNo));

          transactions = transactions.copyWith(
            data: transactionsData,
          );
        }
      } else {
        data = data..addAll(transactions.data as Iterable<Cart>);
        transactions = transactions.copyWith(data: data, loading: false);
      }
      state = AsyncData(transactions);
    } catch (e, trace) {
      log('Load Transaction Error: $e\n$trace');
      state = AsyncData(Pagination(
        currentPage: 0,
        lastPage: 0,
        total: offlineTransactions.length,
        data: offlineTransactions,
      ));
    }
  }

  Future<void> printReceipt(Cart cart,
      {bool isHold = false, bool withPrice = true}) async {
    try {
      log('PRINT RECEIPT $cart');
      final printer = ref.read(printerProvider).value;
      if (printer == null) {
        throw 'printer_not_connected'.tr();
      }
      final isAuthorize = await AuthorizationHelper.authorize('print-receipt');
      if (!isAuthorize) {
        return;
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
        printIncludePpn: outlet.config.printIncludePpn ?? false,
      );
      ref.read(printerProvider.notifier).print(receipt);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> printKitchen(Cart cart,
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

      final receipt = await util.Printer.buildKitchenReceiptBytes(
        cart,
        outlet: outlet.outlet,
        attributes: attributeReceipts,
        size: printer.size,
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
      final userId =
          (ref.read(authProvider).value as Authenticated).user.user.idUser;

      final transaction = cart.copyWith(
          deletedAt: DateTime.now(),
          deleteReason: deleteReason,
          deletedBy: userId);

      log('DELETE TRANSACTION: $transaction');

      await ref.read(offlineTransactionsProvider.notifier).store(transaction);

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
