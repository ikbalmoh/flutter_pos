import 'dart:developer';
import 'package:selleri/data/models/pagination.dart';
import 'package:selleri/data/models/shift.dart';
import 'package:selleri/data/network/shift.dart';
import 'package:selleri/providers/outlet/outlet_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'shift_list_provider.g.dart';

@riverpod
class ShiftListNotifier extends _$ShiftListNotifier {
  @override
  FutureOr<Pagination<Shift>> build() async {
    try {
      final api = ShiftApi();
      final outlet = ref.read(outletProvider).value as OutletSelected;
      final shifts = api.shifts(idOutlet: outlet.outlet.idOutlet);
      return shifts;
    } catch (e, stackTrace) {
      log('LIST SHIFTS ERROR: $e\n=> $stackTrace');
      rethrow;
    }
  }

  Future<void> loadShifts(
      {int page = 1, String search = '', DateTime? from, DateTime? to}) async {
    if (page == 1) {
      state = const AsyncLoading();
    } else {
      state = AsyncData(state.value!.copyWith(loading: true));
    }
    final api = ShiftApi();
    try {
      final outlet = ref.read(outletProvider).value as OutletSelected;
      var shifts = await api.shifts(
        page: page,
        q: search,
        idOutlet: outlet.outlet.idOutlet,
        from: from,
        to: to,
      );
      List<Shift> data = List.from(state.value?.data as Iterable<Shift>);
      if (page > 1) {
        data = data..addAll(shifts.data as Iterable<Shift>);
        shifts = shifts.copyWith(data: data, loading: false);
      }
      state = AsyncData(shifts);
    } catch (e, trace) {
      log('Load Shifts Error: $e');
      state = AsyncError(e, trace);
    }
  }
}
