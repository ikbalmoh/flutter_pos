import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/data/models/category.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/data/models/item.dart';
import 'package:selleri/data/models/item_adjustment.dart';
import 'package:selleri/data/models/pagination.dart';
import 'package:selleri/data/network/adjustment.dart';
import 'package:selleri/data/network/item.dart';
import 'package:selleri/data/objectbox.dart';
import 'package:selleri/data/repository/outlet_repository.dart';

part 'item_repository.g.dart';

String syncKey = 'LAST_UPDATE/ITEMS';

@riverpod
ItemRepository itemRepository(ItemRepositoryRef ref) => ItemRepository(ref);

abstract class ItemRepositoryProtocol {
  Future<List<Category>> fetchCategoris();
  Future<List<Item>> fetchItems({String? idCategory, bool? fromLastSync});
  Future<Pagination<ItemAdjustment>> fetchAdjustmnetItems({
    int page = 1,
    DateTime? date,
    String? search,
    String? idCategory,
  });
}

class ItemRepository implements ItemRepositoryProtocol {
  ItemRepository(this.ref);

  final Ref ref;

  late final outletState = ref.read(outletRepositoryProvider);

  @override
  Future<List<Category>> fetchCategoris() async {
    try {
      final api = ref.watch(itemApiProvider);
      final outlet = await outletState.retrieveOutlet();
      if (outlet == null) {
        return [];
      }
      final data = await api.categories(outlet.idOutlet);
      final List<Category> categories = [];
      for (var i = 0; i < List.from(data['data']).length; i++) {
        var json = data['data'][i];
        try {
          final category = Category.fromJson(json);
          categories.add(category);
        } on Error catch (e, stackTrace) {
          log('LOAD CATEGORY ERROR: $json\n=> $e\n=> $stackTrace');
        }
      }
      objectBox.putCategories(categories);
      return categories;
    } on DioException catch (e) {
      throw e.message!;
    } on PlatformException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<List<Item>> fetchItems(
      {String? idCategory, bool? fromLastSync, bool? fullSync = false}) async {
    const storage = FlutterSecureStorage();

    int? lastUpdate;
    if (fromLastSync == true) {
      String? lastSync = await storage.read(key: syncKey);
      DateTime syncDateTime = lastSync != null
          ? DateTime.fromMillisecondsSinceEpoch(int.parse(lastSync))
          : DateTime.now();
      lastUpdate = (syncDateTime
                  .subtract(const Duration(hours: 1))
                  .millisecondsSinceEpoch /
              1000)
          .floor();
    }

    try {
      final api = ref.watch(itemApiProvider);
      final outlet = await outletState.retrieveOutlet();
      if (outlet == null) {
        return [];
      }
      final data = await api.items(outlet.idOutlet,
          idCategory: idCategory, lastUpdate: lastUpdate, fullSync: fullSync);
      List<Item> items = [];
      for (var i = 0; i < List.from(data['data']).length; i++) {
        var json = data['data'][i];
        try {
          final item = Item.fromJson(json);
          items.add(item);
        } on Error catch (e, stackTrace) {
          if (kDebugMode) {
            log('LOAD ITEM ERROR: $json\n=> $e\n=> $stackTrace');
          } else {
            rethrow;
          }
        }
      }
      return items;
    } on DioException catch (e) {
      throw e.message!;
    } on PlatformException catch (e) {
      throw Exception(e.message);
    } finally {
      storage.write(
        key: syncKey,
        value: DateTime.now().millisecondsSinceEpoch.toString(),
      );
    }
  }

  @override
  Future<Pagination<ItemAdjustment>> fetchAdjustmnetItems({
    int page = 1,
    DateTime? date,
    String? search,
    String? idCategory,
  }) async {
    late final outletState = ref.read(outletRepositoryProvider);

    final outlet = await outletState.retrieveOutlet();

    final api = ref.watch(adjustmentApiProvider);
    try {
      var items = await api.itemsForAdjustment(
        idOutlet: outlet!.idOutlet,
        page: page,
        date: date,
        search: search,
        idCategory: idCategory,
      );
      return items;
    } catch (e, trace) {
      log('Fetch items adjustments Error: $e => $trace');
      rethrow;
    }
  }
}
