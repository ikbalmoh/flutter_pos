import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/data/models/item_variant.dart';
import 'package:selleri/data/objectbox.dart';
import 'package:selleri/objectbox.g.dart';
import 'package:selleri/utils/fetch.dart';
import 'package:selleri/config/api_url.dart';
import 'package:selleri/data/models/item.dart';

class ItemApi {
  final Dio api;

  ItemApi({required this.api});

  Future categories(String idOulet) async {
    Map<String, dynamic> query = {'is_app': 1, 'id_outlet': idOulet};
    final res = await api.get(ApiUrl.listCategory, queryParameters: query);
    return res.data;
  }

  Future items(String idOutlet,
      {String? idCategory, int? lastUpdate, bool? fullSync}) async {
    Map<String, dynamic> query = {
      'is_app': 1,
      'id_outlet': idOutlet,
      'last_update': lastUpdate,
    };
    if (fullSync == true) {
      query['full_sync'] = true;
    }
    if (idCategory != null) {
      query['id_category'] = idCategory;
    }
    final res = await api.get(ApiUrl.listItems, queryParameters: query);
    return res.data;
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

        v['id_item'] = v['item_id'];
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
}

final itemApiProvider = Provider<ItemApi>((ref) {
  final api = ref.watch(apiProvider);
  return ItemApi(api: api);
});
