// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sold_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SoldItem _$SoldItemFromJson(Map<String, dynamic> json) {
  return _SoldItem.fromJson(json);
}

/// @nodoc
mixin _$SoldItem {
  String get idItem => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get sold => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SoldItemCopyWith<SoldItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SoldItemCopyWith<$Res> {
  factory $SoldItemCopyWith(SoldItem value, $Res Function(SoldItem) then) =
      _$SoldItemCopyWithImpl<$Res, SoldItem>;
  @useResult
  $Res call({String idItem, String name, int sold});
}

/// @nodoc
class _$SoldItemCopyWithImpl<$Res, $Val extends SoldItem>
    implements $SoldItemCopyWith<$Res> {
  _$SoldItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idItem = null,
    Object? name = null,
    Object? sold = null,
  }) {
    return _then(_value.copyWith(
      idItem: null == idItem
          ? _value.idItem
          : idItem // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      sold: null == sold
          ? _value.sold
          : sold // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SoldItemImplCopyWith<$Res>
    implements $SoldItemCopyWith<$Res> {
  factory _$$SoldItemImplCopyWith(
          _$SoldItemImpl value, $Res Function(_$SoldItemImpl) then) =
      __$$SoldItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String idItem, String name, int sold});
}

/// @nodoc
class __$$SoldItemImplCopyWithImpl<$Res>
    extends _$SoldItemCopyWithImpl<$Res, _$SoldItemImpl>
    implements _$$SoldItemImplCopyWith<$Res> {
  __$$SoldItemImplCopyWithImpl(
      _$SoldItemImpl _value, $Res Function(_$SoldItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idItem = null,
    Object? name = null,
    Object? sold = null,
  }) {
    return _then(_$SoldItemImpl(
      idItem: null == idItem
          ? _value.idItem
          : idItem // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      sold: null == sold
          ? _value.sold
          : sold // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$SoldItemImpl implements _SoldItem {
  const _$SoldItemImpl(
      {required this.idItem, required this.name, required this.sold});

  factory _$SoldItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$SoldItemImplFromJson(json);

  @override
  final String idItem;
  @override
  final String name;
  @override
  final int sold;

  @override
  String toString() {
    return 'SoldItem(idItem: $idItem, name: $name, sold: $sold)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SoldItemImpl &&
            (identical(other.idItem, idItem) || other.idItem == idItem) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.sold, sold) || other.sold == sold));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, idItem, name, sold);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SoldItemImplCopyWith<_$SoldItemImpl> get copyWith =>
      __$$SoldItemImplCopyWithImpl<_$SoldItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SoldItemImplToJson(
      this,
    );
  }
}

abstract class _SoldItem implements SoldItem {
  const factory _SoldItem(
      {required final String idItem,
      required final String name,
      required final int sold}) = _$SoldItemImpl;

  factory _SoldItem.fromJson(Map<String, dynamic> json) =
      _$SoldItemImpl.fromJson;

  @override
  String get idItem;
  @override
  String get name;
  @override
  int get sold;
  @override
  @JsonKey(ignore: true)
  _$$SoldItemImplCopyWith<_$SoldItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
