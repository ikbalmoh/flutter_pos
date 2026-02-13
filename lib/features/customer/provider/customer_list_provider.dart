// ignore_for_file: avoid_manual_providers_as_generated_provider_dependency
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/features/customer/model/customer.dart';
import 'package:selleri/shared/model/pagination.dart';
import 'package:selleri/features/customer/api/customer_api.dart';
import 'dart:developer';

import 'package:selleri/features/cart/provider/cart_provider.dart';

part 'customer_list_provider.g.dart';

@Riverpod(keepAlive: true)
class CustomerList extends _$CustomerList {
  @override
  FutureOr<Pagination<Customer>> build() async {
    final api = ref.watch(customerApiProvider);
    try {
      final name = ref.read(cartProvider).customerName;
      final customers = await api.customers(page: 1, search: name ?? '');
      return customers;
    } on Exception catch (e) {
      log('CUSTOMERS ERROR: $e');
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

  Future<void> loadCustomers({int page = 1, String search = ''}) async {
    if (page == 1) {
      state = const AsyncLoading();
    } else {
      state = AsyncData(state.value!.copyWith(loading: true));
    }
    final api = ref.watch(customerApiProvider);
    try {
      var customers = await api.customers(page: page, search: search);
      List<Customer> data = state.hasValue
          ? List.from(state.value?.data as Iterable<Customer>)
          : [];
      if (page > 1) {
        data = data..addAll(customers.data as Iterable<Customer>);
        customers = customers.copyWith(data: data, loading: false);
      }
      state = AsyncData(customers);
    } catch (e, trace) {
      log('Load Customer Error: $e');
      if (state is AsyncLoading) {
        state = AsyncError(e, trace);
      }
    }
  }

  Future<void> submitNewCustomer(Map<String, dynamic> payload) async {
    final api = ref.watch(customerApiProvider);
    try {
      final Customer customer = await api.storeCustomer(payload);
      ref.read(cartProvider.notifier).selectCustomer(customer);
      loadCustomers(page: 1, search: customer.customerName);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateCustomer(String id,
      {required Map<String, dynamic> payload}) async {
    final api = ref.watch(customerApiProvider);
    try {
      final Customer customer = await api.updateCustomer(id, payload);
      ref.read(cartProvider.notifier).selectCustomer(customer);
      loadCustomers(page: 1, search: customer.customerName);
    } catch (e) {
      rethrow;
    }
  }
}
