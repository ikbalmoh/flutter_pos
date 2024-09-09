import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/data/models/shift_info.dart';
import 'package:selleri/data/repository/shift_repository.dart';
import 'package:uuid/uuid.dart';

part 'detail_shift_info_provider.g.dart';

var uuid = const Uuid();

@riverpod
class DetailShiftInfoNotifier extends _$DetailShiftInfoNotifier {
  @override
  FutureOr<ShiftInfo?> build(String shiftId) async {
    final info = await ref.read(shiftRepositoryProvider).getShiftInfo(shiftId);
    return info;
  }
}
