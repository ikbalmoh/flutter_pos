import 'package:dio/dio.dart';
import 'package:selleri/data/models/cart.dart';
import 'package:selleri/data/models/cart_holded.dart';
import 'package:selleri/data/models/pagination.dart';
import 'package:selleri/utils/fetch.dart';
import 'package:selleri/config/api_url.dart';

class TransactionApi {
  final api = fetch();

  Future<List<dynamic>> storeTransaction(Cart cart) async {
    try {
      final json = cart.toTransactionPayload();
      final List<Map<String, dynamic>> data = [json];
      final res = await api.post(ApiUrl.transaction, data: data);

      return res.data['data'];
    } on DioException catch (e) {
      throw Exception(e.response?.data['msg'] ?? e.message);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Pagination<CartHolded>> holdedTransactions(
      {required String idOutlet, int? page, String? q}) async {
    try {
      final Map<String, dynamic> params = {
        'id_outlet': idOutlet,
        'q': q,
        'page': page
      };
      final res = await api.get(ApiUrl.hold, queryParameters: params);
      final data = res.data['data'];
      final pagination = Pagination<CartHolded>.fromJson(data, (holded) {
        return CartHolded.fromJson(holded as Map<String, dynamic>);
      });

      return pagination;
    } on DioException catch (e) {
      throw Exception(e.response?.data['msg'] ?? e.message);
    } catch (e) {
      rethrow;
    }
  }

  Future holdTransaction(Cart cart) async {
    try {
      final json = cart.toJson();
      final List<Map<String, dynamic>> data = [json];
      final res = await api.post(ApiUrl.hold, data: data);

      return res.data['data'];
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    } catch (e) {
      throw Exception(e);
    }
  }
}
