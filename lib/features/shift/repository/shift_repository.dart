import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/shared/constants/store_key.dart';
import 'package:selleri/features/shift/model/shift.dart';
import 'package:selleri/features/shift/model/shift_info.dart';
import 'package:selleri/features/shift/api/shift_api.dart';
import 'package:selleri/features/outlet/repository/outlet_repository.dart';
import 'dart:developer';

import 'package:selleri/shared/provider/connectivity_status_provider.dart';

part 'shift_repository.g.dart';

@Riverpod(keepAlive: true)
ShiftRepository shiftRepository(Ref ref) => ShiftRepository(ref);

abstract class ShiftRepositoryProtocol {
  Future<void> close(String id, Map<String, dynamic> data);

  Future<void> clear();

  Future<void> changeOpenAmount(String shiftId, double amount);

  Future<Shift?> startShift(Shift outlet);

  Future<void> saveShift(Shift shift);

  Future<void> saveShiftInfo(String shiftId, ShiftInfo shiftInfo);

  Future<Shift?> retrieveShift();

  Future<Shift?> retrieveOfflineShift();
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
      log('Retrieving Online Shift...');
      final connectivityState = _ref.read(connectivityStatusProvider);
      if (connectivityState != ConnectivityState.connected) {
        return retrieveOfflineShift();
      }
      final outletRepository = _ref.read(outletRepositoryProvider);
      final outlet = await outletRepository.retrieveOutlet();
      log('Shift Outlet: ${outlet?.outletName}');
      if (outlet == null) {
        return null;
      }
      final api = _ref.read(shiftApiProvider);
      final Shift? shift = await api.activeShift(outlet.idOutlet);
      log('RETRIEVED ONLINE SHIFT: ${shift?.toJson()}');
      return shift;
    } catch (e) {
      log('RETIREVE ONLINE SHIFT FAILED: ${e.toString()}');
    }
    return await retrieveOfflineShift();
  }

  @override
  Future<Shift?> retrieveOfflineShift() async {
    try {
      log('Retrieving Offline Shift...');
      final outletRepository = _ref.read(outletRepositoryProvider);
      const storage = FlutterSecureStorage();
      final outlet = await outletRepository.retrieveOutlet();
      log('Shift Outlet: ${outlet?.outletName}');
      if (outlet == null) {
        return null;
      }
      // check connectivity
      String? stringShift = await storage.read(key: StoreKey.shift.name);
      log('Local Current Shift: $stringShift');
      if (stringShift != null) {
        final shift = Shift.fromJson(json.decode(stringShift));
        if (outlet.idOutlet != shift.outletId) {
          await storage.delete(key: StoreKey.shift.name);
          return null;
        }
        return shift;
      }
      return null;
    } catch (e) {
      log('RETIREVE OFFLINE SHIFT FAILED: ${e.toString()}');
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
      final api = _ref.read(shiftApiProvider);
      final shiftInfo = await api.shiftInfo(shiftId);
      if (shiftInfo != null) {
        await saveShiftInfo(shiftId, shiftInfo);
      }
      return shiftInfo;
    } catch (e, _) {
      log('SHIFT INFO ERROR: $e');
      // check saved shift info
      const storage = FlutterSecureStorage();
      String? stringShiftInfo =
          await storage.read(key: '${StoreKey.shiftInfo.name}[$shiftId]');
      if (stringShiftInfo != null) {
        final shiftInfo = ShiftInfo.fromJson(json.decode(stringShiftInfo));
        log('OFFLINE SHIFT INFO: $shiftInfo');
        return shiftInfo;
      }
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
  Future<void> saveShiftInfo(String shiftId, ShiftInfo shiftInfo) async {
    const storage = FlutterSecureStorage();
    final shiftJson = shiftInfo.toJson();
    final stringShift = json.encode(shiftJson);
    await storage.write(
        key: '${StoreKey.shiftInfo.name}[$shiftId]', value: stringShift);
  }

  @override
  Future<void> clear() async {
    await storage.delete(key: StoreKey.shift.name);
  }
}
