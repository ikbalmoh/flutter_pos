import 'dart:convert';
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
    const storage = FlutterSecureStorage();
    String? outletConfigString =
        await storage.read(key: StoreKey.outletConfig.toString());
    if (outletConfigString != null) {
      final jsonConfig = json.decode(outletConfigString);
      return OutletConfig.fromJson(jsonConfig);
    }
    return null;
  }

  @override
  Future<void> saveOutlet(Outlet outlet) async {
    const storage = FlutterSecureStorage();
    await storage.write(
        key: StoreKey.outlet.toString(), value: outlet.toString());
  }

  @override
  Future<void> saveOutletConfig(OutletConfig config) async {
    const storage = FlutterSecureStorage();
    await storage.write(
        key: StoreKey.outletConfig.toString(), value: config.toString());
  }

  @override
  Future<OutletConfig> fetchOutletConfig(String idOutlet) async {
    final api = OutletApi();
    final configJson = await api.configs(idOutlet);
    final OutletConfig config = OutletConfig.fromJson(configJson);
    saveOutletConfig(config);
    return config;
  }
}
