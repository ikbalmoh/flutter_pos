import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/features/elastic/repository/elastic_repository.dart';
import 'package:selleri/features/outlet/model/refund_reason.dart';
import 'package:selleri/shared/constants/store_key.dart';
import 'package:selleri/features/outlet/model/outlet.dart';
import 'package:selleri/features/outlet/model/outlet_config.dart';
import 'package:selleri/features/outlet/api/outlet_api.dart';

part 'outlet_repository.g.dart';

@Riverpod(keepAlive: true)
OutletRepository outletRepository(Ref ref) => OutletRepository(ref);

abstract class OutletRepositoryProtocol {
  Future<void> remove();

  Future<void> saveOutlet(Outlet outlet);

  Future<void> saveOutletConfig(OutletConfig config);

  Future<Outlet?> retrieveOutlet();

  Future<OutletConfig?> retrieveOutletConfig();

  Future<void> fetchOutletInfo(String idOutlet);

  Future<OutletConfig?> fetchOutletConfig(String idOutlet);

  Future<List<RefundReason>> refundReasons({String? module = 'delete_hold'});
}

class OutletRepository implements OutletRepositoryProtocol {
  OutletRepository(this._ref);

  final Ref _ref;

  @override
  Future<void> remove() async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: StoreKey.outlet.name);
  }

  @override
  Future<Outlet?> retrieveOutlet() async {
    const storage = FlutterSecureStorage();
    String? outletString = await storage.read(key: StoreKey.outlet.name);
    if (outletString != null) {
      final jsonOutlet = json.decode(outletString);
      return Outlet.fromJson(jsonOutlet);
    }
    return null;
  }

  @override
  Future<OutletConfig?> retrieveOutletConfig() async {
    try {
      const storage = FlutterSecureStorage();
      String? outletConfigString =
          await storage.read(key: StoreKey.outletConfig.name);
      if (outletConfigString != null) {
        final jsonConfig = json.decode(outletConfigString);
        final config = OutletConfig.fromJson(jsonConfig);
        return config;
      }
      return null;
    } on DioException catch (e) {
      throw e.message!;
    } catch (e) {
      log('RETRIEVE CONFIG FAILED: $e');
      return null;
    }
  }

  @override
  Future<void> saveOutlet(Outlet outlet) async {
    const storage = FlutterSecureStorage();
    await storage.write(key: StoreKey.outlet.name, value: outlet.toString());
  }

  @override
  Future<void> saveOutletConfig(OutletConfig config) async {
    final configString = json.encode(config.toJson());
    const storage = FlutterSecureStorage();
    await storage.write(key: StoreKey.outletConfig.name, value: configString);
  }

  @override
  Future<void> fetchOutletInfo(String idOutlet) async {
    final api = _ref.watch(outletApiProvider);
    try {
      await api.info(idOutlet);
    } on DioException catch (e) {
      throw e.message!;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<OutletConfig> fetchOutletConfig(
    String idOutlet, {
    List<String>? only = const [],
    OutletConfig? current,
  }) async {
    try {
      final esRepo = _ref.read(elasticRepositoryProvider);
      final elasticConfig = await esRepo.outletConfig();

      saveOutletConfig(elasticConfig);

      return elasticConfig;
    } catch (e) {
      log('ES outlet config error: $e');
    }

    final api = _ref.watch(outletApiProvider);

    try {
      var configJson = await api.configs(idOutlet, only: only);

      if (current != null) {
        configJson = current.toJson()..addAll(configJson);
      }

      final OutletConfig config = OutletConfig.fromJson(configJson);

      saveOutletConfig(config);

      return config;
    } on DioException catch (e) {
      throw e.message!;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<RefundReason>> refundReasons({String? module = 'delete_hold'}) async {
    final api = _ref.watch(outletApiProvider);
    try {
      return await api.refundReasons(module: module);
    } on DioException catch (e) {
      throw e.message!;
    } catch (e) {
      rethrow;
    }
  }
}
