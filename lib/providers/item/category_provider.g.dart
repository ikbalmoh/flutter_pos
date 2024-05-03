// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$categoriesStreamHash() => r'3f0822fd9a9f361e0853ed8cc04900e18e995243';

/// See also [CategoriesStream].
@ProviderFor(CategoriesStream)
final categoriesStreamProvider =
    StreamNotifierProvider<CategoriesStream, List<Category>>.internal(
  CategoriesStream.new,
  name: r'categoriesStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$categoriesStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CategoriesStream = StreamNotifier<List<Category>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
