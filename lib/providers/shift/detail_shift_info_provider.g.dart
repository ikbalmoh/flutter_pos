// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detail_shift_info_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$detailShiftInfoNotifierHash() =>
    r'beb43b37b8f16ba16ec25e547d14a1fe48565cbf';

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

abstract class _$DetailShiftInfoNotifier
    extends BuildlessAutoDisposeAsyncNotifier<ShiftInfo?> {
  late final String shiftId;

  FutureOr<ShiftInfo?> build(
    String shiftId,
  );
}

/// See also [DetailShiftInfoNotifier].
@ProviderFor(DetailShiftInfoNotifier)
const detailShiftInfoNotifierProvider = DetailShiftInfoNotifierFamily();

/// See also [DetailShiftInfoNotifier].
class DetailShiftInfoNotifierFamily extends Family<AsyncValue<ShiftInfo?>> {
  /// See also [DetailShiftInfoNotifier].
  const DetailShiftInfoNotifierFamily();

  /// See also [DetailShiftInfoNotifier].
  DetailShiftInfoNotifierProvider call(
    String shiftId,
  ) {
    return DetailShiftInfoNotifierProvider(
      shiftId,
    );
  }

  @override
  DetailShiftInfoNotifierProvider getProviderOverride(
    covariant DetailShiftInfoNotifierProvider provider,
  ) {
    return call(
      provider.shiftId,
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
  String? get name => r'detailShiftInfoNotifierProvider';
}

/// See also [DetailShiftInfoNotifier].
class DetailShiftInfoNotifierProvider
    extends AutoDisposeAsyncNotifierProviderImpl<DetailShiftInfoNotifier,
        ShiftInfo?> {
  /// See also [DetailShiftInfoNotifier].
  DetailShiftInfoNotifierProvider(
    String shiftId,
  ) : this._internal(
          () => DetailShiftInfoNotifier()..shiftId = shiftId,
          from: detailShiftInfoNotifierProvider,
          name: r'detailShiftInfoNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$detailShiftInfoNotifierHash,
          dependencies: DetailShiftInfoNotifierFamily._dependencies,
          allTransitiveDependencies:
              DetailShiftInfoNotifierFamily._allTransitiveDependencies,
          shiftId: shiftId,
        );

  DetailShiftInfoNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.shiftId,
  }) : super.internal();

  final String shiftId;

  @override
  FutureOr<ShiftInfo?> runNotifierBuild(
    covariant DetailShiftInfoNotifier notifier,
  ) {
    return notifier.build(
      shiftId,
    );
  }

  @override
  Override overrideWith(DetailShiftInfoNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: DetailShiftInfoNotifierProvider._internal(
        () => create()..shiftId = shiftId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        shiftId: shiftId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<DetailShiftInfoNotifier, ShiftInfo?>
      createElement() {
    return _DetailShiftInfoNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DetailShiftInfoNotifierProvider && other.shiftId == shiftId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, shiftId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin DetailShiftInfoNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<ShiftInfo?> {
  /// The parameter `shiftId` of this provider.
  String get shiftId;
}

class _DetailShiftInfoNotifierProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<DetailShiftInfoNotifier,
        ShiftInfo?> with DetailShiftInfoNotifierRef {
  _DetailShiftInfoNotifierProviderElement(super.provider);

  @override
  String get shiftId => (origin as DetailShiftInfoNotifierProvider).shiftId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
