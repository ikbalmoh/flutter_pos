import 'package:dio/dio.dart';
import 'package:selleri/config/api_url.dart';
import 'package:selleri/data/models/item_adjustment.dart';
import 'package:selleri/data/models/pagination.dart';
import 'package:selleri/utils/fetch.dart';
import 'package:selleri/utils/formater.dart';

class AdjustmentApi {
  final api = fetch();

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
      'q': search,
      'id_category': idCategory,
      'date': date != null
          ? DateTimeFormater.dateToString(date, format: 'y-MM-dd')
          : ''
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
}
