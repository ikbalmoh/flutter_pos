import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/data/models/customer.dart';
import 'package:selleri/data/models/pagination.dart';
import 'package:selleri/utils/fetch.dart';
import 'package:selleri/config/api_url.dart';

class CustomerApi {
  final Dio api;

  CustomerApi({required this.api});

  Future<Pagination<Customer>> customers(
      {int page = 1, String search = ''}) async {
    final Map<String, dynamic> queryParameters = {'page': page, 'q': search};
    try {
      final res =
          await api.get(ApiUrl.customers, queryParameters: queryParameters);
      final data = res.data['data'];
      final pagination = Pagination<Customer>.fromJson(data, (customer) {
        return Customer.fromJson(customer as Map<String, dynamic>);
      });
      return pagination;
    } on DioException catch (e) {
      throw e.message!;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Customer> storeCustomer(Map<String, dynamic> payload) async {
    try {
      final res = await api.post(ApiUrl.customers, data: payload);
      final data = res.data['data'];
      return Customer.fromJson(data);
    } on DioException catch (e) {
      throw e.message!;
    } catch (e) {
      throw Exception(e);
    }
  }
}

final customerApiProvider = Provider<CustomerApi>((ref) {
  final api = ref.watch(apiProvider);
  return CustomerApi(api: api);
});
