import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/data/constants/store_key.dart';
import 'package:selleri/data/models/shift.dart';
import 'package:selleri/data/models/shift_info.dart';
import 'package:selleri/data/network/shift.dart';
import 'package:selleri/data/repository/outlet_repository.dart';
import 'dart:developer';

part 'shift_repository.g.dart';

@Riverpod(keepAlive: true)
ShiftRepository shiftRepository(ShiftRepositoryRef ref) => ShiftRepository(ref);

abstract class ShiftRepositoryProtocol {
  Future<void> close(Shift shift);

  Future<Shift?> saveShift(Shift outlet);

  Future<Shift?> retrieveShift();
}

class ShiftRepository implements ShiftRepositoryProtocol {
  ShiftRepository(this._ref);

  final Ref _ref;

  final api = ShiftApi();

  @override
  Future<void> close(Shift? shift) async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: StoreKey.shift.toString());
  }

  @override
  Future<Shift?> retrieveShift() async {
    try {
      final outletRepository = _ref.read(outletRepositoryProvider);
      const storage = FlutterSecureStorage();
      String? stringShift = await storage.read(key: StoreKey.shift.toString());
      if (stringShift != null) {
        final shift = Shift.fromJson(json.decode(stringShift));
        final outlet = await outletRepository.retrieveOutlet();
        if (outlet?.idOutlet != shift.outletId) {
          await close(shift);
          return null;
        }
        return shift;
      }
    } catch (e) {
      log('RETIREVE CURRENT SHIFT FAILED: ${e.toString()}');
    }
    return null;
  }

  @override
  Future<Shift?> saveShift(Shift shift) async {
    final storedShift = await api.startShift(shift);
    if (storedShift != null) {
      const storage = FlutterSecureStorage();
      final shiftJson = storedShift.toJson();
      final stringShift = json.encode(shiftJson);
      await storage.write(key: StoreKey.shift.toString(), value: stringShift);
      return storedShift;
    }
    return null;
  }

  Future<ShiftInfo?> getShiftInfo(String shiftId) async {
    try {
      final shiftInfo = await api.shiftInfo(shiftId);
      return shiftInfo;
    } catch (e, stackTrack) {
      log('SHIFT INFO ERROR: $e => $stackTrack');
      rethrow;
    }
  }
}
