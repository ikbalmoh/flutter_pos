// ignore_for_file: avoid_manual_providers_as_generated_provider_dependency
import 'dart:developer';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/data/models/cart_holded.dart';
import 'package:selleri/data/models/pagination.dart';
import 'package:selleri/data/network/transaction.dart';
import 'package:selleri/providers/outlet/outlet_provider.dart';

part 'holded_provider.g.dart';

@riverpod
class Holded extends _$Holded {
  @override
  FutureOr<Pagination<CartHolded>> build() async {
    try {
      final api = ref.watch(transactionApiProvider);
      final outlet = ref.read(outletProvider).value as OutletSelected;
      final holded =
          await api.holdedTransactions(idOutlet: outlet.outlet.idOutlet);
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
      final api = ref.watch(transactionApiProvider);
      final outlet = ref.read(outletProvider).value as OutletSelected;
      var holded = await api.holdedTransactions(
          idOutlet: outlet.outlet.idOutlet, page: page, q: search);
      List<CartHolded> data =
          List.from(state.value?.data as Iterable<CartHolded>);
      if (page > 1) {
        data = data..addAll(holded.data as Iterable<CartHolded>);
        holded = holded.copyWith(data: data, loading: false);
      }
      state = AsyncData(holded);
    } on Exception catch (e, trace) {
      state = AsyncError(e, trace);
    }
  }
}
