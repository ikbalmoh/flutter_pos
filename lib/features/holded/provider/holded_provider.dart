// ignore_for_file: avoid_manual_providers_as_generated_provider_dependency
import 'dart:developer';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/features/cart/model/cart_holded.dart';
import 'package:selleri/features/cart/provider/cart_provider.dart';
import 'package:selleri/shared/model/pagination.dart';
import 'package:selleri/features/transaction/api/transaction_api.dart';
import 'package:selleri/features/outlet/provider/outlet_provider.dart';
import 'package:selleri/shared/utils/authorization_helper.dart';

part 'holded_provider.g.dart';

@riverpod
class Holded extends _$Holded {
  @override
  FutureOr<Pagination<CartHolded>> build() async {
    try {
      final api = ref.watch(transactionApiProvider);
      final outlet = ref.read(outletProvider).value as OutletSelected;
      final holded = await api.holdedTransactions(
        idOutlet: outlet.outlet.idOutlet,
      );
      return holded;
    } catch (e, stackTrace) {
      log('HOLDED TRANSCATION ERROR: $e\n=> $stackTrace');
      rethrow;
    }
  }

  Future<void> loadTransaction({int page = 1, String? search}) async {
    if (page == 1) {
      state = const AsyncLoading();
    } else {
      state = AsyncData(state.value!.copyWith(loading: true));
    }
    try {
      final api = ref.read(transactionApiProvider);
      final outlet = ref.read(outletProvider).value as OutletSelected;
      var holded = await api.holdedTransactions(
        idOutlet: outlet.outlet.idOutlet,
        page: page,
        q: search,
      );

      if (!ref.mounted) return;

      List<CartHolded> data = List.from(
        state.value?.data as Iterable<CartHolded>,
      );
      if (page > 1) {
        data = data..addAll(holded.data as Iterable<CartHolded>);
        holded = holded.copyWith(data: data, loading: false);
      }
      state = AsyncData(holded);
    } catch (e, trace) {
      if (ref.mounted) {
        state = AsyncError(e, trace);
      }
    }
  }

  Future<bool> deleteHoldedTransaction(
    String transactionId, {
    required String reasonId,
    required String notes,
    bool? createNewTransaciton = false,
  }) async {
    try {
      final api = ref.read(transactionApiProvider);
      final cartNotifier = ref.read(cartProvider.notifier);

      final isAuthorize = await AuthorizationHelper.authorize('remove-hold');
      if (!isAuthorize) {
        return false;
      }

      if (createNewTransaciton == true) {
        cartNotifier.initCart();
      }
      
      await api.deleteHoldedTransaction(
        transactionId,
        reasonId: reasonId,
        notes: notes,
      );

      if (!ref.mounted) return true;

      state = AsyncData(
        state.value!.copyWith(
          data: state.value?.data
              ?.where((holded) => holded.transactionId != transactionId)
              .toList(),
        ),
      );
      return true;
    } catch (e) {
      rethrow;
    }
  }
}
