import 'package:dio/dio.dart';
import 'package:selleri/config/api_url.dart';
import 'package:selleri/data/models/adjustment.dart';
import 'package:selleri/data/models/item_adjustment.dart';
import 'package:selleri/data/models/pagination.dart';
import 'package:selleri/data/models/adjustment_history.dart' as model;
import 'package:selleri/utils/fetch.dart';
import 'package:selleri/utils/formater.dart';

class AdjustmentApi {
  final api = fetch();

  Future<Pagination<model.AdjustmentHistory>> adjustmentHistory(
      {int page = 1, String? search = ''}) async {
    try {
      final Map<String, dynamic> queryParameters = {
        'page': page,
        'q': search,
      };
      final res =
          await api.get(ApiUrl.adjustment, queryParameters: queryParameters);
      final data = res.data['data'];
      final pagination =
          Pagination<model.AdjustmentHistory>.fromJson(data, (item) {
        return model.AdjustmentHistory.fromJson(item as Map<String, dynamic>);
      });
      return pagination;
    } on DioException catch (e) {
      throw Exception(e.response?.data['msg'] ?? e.message);
    } catch (e) {
      rethrow;
    }
  }

  Future<Pagination<ItemAdjustment>> itemsForAdjustment({
    required String idOutlet,
    int page = 1,
    DateTime? date,
    String? idCategory,
    String? search,
  }) async {
    final Map<String, dynamic> queryParameters = {
      'page': page,
      'id_outlet': idOutlet,
      'per_page': 30,
      'q': search ?? '',
      'id_category': idCategory ?? '',
      'date': DateTimeFormater.dateToString(date ?? DateTime.now(),
          format: 'y-MM-dd')
    };
    try {
      final res = await api.get(ApiUrl.listItemsForAdjustment,
          queryParameters: queryParameters);
      final data = res.data['data'];
      final pagination = Pagination<ItemAdjustment>.fromJson(data, (item) {
        return ItemAdjustment.fromJson(item as Map<String, dynamic>);
      });
      return pagination;
    } on DioException catch (e) {
      throw Exception(e.response?.data['msg'] ?? e.message);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ItemAdjustment>> fastMovingItems(
      {required String idOutlet}) async {
    try {
      final params = {"id_outlet": idOutlet};
      final res = await api.get(ApiUrl.fastMovingItems, data: params);
      List<Map<String, dynamic>> listJson = List.from(res.data['data']);
      final List<ItemAdjustment> data =
          listJson.map((json) => ItemAdjustment.fromJson(json)).toList();
      return data;
    } on DioException catch (e) {
      throw Exception(e.response?.data['msg'] ?? e.message);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ItemAdjustment>> adjustmentDetailItems(
      {required String id}) async {
    try {
      final params = {"per_page": 0};
      final res = await api
          .get(ApiUrl.adjustmentDetails.replaceFirst('{id}', id), data: params);
      List<Map<String, dynamic>> listJson = List.from(res.data['data']);
      final List<ItemAdjustment> data =
          listJson.map((json) => ItemAdjustment.fromDetail(json)).toList();
      return data;
    } on DioException catch (e) {
      throw Exception(e.response?.data['msg'] ?? e.message);
    } catch (e) {
      rethrow;
    }
  }

  Future<String> createAdjustment(String idOutlet, Adjustment data) async {
    try {
      final payload = {
        'adjustment_date':
            DateTimeFormater.dateToString(data.date, format: 'y-MM-dd'),
        'locationable_id': idOutlet,
        'location_type': 'outlet',
        'description': data.description,
        'details': data.items.map((item) {
          return {
            'note': item.note,
            'id_item': item.idItem,
            'variant_id': item.variantId,
            'qty_actual': item.qtyActual,
          };
        }).toList()
      };
      final res = await api.post(ApiUrl.adjustment, data: payload);
      return res.data['msg'];
    } on DioException catch (e) {
      throw Exception(e.response?.data['msg'] ?? e.message);
    } catch (e) {
      rethrow;
    }
  }
}
