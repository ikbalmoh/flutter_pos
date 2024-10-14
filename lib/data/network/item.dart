import 'package:dio/dio.dart';
import 'package:selleri/utils/fetch.dart';
import 'package:selleri/config/api_url.dart';
import 'package:selleri/data/models/item.dart';

class ItemApi {
  final api = fetch();

  Future categories(String idOulet) async {
    Map<String, dynamic> query = {'is_app': 1, 'id_outlet': idOulet};
    final res = await api.get(ApiUrl.listCategory, queryParameters: query);
    return res.data;
  }

  Future items(String idOutlet, {String? idCategory, int? lastUpdate}) async {
    Map<String, dynamic> query = {
      'is_app': 1,
      'id_outlet': idOutlet,
      'last_update': lastUpdate,
    };
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
      return Item.fromJson(res.data['data']);
    } on DioException catch (e) {
      throw e.response?.data['msg'] ?? e.message;
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
      throw e.response?.data['msg'] ?? e.message;
    } catch (e) {
      rethrow;
    }
  }

  Future updateItemVariants(
      String idItem, List<Map<String, dynamic>> variants) async {
    try {
      Map<String, dynamic> payload = {'variants': variants};
      final res =
          await api.put('${ApiUrl.items}/$idItem/variants', data: payload);
      return res.data;
    } on DioException catch (e) {
      throw e.response?.data['msg'] ?? e.message;
    } catch (e) {
      rethrow;
    }
  }
}
