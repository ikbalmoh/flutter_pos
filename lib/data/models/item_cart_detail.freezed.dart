// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'item_cart_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ItemCartDetail _$ItemCartDetailFromJson(Map<String, dynamic> json) {
  return _ItemCartDetail.fromJson(json);
}

/// @nodoc
mixin _$ItemCartDetail {
  String get itemId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int? get variantId => throw _privateConstructorUsedError;
  int? get quantity => throw _privateConstructorUsedError;
  @JsonKey(fromJson: Converters.dynamicToDouble)
  double get itemPrice => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ItemCartDetailCopyWith<ItemCartDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ItemCartDetailCopyWith<$Res> {
  factory $ItemCartDetailCopyWith(
          ItemCartDetail value, $Res Function(ItemCartDetail) then) =
      _$ItemCartDetailCopyWithImpl<$Res, ItemCartDetail>;
  @useResult
  $Res call(
      {String itemId,
      String name,
      int? variantId,
      int? quantity,
      @JsonKey(fromJson: Converters.dynamicToDouble) double itemPrice});
}

/// @nodoc
class _$ItemCartDetailCopyWithImpl<$Res, $Val extends ItemCartDetail>
    implements $ItemCartDetailCopyWith<$Res> {
  _$ItemCartDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? itemId = null,
    Object? name = null,
    Object? variantId = freezed,
    Object? quantity = freezed,
    Object? itemPrice = null,
  }) {
    return _then(_value.copyWith(
      itemId: null == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      variantId: freezed == variantId
          ? _value.variantId
          : variantId // ignore: cast_nullable_to_non_nullable
              as int?,
      quantity: freezed == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int?,
      itemPrice: null == itemPrice
          ? _value.itemPrice
          : itemPrice // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ItemCartDetailImplCopyWith<$Res>
    implements $ItemCartDetailCopyWith<$Res> {
  factory _$$ItemCartDetailImplCopyWith(_$ItemCartDetailImpl value,
          $Res Function(_$ItemCartDetailImpl) then) =
      __$$ItemCartDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String itemId,
      String name,
      int? variantId,
      int? quantity,
      @JsonKey(fromJson: Converters.dynamicToDouble) double itemPrice});
}

/// @nodoc
class __$$ItemCartDetailImplCopyWithImpl<$Res>
    extends _$ItemCartDetailCopyWithImpl<$Res, _$ItemCartDetailImpl>
    implements _$$ItemCartDetailImplCopyWith<$Res> {
  __$$ItemCartDetailImplCopyWithImpl(
      _$ItemCartDetailImpl _value, $Res Function(_$ItemCartDetailImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? itemId = null,
    Object? name = null,
    Object? variantId = freezed,
    Object? quantity = freezed,
    Object? itemPrice = null,
  }) {
    return _then(_$ItemCartDetailImpl(
      itemId: null == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      variantId: freezed == variantId
          ? _value.variantId
          : variantId // ignore: cast_nullable_to_non_nullable
              as int?,
      quantity: freezed == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int?,
      itemPrice: null == itemPrice
          ? _value.itemPrice
          : itemPrice // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$ItemCartDetailImpl implements _ItemCartDetail {
  const _$ItemCartDetailImpl(
      {required this.itemId,
      required this.name,
      required this.variantId,
      required this.quantity,
      @JsonKey(fromJson: Converters.dynamicToDouble) required this.itemPrice});

  factory _$ItemCartDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$ItemCartDetailImplFromJson(json);

  @override
  final String itemId;
  @override
  final String name;
  @override
  final int? variantId;
  @override
  final int? quantity;
  @override
  @JsonKey(fromJson: Converters.dynamicToDouble)
  final double itemPrice;

  @override
  String toString() {
    return 'ItemCartDetail(itemId: $itemId, name: $name, variantId: $variantId, quantity: $quantity, itemPrice: $itemPrice)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ItemCartDetailImpl &&
            (identical(other.itemId, itemId) || other.itemId == itemId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.variantId, variantId) ||
                other.variantId == variantId) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.itemPrice, itemPrice) ||
                other.itemPrice == itemPrice));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, itemId, name, variantId, quantity, itemPrice);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ItemCartDetailImplCopyWith<_$ItemCartDetailImpl> get copyWith =>
      __$$ItemCartDetailImplCopyWithImpl<_$ItemCartDetailImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ItemCartDetailImplToJson(
      this,
    );
  }
}

abstract class _ItemCartDetail implements ItemCartDetail {
  const factory _ItemCartDetail(
      {required final String itemId,
      required final String name,
      required final int? variantId,
      required final int? quantity,
      @JsonKey(fromJson: Converters.dynamicToDouble)
      required final double itemPrice}) = _$ItemCartDetailImpl;

  factory _ItemCartDetail.fromJson(Map<String, dynamic> json) =
      _$ItemCartDetailImpl.fromJson;

  @override
  String get itemId;
  @override
  String get name;
  @override
  int? get variantId;
  @override
  int? get quantity;
  @override
  @JsonKey(fromJson: Converters.dynamicToDouble)
  double get itemPrice;
  @override
  @JsonKey(ignore: true)
  _$$ItemCartDetailImplCopyWith<_$ItemCartDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
