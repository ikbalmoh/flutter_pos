// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$customerListNotifierHash() =>
    r'fcd1e16021ec7aa8a1f87c8395d0cef0269f3dbf';

/// See also [CustomerListNotifier].
@ProviderFor(CustomerListNotifier)
final customerListNotifierProvider =
    AsyncNotifierProvider<CustomerListNotifier, Pagination<Customer>>.internal(
  CustomerListNotifier.new,
  name: r'customerListNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$customerListNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CustomerListNotifier = AsyncNotifier<Pagination<Customer>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
