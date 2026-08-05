import 'dart:developer';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/features/shift/model/shift.dart' as model;
import 'package:selleri/features/shift/model/shift_info.dart';
import 'package:selleri/features/shift/repository/shift_repository.dart';
import 'package:selleri/features/outlet/provider/outlet_provider.dart';
import 'package:uuid/uuid.dart';
import 'shift_notifier_provider.dart';

part 'current_shift_info_provider.g.dart';

var uuid = const Uuid();

@riverpod
class CurrentShiftInfoNotifier extends _$CurrentShiftInfoNotifier {
  @override
  FutureOr<ShiftInfo?> build() async {
    final model.Shift? shift = ref.watch(shiftProvider).value;
    if (shift != null) {
      bool didDispose = false;
      ref.onDispose(() => didDispose = true);

      await Future<void>.delayed(const Duration(milliseconds: 1000));
      if (didDispose) return null;

      try {
        final ShiftInfo? shiftInfo =
            await ref.read(shiftRepositoryProvider).getShiftInfo(shift.id);
        if (shiftInfo != null) {
          log('current shift: $shiftInfo');
          final config =
              (ref.read(outletProvider).value as OutletSelected).config;
          if (config.addOns?.contains('accounting') == true) {
            ref
                .read(outletProvider.notifier)
                .refreshConfig(only: ['saldo_akun_kas']);
          }
        }
        return shiftInfo;
      } catch (e) {
        return null;
      }
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
        final config =
            (ref.read(outletProvider).value as OutletSelected).config;
        if (config.addOns?.contains('accounting') == true) {
          ref
              .read(outletProvider.notifier)
              .refreshConfig(only: ['saldo_akun_kas']);
        }
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
