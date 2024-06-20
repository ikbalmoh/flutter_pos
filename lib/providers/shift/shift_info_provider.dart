import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/data/models/shift.dart';
import 'package:selleri/data/models/shift_info.dart';
import 'package:selleri/data/repository/shift_repository.dart';
import 'package:selleri/providers/shift/shift_provider.dart';

part 'shift_info_provider.g.dart';

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
}
