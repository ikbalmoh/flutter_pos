import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/data/models/pagination.dart';
import 'package:selleri/data/models/item_adjustment.dart';
import 'dart:developer';

import 'package:selleri/data/network/adjustment.dart';

part 'adjustment_items_provider.g.dart';

@riverpod
class AdjustmentItems extends _$AdjustmentItems {
  @override
  FutureOr<Pagination<ItemAdjustment>> build() async {
    return const Pagination<ItemAdjustment>(
      currentPage: 0,
      lastPage: 0,
      total: 0,
      from: 0,
      to: 0,
      data: [],
    );
  }

  Future<void> loadItems(
      {int page = 1, DateTime? date, String search = ''}) async {
    if (page == 1) {
      state = const AsyncLoading();
    } else {
      state = AsyncData(state.value!.copyWith(loading: true));
    }
    final api = AdjustmentApi();
    try {
      var items = await api.itemsForAdjustment(page: page, search: search);
      List<ItemAdjustment> data =
          List.from(state.value?.data as Iterable<ItemAdjustment>);
      if (page > 1) {
        data = data..addAll(items.data as Iterable<ItemAdjustment>);
        items = items.copyWith(data: data, loading: false);
      }
      state = AsyncData(items);
    } catch (e, trace) {
      log('Load items adjustments Error: $e');
      if (state is AsyncLoading) {
        state = AsyncError(e, trace);
      }
    }
  }
}
