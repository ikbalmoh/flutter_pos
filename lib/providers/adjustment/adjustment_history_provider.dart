import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/data/models/pagination.dart';
import 'package:selleri/data/network/adjustment.dart';
import 'package:selleri/data/models/adjustment_history.dart' as model;

part 'adjustment_history_provider.g.dart';

@riverpod
class AdjustmentHistory extends _$AdjustmentHistory {
  @override
  FutureOr<Pagination<model.AdjustmentHistory>> build() async {
    load(page: 1);
    return future;
  }

  Future<void> load({int page = 1}) async {
    try {
      final api = AdjustmentApi();

      if (page == 1) {
        state = const AsyncLoading();
      } else {
        state = AsyncData(state.value!.copyWith(loading: true));
      }

      List<model.AdjustmentHistory> history = [];

      var pagination = await api.adjustmentHistory(page: page);

      if (page > 1) {
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
