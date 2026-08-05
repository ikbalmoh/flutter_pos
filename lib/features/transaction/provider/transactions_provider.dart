// ignore_for_file: avoid_manual_providers_as_generated_provider_dependency
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/features/cart/model/cart.dart';
import 'package:selleri/features/outlet/model/outlet_config.dart';
import 'package:selleri/features/transaction/provider/offline_transactions_provider.dart';
import 'package:selleri/shared/model/pagination.dart';
import 'package:selleri/features/transaction/api/transaction_api.dart';
import 'package:selleri/features/auth/provider/auth_provider.dart';
import 'package:selleri/features/outlet/provider/outlet_provider.dart';
import 'package:selleri/features/settings/provider/printer_provider.dart';
import 'package:selleri/features/shift/provider/shift_notifier_provider.dart';
import 'package:selleri/shared/provider/connectivity_status_provider.dart';
import 'package:selleri/shared/utils/authorization_helper.dart';
import 'package:selleri/shared/utils/printer.dart' as util;

part 'transactions_provider.g.dart';

@Riverpod(keepAlive: false)
class Transactions extends _$Transactions {
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  FirebaseCrashlytics crashlytics = FirebaseCrashlytics.instance;

  @override
  FutureOr<Pagination<Cart>> build() async {
    return await _fetchPage(page: 1, currentShift: true);
  }

  Future<Pagination<Cart>> _fetchPage({
    int page = 1,
    String search = '',
    bool? currentShift = false,
    String? table,
    List<Cart>? existingData,
  }) async {
    List<Cart> transactionsData =
        await ref.read(offlineTransactionsProvider.future) ?? [];
    log('Offline Transactions: ${transactionsData.map((tr) => tr.transactionNo).toList()}');

    final connection = ref.read(connectivityStatusProvider);

    if (existingData != null && existingData.isNotEmpty) {
      final offlineTransactionIds =
          transactionsData.map((tr) => tr.idTransaction).toList();
      List<Cart> prevTransactions = List.from(existingData);
      prevTransactions.removeWhere(
        (tr) =>
            offlineTransactionIds.contains(tr.idTransaction) ||
            tr.isOffline == true,
      );
      transactionsData += prevTransactions;
    }

    try {
      if (connection == ConnectivityState.disconnected) {
        throw 'disconnected';
      }

      final api = ref.watch(transactionApiProvider);
      final outlet = ref.read(outletProvider).value as OutletSelected;
      String? shiftId;
      if (currentShift == true) {
        shiftId = ref.read(shiftProvider).value?.id;
      }

      Pagination<Cart> transactions = await api.transactions(
        page: page,
        q: search,
        idOutlet: outlet.outlet.idOutlet,
        shiftId: shiftId,
        table: table,
      );

      if (page == 1) {
        transactionsData += (transactions.data ?? []);
        transactions = transactions.copyWith(data: transactionsData);
      } else {
        transactionsData.addAll(transactions.data as Iterable<Cart>);
        transactions =
            transactions.copyWith(data: transactionsData, loading: false);
      }
      return transactions;
    } on DioException catch (e, stack) {
      log('Load Transaction Network Error: $e\n$stack');
      crashlytics.recordError(
        'Load Transaction Network Error: $e',
        stack,
        fatal: false,
      );
      rethrow;
    } catch (e, stack) {
      log('Load Transaction Error: $e\n$stack');
      crashlytics.recordError(
        'Load Transaction Error: $e',
        stack,
        fatal: false,
      );
      return Pagination(
        currentPage: 0,
        lastPage: 0,
        total: transactionsData.length,
        data: transactionsData,
      );
    }
  }

  Future<void> loadTransactions({
    int page = 1,
    String search = '',
    bool? currentShift = false,
    String? table,
  }) async {
    log('Load Transaction: $page $search $currentShift $table');

    List<Cart>? existingData;
    if (page > 1 &&
        state.hasValue &&
        state.value?.data != null &&
        state.value?.data!.isNotEmpty == true) {
      existingData = List.from(state.value!.data!);
    }

    if (page == 1) {
      state = const AsyncLoading();
    } else {
      state = AsyncData(state.value!.copyWith(loading: true));
    }

    try {
      final result = await _fetchPage(
        page: page,
        search: search,
        currentShift: currentShift,
        table: table,
        existingData: existingData,
      );
      state = AsyncData(result);
    } on DioException catch (e, stack) {
      log('Load Transaction Network Error: $e\n$stack');
      rethrow;
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
      final bool printImage = printer.printImage;

      List<int> receipt;

      if (printImage) {
        receipt = await util.Printer.buildReceiptCaptureBytes(
          cart,
          outlet: outlet,
          size: printer.size,
          cut: printer.cut,
        );
      } else {
        receipt = await util.Printer.buildReceiptBytes(
          cart,
          outlet: outlet.outlet,
          attributes: attributeReceipts,
          size: printer.size,
          isCopy: true,
          isHold: isHold,
          withPrice: withPrice,
          cut: printer.cut,
          printIncludePpn: outlet.config.printIncludePpn ?? false,
          showWorkDuration: outlet.config.showWorkDuration ?? false,
        );
      }
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

  Future<void> appendTransaction(Cart transaction) async {
    if (state.value == null) {
      return;
    }

    state = AsyncData(
      state.value!.copyWith(
        data: [transaction] + (state.value?.data ?? []),
      ),
    );

    final payload = await transaction.toTransactionPayload();
    analytics.logEvent(
      name: 'add_transaction',
      parameters: {
        'transaction_no': transaction.transactionNo,
        'shift_id': transaction.shiftId,
        'transaction': payload.toString(),
      },
    );
  }

  void updateTransactions(List<Cart> transactions) {
    if (state.value == null) {
      return;
    }
    state = AsyncData(
      state.value!.copyWith(
        data: (state.value?.data ?? [])
            .map(
              (t) => transactions
                      .any((tr) => tr.transactionNo == t.transactionNo)
                  ? transactions
                      .firstWhere((tr) => tr.transactionNo == t.transactionNo)
                  : t,
            )
            .toList(),
      ),
    );
  }
}
