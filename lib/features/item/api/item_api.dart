import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/features/item/model/item_suggestion.dart';
import 'package:selleri/features/item/model/item_variant.dart';
import 'package:selleri/shared/model/pagination.dart';
import 'package:selleri/shared/objectbox.dart';
import 'package:selleri/objectbox.g.dart';
import 'package:selleri/shared/utils/fetch.dart';
import 'package:selleri/shared/router/api_url.dart';
import 'package:selleri/features/item/model/item.dart';

class ItemApi {
  final Dio api;

  ItemApi({required this.api});

  Future categories(String idOulet) async {
    Map<String, dynamic> query = {'is_app': 1, 'id_outlet': idOulet};
    final res = await api.get(ApiUrl.listCategory, queryParameters: query);
    return res.data;
  }

  Future<Pagination<Item>> items(
    String idOutlet, {
    String? idCategory,
    int? lastUpdate,
    bool? fullSync,
    int? page,
  }) async {
    Map<String, dynamic> query = {
      'is_app': 1,
      'id_outlet': idOutlet,
    };
    if (lastUpdate != null) {
      query['last_update'] = lastUpdate;
    }
    if (idCategory != null) {
      query['id_category'] = idCategory;
    }
    if (fullSync == true) {
      query['page'] = page ?? 1;
      query['full_sync'] = true;
      query['per_page'] = 100;
    }
    final res = await api.get(ApiUrl.listItems, queryParameters: query);
    log('LOADED ITEMS: ${res.data['data']}');
    if (fullSync != true) {
      List<Item> items = res.data['data'] != null
          ? List<Map<String, dynamic>>.from(res.data['data'])
              .map((json) => Item.fromJsonData(json))
              .toList()
          : [];
      return Pagination<Item>(
        data: items,
        currentPage: 1,
        lastPage: 1,
        total: items.length,
      );
    }
    if (res.data['data'] != null && res.data['data']['data'] != null) {
      final pagination = Pagination<Item>.fromJson(res.data['data'], (item) {
        return Item.fromJsonData(item as Map<String, dynamic>);
      });
      return pagination;
    }
    throw Exception('Failed to load items');
  }

  Future<Item> storeItem(Map<String, dynamic> item) async {
    try {
      item['is_active'] = 1;
      item['is_all_outlet'] = 1;
      item['is_all_supplier'] = 1;
      item['outlet_ids'] = [];
      final res = await api.post(ApiUrl.items, data: item);
      return Item.fromJsonData(res.data['data']);
    } on DioException catch (e) {
      throw e.message!;
    } catch (e) {
      rethrow;
    }
  }

  Future storeItemAttributes(
      String idItem, List<Map<String, dynamic>> attributes) async {
    try {
      Map<String, dynamic> payload = {'attributes': attributes};
      final res =
          await api.post('${ApiUrl.items}/$idItem/attributes', data: payload);
      return res.data;
    } on DioException catch (e) {
      throw e.message!;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ItemVariant>> updateItemVariants(
      String idItem, List<Map<String, dynamic>> variants) async {
    try {
      Map<String, dynamic> payload = {'variants': variants};
      final res =
          await api.put('${ApiUrl.items}/$idItem/variants', data: payload);
      List<Map<String, dynamic>> listJson =
          List<Map<String, dynamic>>.from(res.data['data']);
      List<ItemVariant> listVariant = listJson.map((v) {
        ItemVariant? existVariant = objectBox.itemVariantBox
            .query(ItemVariant_.idVariant.equals(v['id_variant']))
            .build()
            .findFirst();

        v['id_item'] = idItem;
        v['id'] = existVariant?.id ?? 0;
        v['variant_name'] = existVariant?.variantName ?? '';
        v['stock_item'] = existVariant?.stockItem ?? 0;
        return ItemVariant.fromJson(v);
      }).toList();
      return listVariant;
    } on DioException catch (e) {
      throw e.message!;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ItemSuggestion>> extraItemSuggestions(String q) async {
    if (q.length < 3) {
      return [];
    }
    Map<String, dynamic> query = {'q': q};
    final res = await api.get(ApiUrl.listExtraItems, queryParameters: query);
    List<Map<String, dynamic>> listJson =
        List<Map<String, dynamic>>.from(res.data['data']);
    List<ItemSuggestion> listSuggestion = listJson.map((v) {
      return ItemSuggestion.fromJson(v);
    }).toList();
    return listSuggestion;
  }
}

final itemApiProvider = Provider<ItemApi>((ref) {
  final api = ref.watch(apiProvider);
  return ItemApi(api: api);
});
