import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/data/models/customer.dart';
import 'package:selleri/data/models/pagination.dart';
import 'package:selleri/data/network/customer.dart';

part 'customer_list_provider.g.dart';

@Riverpod(keepAlive: true)
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
}
