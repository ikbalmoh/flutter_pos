import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/features/item/model/category.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/features/item/model/item.dart';
import 'package:selleri/features/item/model/item_adjustment.dart';
import 'package:selleri/shared/model/pagination.dart';
import 'package:selleri/features/adjustment/api/adjustment_api.dart';
import 'package:selleri/features/item/api/item_api.dart';
import 'package:selleri/shared/objectbox.dart';
import 'package:selleri/features/outlet/repository/outlet_repository.dart';

part 'item_repository.g.dart';

String syncKey = 'LAST_UPDATE/ITEMS';

@riverpod
ItemRepository itemRepository(Ref ref) => ItemRepository(ref);

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
  Future<List<Item>> fetchItems({
    String? idCategory,
    bool? fromLastSync,
    bool? fullSync = false,
    List<Item> prevItems = const [],
    int? page,
    Function(int current, int total)? onProgress,
  }) async {
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
      return items;
    } on DioException catch (e, st) {
      log('fetchItems Error: ${e.response?.data} $st');
      throw e.message!;
    } on PlatformException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      rethrow;
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
