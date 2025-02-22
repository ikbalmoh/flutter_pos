import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/data/models/shift.dart' as model;
import 'package:selleri/data/models/shift_info.dart';
import 'package:selleri/data/repository/shift_repository.dart';
import 'package:selleri/providers/outlet/outlet_provider.dart';
import 'package:selleri/providers/shift/shift_provider.dart';
import 'package:uuid/uuid.dart';

part 'current_shift_info_provider.g.dart';

var uuid = const Uuid();

@riverpod
class ShiftInfoNotifier extends _$ShiftInfoNotifier {
  @override
  FutureOr<ShiftInfo?> build() async {
    final model.Shift? shift = ref.watch(shiftProvider).value;
    if (shift != null) {
      return ref.read(shiftRepositoryProvider).getShiftInfo(shift.id);
    }
    return null;
  }

  Future<void> reload() async {
    state = const AsyncLoading();
    try {
      final model.Shift? shift = ref.read(shiftProvider).value;
      if (shift != null) {
        final info =
            await ref.read(shiftRepositoryProvider).getShiftInfo(shift.id);
        state = AsyncData(info);
        ref
            .read(outletProvider.notifier)
            .refreshConfig(only: ['saldo_akun_kas']);
      } else {
        state = AsyncData(state.value);
      }
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }

  Future<void> submitCashflow(Map<String, dynamic> data,
      {Function? onSubmited}) async {
    final model.Shift? shift = ref.watch(shiftProvider).value;
    if (shift == null) {
      return;
    }
    if (data['id'] == null) {
      data['id'] = uuid.v4();
    }
    data['shift_id'] = shift.id;
    data['outlet_id'] = shift.outletId;
    await ref.read(shiftRepositoryProvider).storeCashflow(data);
    reload();
    if (onSubmited != null) {
      onSubmited();
    }
  }
}
