import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/data/constants/store_key.dart';
import 'package:selleri/data/models/shift.dart';
import 'package:selleri/data/repository/shift_repository.dart';
import 'package:selleri/providers/auth/auth_provider.dart';
import 'package:selleri/providers/auth/auth_state.dart';
import 'package:selleri/providers/outlet/outlet_provider.dart';
import 'package:uuid/uuid.dart';

part 'shift_provider.g.dart';

var uuid = const Uuid();

@Riverpod(keepAlive: true)
class ShiftNotifier extends _$ShiftNotifier {
  late final ShiftRepository _shiftRepository =
      ref.read(shiftRepositoryProvider);

  @override
  FutureOr<Shift?> build() async {
    final shift = await _shiftRepository.retrieveShift();
    return shift;
  }

  Future<void> openShift(double openAmount) async {
    final outletState =
        await ref.read(outletNotifierProvider.future) as OutletSelected;
    final authState =
        await ref.read(authNotifierProvider.future) as Authenticated;

    final userAccount = authState.user.user;

    const storage = FlutterSecureStorage();
    final deviceId = await storage.read(key: StoreKey.device.toString());

    final outlet = outletState.outlet;

    final shift = Shift(
      id: uuid.v4(),
      outletId: outlet.idOutlet,
      outletName: outlet.outletName,
      deviceId: deviceId!,
      createdAt: DateTime.now(),
      createdBy: userAccount.idUser,
      createdName: userAccount.name,
      updatedBy: userAccount.idUser,
      updatedName: userAccount.name,
      startShift: DateTime.now(),
      openAmount: openAmount,
    );
    try {
      final storedShift = await _shiftRepository.saveShift(shift);
      state = AsyncData(storedShift);
    } on DioException catch (e) {
      String message = e.response?.data['msg'] ?? e.message;
      if (kDebugMode) {
        print('OPEN SHIFT FAILED: $message');
      }
    }
  }

  Future<void> closeShift(double closeAmount) async {
    final shift = state.value
        ?.copyWith(closeAmount: closeAmount, closeShift: DateTime.now());
    // Send to API
    await _shiftRepository.close(shift);
    state = const AsyncData(null);
  }
}
