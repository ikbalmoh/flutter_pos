import 'package:dio/dio.dart';
import 'package:selleri/data/models/customer.dart';
import 'package:selleri/data/models/pagination.dart';
import 'package:selleri/utils/fetch.dart';
import 'package:selleri/config/api_url.dart';

class CustomerApi {
  final api = fetch();

  Future<Pagination<Customer>> customers(
      {int page = 1, String search = ''}) async {
    final Map<String, dynamic> queryParameters = {
      'page': page,
      'q': search
    };
    try {
      final res =
          await api.get(ApiUrl.customers, queryParameters: queryParameters);
      final data = res.data['data'];
      final pagination = Pagination<Customer>.fromJson(data, (customer) {
        return Customer.fromJson(customer as Map<String, dynamic>);
      });
      return pagination;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    } catch (e) {
      throw Exception(e);
    }
  }
}
