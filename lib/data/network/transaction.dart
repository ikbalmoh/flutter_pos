import 'package:dio/dio.dart';
import 'package:selleri/data/models/cart.dart';
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
}
