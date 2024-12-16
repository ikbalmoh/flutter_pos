import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/data/models/pagination.dart';
import 'package:selleri/data/network/adjustment.dart';
import 'package:selleri/data/models/adjustment_history.dart' as model;

part 'adjustment_history_provider.g.dart';

@riverpod
class AdjustmentHistory extends _$AdjustmentHistory {
  @override
  FutureOr<Pagination<model.AdjustmentHistory>> build() async {
    loadAdjustmentHistory(page: 1);
    return future;
  }

  Future<void> loadAdjustmentHistory({
    int page = 1,
    String? search = '',
    DateTime? from,
    DateTime? to,
  }) async {
    try {
      final api = AdjustmentApi();

      final int nextPage = page;

      if (nextPage == 1) {
        state = const AsyncLoading();
      } else {
        state = AsyncData(state.value!.copyWith(loading: true));
      }

      List<model.AdjustmentHistory> history = [];

      var pagination = await api.adjustmentHistory(
          page: nextPage, search: search, from: from, to: to);

      if (nextPage > 1) {
        history =
            List.from(state.value?.data as Iterable<model.AdjustmentHistory>);
        history = history
          ..addAll(pagination.data as Iterable<model.AdjustmentHistory>);
        pagination = pagination.copyWith(data: history, loading: false);
      }

      state = AsyncData(pagination);
    } catch (e, trace) {
      if (state is AsyncLoading) {
        state = AsyncError(e, trace);
      }
    }
  }
}
