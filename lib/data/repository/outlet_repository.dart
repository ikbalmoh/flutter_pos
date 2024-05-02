import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/data/constants/store_key.dart';
import 'package:selleri/data/models/outlet.dart';

part 'outlet_repository.g.dart';

@Riverpod(keepAlive: true)
OutletRepository outletRepository(OutletRepositoryRef ref) => OutletRepository();

abstract class OutletRepositoryProtocol {
  Future<void> remove();

  Future<void> saveOutlet(Outlet outlet);

  Future<Outlet?> retrievOutlet();
}

class OutletRepository implements OutletRepositoryProtocol {
  @override
  Future<void> remove() async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: StoreKey.outlet.toString());
  }

  @override
  Future<Outlet?> retrievOutlet() async {
    const storage = FlutterSecureStorage();
    String? outletString = await storage.read(key: StoreKey.outlet.toString());
    if (outletString != null) {
      final jsonOutlet = json.decode(outletString);
      return Outlet.fromJson(jsonOutlet);
    }
    return null;
  }

  @override
  Future<void> saveOutlet(Outlet outlet) async {
    const storage = FlutterSecureStorage();
    await storage.write(
        key: StoreKey.outlet.toString(), value: outlet.toString());
  }
}
