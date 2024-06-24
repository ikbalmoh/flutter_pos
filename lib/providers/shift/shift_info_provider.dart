import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/data/models/shift.dart';
import 'package:selleri/data/models/shift_info.dart';
import 'package:selleri/data/repository/shift_repository.dart';
import 'package:selleri/providers/shift/shift_provider.dart';
import 'package:uuid/uuid.dart';

part 'shift_info_provider.g.dart';

var uuid = const Uuid();

@riverpod
class ShiftInfoNotifier extends _$ShiftInfoNotifier {
  @override
  FutureOr<ShiftInfo?> build() async {
    final Shift? shift = ref.watch(shiftNotifierProvider).value;
    if (shift != null) {
      return ref.read(shiftRepositoryProvider).getShiftInfo(shift.id);
    }
    return null;
  }

  Future<void> reload() async {
    state = const AsyncLoading();
    try {
      final Shift? shift = ref.read(shiftNotifierProvider).value;
      if (shift != null) {
        final info =
            await ref.read(shiftRepositoryProvider).getShiftInfo(shift.id);
        state = AsyncData(info);
      } else {
        state = AsyncData(state.value);
      }
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }

  Future<void> submitCashflow(Map<String, dynamic> data,
      {Function? onSubmited}) async {
    final Shift? shift = ref.watch(shiftNotifierProvider).value;
    if (shift == null) {
      return;
    }
    Map<String, dynamic> payload = Map.from({
      ...data,
      'id': uuid.v4(),
      'shift_id': shift.id,
      'outlet_id': shift.outletId
    });
    await ref.read(shiftRepositoryProvider).storeCashflow(payload);
    reload();
    if (onSubmited != null) {
      onSubmited();
    }
  }
}
