import 'dart:convert';
import 'dart:developer';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/data/constants/store_key.dart';
import 'package:selleri/data/models/outlet.dart';
import 'package:selleri/data/models/outlet_config.dart';
import 'package:selleri/data/network/api.dart' show OutletApi;

part 'outlet_repository.g.dart';

@Riverpod(keepAlive: true)
OutletRepository outletRepository(OutletRepositoryRef ref) =>
    OutletRepository();

abstract class OutletRepositoryProtocol {
  Future<void> remove();

  Future<void> saveOutlet(Outlet outlet);

  Future<void> saveOutletConfig(OutletConfig config);

  Future<Outlet?> retrieveOutlet();

  Future<OutletConfig?> retrieveOutletConfig();

  Future<void> fetchOutletInfo(String idOutlet);

  Future<OutletConfig?> fetchOutletConfig(String idOutlet);
}

class OutletRepository implements OutletRepositoryProtocol {
  @override
  Future<void> remove() async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: StoreKey.outlet.toString());
  }

  @override
  Future<Outlet?> retrieveOutlet() async {
    const storage = FlutterSecureStorage();
    String? outletString = await storage.read(key: StoreKey.outlet.toString());
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
          await storage.read(key: StoreKey.outletConfig.toString());
      log('RETRIEVE CONFIG: $outletConfigString');
      if (outletConfigString != null) {
        final jsonConfig = json.decode(outletConfigString);
        log('JSON CONFIG: $jsonConfig');
        final config = OutletConfig.fromJson(jsonConfig);
        return config;
      }
      return null;
    } catch (e) {
      log('RETRIEVE CONFIG FAILED: $e');
      return null;
    }
  }

  @override
  Future<void> saveOutlet(Outlet outlet) async {
    const storage = FlutterSecureStorage();
    await storage.write(
        key: StoreKey.outlet.toString(), value: outlet.toString());
  }

  @override
  Future<void> saveOutletConfig(OutletConfig config) async {
    final configString = json.encode(config.toJson());
    log('SAVE CONFIG: $configString');
    const storage = FlutterSecureStorage();
    await storage.write(
        key: StoreKey.outletConfig.toString(), value: configString);
  }

  @override
  Future<void> fetchOutletInfo(String idOutlet) async {
    final api = OutletApi();
    try {
      await api.info(idOutlet);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<OutletConfig> fetchOutletConfig(String idOutlet,
      {List<String>? only = const [], OutletConfig? current}) async {
    final api = OutletApi();
    try {
      var configJson = await api.configs(idOutlet, only: only);

      if (current != null) {
        log('CURRENT CONFIG: $current');
        configJson = configJson..addAll(current.toJson());
      }

      log('NEW CONFIG: $configJson');

      final OutletConfig config = OutletConfig.fromJson(configJson);

      log('CONFIG CLASS:\n$configJson\n$config');

      saveOutletConfig(config);

      return config;
    } catch (e) {
      rethrow;
    }
  }
}
