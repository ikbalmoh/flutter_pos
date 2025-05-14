// ignore_for_file: avoid_manual_providers_as_generated_provider_dependency
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/data/models/pagination.dart';
import 'package:selleri/data/models/receiving/receiving_detail.dart';
import 'package:selleri/data/network/receiving.dart';
import 'package:selleri/providers/outlet/outlet_provider.dart';

part 'receiving_history_provider.g.dart';

@riverpod
class ReceivingHistory extends _$ReceivingHistory {
  @override
  FutureOr<Pagination<ReceivingDetail>> build() async {
    loadReceivingHistory(page: 1);
    return future;
  }

  Future<void> loadReceivingHistory({
    int page = 1,
    String? search = '',
    String? type = '',
    DateTime? date,
  }) async {
    try {
      final api = ref.watch(receivingApiProvider);

      final int nextPage = page;

      if (nextPage == 1) {
        state = const AsyncLoading();
      } else {
        state = AsyncData(state.value!.copyWith(loading: true));
      }

      List<ReceivingDetail> history = [];

      final outlet = ref.watch(outletProvider).value as OutletSelected;

      var pagination = await api.receivingHistory(
          idOutlet: outlet.outlet.idOutlet,
          page: nextPage,
          search: search,
          date: date,
          type: type);

      if (nextPage > 1) {
        history = List.from(state.value?.data as Iterable<ReceivingDetail>);
        history = history..addAll(pagination.data as Iterable<ReceivingDetail>);
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
