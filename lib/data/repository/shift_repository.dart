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
ShiftRepository shiftRepository(ShiftRepositoryRef ref) => ShiftRepository(ref);

abstract class ShiftRepositoryProtocol {
  Future<void> close(String id, Map<String, dynamic> data);

  Future<void> clear();

  Future<Shift?> startShift(Shift outlet);

  Future<void> saveShift(Shift outlet);

  Future<Shift?> retrieveShift();
}

class ShiftRepository implements ShiftRepositoryProtocol {
  ShiftRepository(this._ref);

  final Ref _ref;

  final api = ShiftApi();

  @override
  Future<void> close(String id, Map<String, dynamic> payload) async {
    try {
      const storage = FlutterSecureStorage();
      await api.closeShift(id, payload);
      await storage.delete(key: StoreKey.shift.toString());
    } catch (e, stackTrack) {
      log('CLOSE SHIFT ERROR: $e => $stackTrack');
      rethrow;
    }
  }

  @override
  Future<Shift?> retrieveShift() async {
    try {
      final outletRepository = _ref.read(outletRepositoryProvider);
      const storage = FlutterSecureStorage();
      final outlet = await outletRepository.retrieveOutlet();
      if (outlet == null) {
        return null;
      }
      String? stringShift = await storage.read(key: StoreKey.shift.toString());
      if (stringShift != null) {
        final shift = Shift.fromJson(json.decode(stringShift));
        if (outlet.idOutlet != shift.outletId) {
          await storage.delete(key: StoreKey.shift.toString());
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
      final storedShift = await api.startShift(shift);
      if (storedShift != null) {
        await saveShift(storedShift);
        return storedShift;
      }
      return null;
    } on DioException catch (e) {
      throw e.response?.data['msg'] ?? e.message;
    } catch (e) {
      rethrow;
    }
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

  Future<void> storeCashflow(Map<String, dynamic> data) async {
    try {
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
    await storage.write(key: StoreKey.shift.toString(), value: stringShift);
  }

  @override
  Future<void> clear() async {
    await storage.delete(key: StoreKey.shift.toString());
  }
}
