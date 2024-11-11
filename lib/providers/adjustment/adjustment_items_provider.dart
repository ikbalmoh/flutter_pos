import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/data/models/pagination.dart';
import 'package:selleri/data/models/item_adjustment.dart';
import 'dart:developer';
import 'package:selleri/data/repository/item_repository.dart';
part 'adjustment_items_provider.g.dart';

@riverpod
class AdjustmentItems extends _$AdjustmentItems {
  @override
  FutureOr<Pagination<ItemAdjustment>> build() async {
    loadItems();
    return future;
  }

  Future<void> loadItems({
    int page = 1,
    DateTime? date,
    String? search,
    String? idCategory,
  }) async {
    try {
      final ItemRepository itemRepository = ref.read(itemRepositoryProvider);

      if (page == 1) {
        state = const AsyncLoading();
      } else {
        state = AsyncData(state.value!.copyWith(loading: true));
      }

      var items = await itemRepository.fetchAdjustmnetItems(
          page: page, date: date, search: search, idCategory: idCategory);

      List<ItemAdjustment> data = [];

      if (page > 1) {
        data = List.from(state.value?.data as Iterable<ItemAdjustment>);
        data = data..addAll(items.data as Iterable<ItemAdjustment>);
        items = items.copyWith(data: data, loading: false);
      }
      log('Items adjustments loaded: $items');
      state = AsyncData(items);
    } catch (e, trace) {
      log('Load items adjustments Error: $e => $trace');
      if (state is AsyncLoading) {
        state = AsyncError(e, trace);
      }
    }
  }
}
