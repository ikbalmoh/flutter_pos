import 'package:dio/dio.dart';
import 'package:selleri/config/api_url.dart';
import 'package:selleri/data/models/item_adjustment.dart';
import 'package:selleri/data/models/pagination.dart';
import 'package:selleri/utils/fetch.dart';

class AdjustmentApi {
  final api = fetch();

  Future<Pagination<ItemAdjustment>> itemsForAdjustment(
      {int page = 1, String date = '', String search = ''}) async {
    final Map<String, dynamic> queryParameters = {
      'page': page,
      'q': search,
      'date': date
    };
    try {
      final res = await api.get(ApiUrl.listItemsForAdjustment,
          queryParameters: queryParameters);
      final data = res.data['data'];
      final pagination = Pagination<ItemAdjustment>.fromJson(data, (customer) {
        return ItemAdjustment.fromJson(customer as Map<String, dynamic>);
      });
      return pagination;
    } on DioException catch (e) {
      throw Exception(e.response?.data['msg'] ?? e.message);
    } catch (e) {
      throw Exception(e);
    }
  }
}
