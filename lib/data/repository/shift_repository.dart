import 'dart:convert';
import 'package:dio/dio.dart';
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
ShiftRepository shiftRepository(Ref ref) => ShiftRepository(ref);

abstract class ShiftRepositoryProtocol {
  Future<void> close(String id, Map<String, dynamic> data);

  Future<void> clear();

  Future<void> changeOpenAmount(String shiftId, double amount);

  Future<Shift?> startShift(Shift outlet);

  Future<void> saveShift(Shift outlet);

  Future<Shift?> retrieveShift();
}

class ShiftRepository implements ShiftRepositoryProtocol {
  ShiftRepository(this._ref);

  final Ref _ref;

  @override
  Future<void> changeOpenAmount(String shiftId, double amount) async {
    try {
      final api = _ref.watch(shiftApiProvider);
      await api.changeOpenAmount(shiftId, amount);
    } catch (e, stackTrack) {
      log('CHANGE OPEN AMOUNT ERROR: $e => $stackTrack');
      rethrow;
    }
  }

  @override
  Future<void> close(String id, Map<String, dynamic> payload) async {
    try {
      const storage = FlutterSecureStorage();
      final api = _ref.watch(shiftApiProvider);
      await api.closeShift(id, payload);
      await storage.delete(key: StoreKey.shift.name);
    } catch (e, stackTrack) {
      log('CLOSE SHIFT ERROR: $e => $stackTrack');
      rethrow;
    }
  }

  @override
  Future<Shift?> retrieveShift() async {
    try {
      final api = _ref.watch(shiftApiProvider);
      final outletRepository = _ref.read(outletRepositoryProvider);
      const storage = FlutterSecureStorage();
      final outlet = await outletRepository.retrieveOutlet();
      if (outlet == null) {
        return null;
      }
      String? stringShift = await storage.read(key: StoreKey.shift.name);
      if (stringShift != null) {
        final shift = Shift.fromJson(json.decode(stringShift));
        if (outlet.idOutlet != shift.outletId) {
          await storage.delete(key: StoreKey.shift.name);
          return null;
        }
        return shift;
      } else {
        log('CHECKING ACTIVE SHIFT FROM SERVER...');
        final Shift? shift = await api.activeShift(outlet.idOutlet);
        return shift;
      }
    } catch (e) {
      log('RETIREVE CURRENT SHIFT FAILED: ${e.toString()}');
    }
    return null;
  }

  @override
  Future<Shift?> startShift(Shift shift) async {
    try {
      final api = _ref.watch(shiftApiProvider);
      final storedShift = await api.startShift(shift);
      if (storedShift != null) {
        await saveShift(storedShift);
        return storedShift;
      }
      return null;
    } on DioException catch (e) {
      throw e.message!;
    } catch (e) {
      rethrow;
    }
  }

  Future<ShiftInfo?> getShiftInfo(String shiftId) async {
    try {
      final api = _ref.watch(shiftApiProvider);
      final shiftInfo = await api.shiftInfo(shiftId);
      return shiftInfo;
    } catch (e, stackTrack) {
      log('SHIFT INFO ERROR: $e => $stackTrack');
      rethrow;
    }
  }

  Future<void> storeCashflow(Map<String, dynamic> data) async {
    try {
      final api = _ref.watch(shiftApiProvider);
      final cashflow = await api.storeCashflow(data);
      return cashflow;
    } catch (e, stackTrack) {
      log('STORE CASHFLOW ERROR: $e => $stackTrack');
      rethrow;
    }
  }

  @override
  Future<void> saveShift(Shift shift) async {
    const storage = FlutterSecureStorage();
    final shiftJson = shift.toJson();
    final stringShift = json.encode(shiftJson);
    await storage.write(key: StoreKey.shift.name, value: stringShift);
  }

  @override
  Future<void> clear() async {
    await storage.delete(key: StoreKey.shift.name);
  }
}
