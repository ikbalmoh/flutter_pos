import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/features/elastic/repository/elastic_repository.dart';
import 'package:selleri/features/item/model/category.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/features/item/model/item.dart';
import 'package:selleri/features/item/model/item_adjustment.dart';
import 'package:selleri/shared/constants/store_key.dart';
import 'package:selleri/shared/model/pagination.dart';
import 'package:selleri/features/adjustment/api/adjustment_api.dart';
import 'package:selleri/features/item/api/item_api.dart';
import 'package:selleri/shared/objectbox.dart';
import 'package:selleri/features/outlet/repository/outlet_repository.dart';
import 'package:selleri/shared/utils/exception.dart';

part 'item_repository.g.dart';

@riverpod
ItemRepository itemRepository(Ref ref) => ItemRepository(ref);

abstract class ItemRepositoryProtocol {
  Future<List<Category>> fetchCategoris();
  Future<List<Item>> fetchItems({String? idCategory, bool? fromLastSync});
  Future<List<Item>> fetchElasticItems({
    String? idCategory,
    bool? fromLastSync,
  });
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
  final storage = FlutterSecureStorage();

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
  Future<List<Item>> fetchItems({
    String? idCategory,
    bool? fromLastSync,
    bool? fullSync = false,
    List<Item> prevItems = const [],
    int? page,
    Function(int current, int total)? onProgress,
  }) async {
    int? lastUpdate;
    if (fromLastSync == true) {
      String? lastSync = await storage.read(key: StoreKey.lastSync.name);
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
      List<Item> items = List.from(prevItems);
      final Pagination<Item> data = await api.items(
        outlet.idOutlet,
        idCategory: idCategory,
        lastUpdate: lastUpdate,
        fullSync: fullSync,
        page: page,
      );
      if (data.data != null && data.data!.isNotEmpty) {
        items.addAll(data.data!.toList());
      }
      if (onProgress != null) {
        onProgress(data.currentPage, data.lastPage);
      }
      if (data.currentPage < data.lastPage) {
        return fetchItems(
          idCategory: idCategory,
          fromLastSync: fromLastSync,
          fullSync: fullSync,
          prevItems: items,
          page: data.currentPage + 1,
          onProgress: onProgress,
        );
      }
      storage.write(
        key: StoreKey.lastSync.name,
        value: DateTime.now().toLocal().millisecondsSinceEpoch.toString(),
      );
      return items;
    } on DioException catch (e, st) {
      log('fetchItems Error: ${e.response?.data} $st');
      throw e.message!;
    } on PlatformException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      rethrow;
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

  @override
  Future<List<Item>> fetchElasticItems({
    String? idCategory,
    bool? fromLastSync,
    bool? fullSync,
    int? page = 0,
    Function(int current, int total)? onProgress,
  }) async {
    try {
      int? lastUpdate;
      if (fromLastSync == true) {
        String? lastSync = await storage.read(key: StoreKey.lastSync.name);
        lastUpdate = lastSync != null
            ? int.parse(lastSync)
            : DateTime.now().microsecondsSinceEpoch;
      }

      const int pageSize = 200;
      final esRepo = ref.read(elasticRepositoryProvider);

      // First page — also gives us the total count.
      final firstRes = await esRepo.items(
        idCategory: idCategory,
        lastUpdate: lastUpdate,
        from: 0,
        size: pageSize,
      );

      final int total = firstRes.hits.total.value;
      final List<Item> allItems = firstRes.hits.sources(Item.fromJsonData);

      log('ES: Got ${allItems.length}/$total items (page 1)');
      onProgress?.call(allItems.length, total);

      if (allItems.length >= total) {
        return allItems;
      }

      // Fetch remaining pages sequentially so progress is granular.
      final int extraPages = ((total - pageSize) / pageSize).ceil();
      for (int i = 0; i < extraPages; i++) {
        final res = await esRepo.items(
          idCategory: idCategory,
          lastUpdate: lastUpdate,
          from: (i + 1) * pageSize,
          size: pageSize,
        );
        allItems.addAll(res.hits.sources(Item.fromJsonData));
        onProgress?.call(allItems.length, total);
        log('ES: Got ${allItems.length}/$total items (page ${i + 2})');
      }

      log('ES: Fetched all ${allItems.length}/$total items');

      storage.write(
        key: StoreKey.lastSync.name,
        value: DateTime.now().millisecondsSinceEpoch.toString(),
      );

      return allItems;
    } catch (e, trace) {
      log('Fetch elastic items Error: $e => $trace');
      FirebaseCrashlytics.instance.recordError(
        e is NotFoundException ? 'Elasticsearch index not available' : 'Elasticsearch error',
        trace,
        information: [e.toString()],
        fatal: false,
      );
      // Fallback when the index existence check throws (index not found).
      if (e is NotFoundException) {
        return fetchItems(
          idCategory: idCategory,
          fromLastSync: fromLastSync,
          fullSync: fullSync,
          prevItems: [],
          page: 0,
          onProgress: onProgress,
        );
      }
      rethrow;
    }
  }
}
