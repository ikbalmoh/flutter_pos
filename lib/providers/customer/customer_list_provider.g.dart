// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$customerListNotifierHash() =>
    r'e9bfe3f83d442c552a270fcaeac08ac8676993cc';

/// See also [CustomerListNotifier].
@ProviderFor(CustomerListNotifier)
final customerListNotifierProvider = AutoDisposeAsyncNotifierProvider<
    CustomerListNotifier, Pagination<Customer>>.internal(
  CustomerListNotifier.new,
  name: r'customerListNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$customerListNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CustomerListNotifier = AutoDisposeAsyncNotifier<Pagination<Customer>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
