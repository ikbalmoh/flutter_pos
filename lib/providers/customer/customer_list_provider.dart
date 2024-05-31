import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/data/models/customer.dart';
import 'package:selleri/data/models/pagination.dart';
import 'package:selleri/data/network/customer.dart';

part 'customer_list_provider.g.dart';

@riverpod
class CustomerListNotifier extends _$CustomerListNotifier {
  @override
  FutureOr<Pagination<Customer>> build() async {
    final api = CustomerApi();
    try {
      final customers = await api.customers();
      return customers;
    } on Exception catch (e) {
      if (kDebugMode) {
        print('CUSTOMERS ERROR: $e');
      }
    }
    return const Pagination<Customer>(
      currentPage: 0,
      lastPage: 0,
      total: 0,
      from: 0,
      to: 0,
      data: [],
    );
  }

  void loadCustomers({int page = 1}) async {
    state = AsyncData(state.value!.copyWith(loading: true));
    final api = CustomerApi();
    try {
      var customers = await api.customers(page: page);
      List<Customer> data = List.from(state.value?.data as Iterable<Customer>);
      if (page > 1) {
        data = data..addAll(customers.data as Iterable<Customer>);
        customers = customers.copyWith(data: data, loading: false);
      }
      state = AsyncData(customers);
    } catch (e) {
      print('Load Customer Error: $e');
    }
  }
}
