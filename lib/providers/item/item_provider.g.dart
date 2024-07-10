// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$itemsStreamHash() => r'590b8169e24787b7dff6d08ef315c692b684b639';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$ItemsStream extends BuildlessStreamNotifier<List<Item>> {
  late final String idCategory;
  late final String search;

  Stream<List<Item>> build({
    String idCategory = '',
    String search = '',
  });
}

/// See also [ItemsStream].
@ProviderFor(ItemsStream)
const itemsStreamProvider = ItemsStreamFamily();

/// See also [ItemsStream].
class ItemsStreamFamily extends Family<AsyncValue<List<Item>>> {
  /// See also [ItemsStream].
  const ItemsStreamFamily();

  /// See also [ItemsStream].
  ItemsStreamProvider call({
    String idCategory = '',
    String search = '',
  }) {
    return ItemsStreamProvider(
      idCategory: idCategory,
      search: search,
    );
  }

  @override
  ItemsStreamProvider getProviderOverride(
    covariant ItemsStreamProvider provider,
  ) {
    return call(
      idCategory: provider.idCategory,
      search: provider.search,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'itemsStreamProvider';
}

/// See also [ItemsStream].
class ItemsStreamProvider
    extends StreamNotifierProviderImpl<ItemsStream, List<Item>> {
  /// See also [ItemsStream].
  ItemsStreamProvider({
    String idCategory = '',
    String search = '',
  }) : this._internal(
          () => ItemsStream()
            ..idCategory = idCategory
            ..search = search,
          from: itemsStreamProvider,
          name: r'itemsStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$itemsStreamHash,
          dependencies: ItemsStreamFamily._dependencies,
          allTransitiveDependencies:
              ItemsStreamFamily._allTransitiveDependencies,
          idCategory: idCategory,
          search: search,
        );

  ItemsStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.idCategory,
    required this.search,
  }) : super.internal();

  final String idCategory;
  final String search;

  @override
  Stream<List<Item>> runNotifierBuild(
    covariant ItemsStream notifier,
  ) {
    return notifier.build(
      idCategory: idCategory,
      search: search,
    );
  }

  @override
  Override overrideWith(ItemsStream Function() create) {
    return ProviderOverride(
      origin: this,
      override: ItemsStreamProvider._internal(
        () => create()
          ..idCategory = idCategory
          ..search = search,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        idCategory: idCategory,
        search: search,
      ),
    );
  }

  @override
  StreamNotifierProviderElement<ItemsStream, List<Item>> createElement() {
    return _ItemsStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ItemsStreamProvider &&
        other.idCategory == idCategory &&
        other.search == search;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, idCategory.hashCode);
    hash = _SystemHash.combine(hash, search.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ItemsStreamRef on StreamNotifierProviderRef<List<Item>> {
  /// The parameter `idCategory` of this provider.
  String get idCategory;

  /// The parameter `search` of this provider.
  String get search;
}

class _ItemsStreamProviderElement
    extends StreamNotifierProviderElement<ItemsStream, List<Item>>
    with ItemsStreamRef {
  _ItemsStreamProviderElement(super.provider);

  @override
  String get idCategory => (origin as ItemsStreamProvider).idCategory;
  @override
  String get search => (origin as ItemsStreamProvider).search;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
