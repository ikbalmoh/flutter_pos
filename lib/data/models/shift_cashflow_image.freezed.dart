// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shift_cashflow_image.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ShiftCashflowImage _$ShiftCashflowImageFromJson(Map<String, dynamic> json) {
  return _ShiftCashflowImage.fromJson(json);
}

/// @nodoc
mixin _$ShiftCashflowImage {
  int get id => throw _privateConstructorUsedError;
  String get uri => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ShiftCashflowImageCopyWith<ShiftCashflowImage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShiftCashflowImageCopyWith<$Res> {
  factory $ShiftCashflowImageCopyWith(
          ShiftCashflowImage value, $Res Function(ShiftCashflowImage) then) =
      _$ShiftCashflowImageCopyWithImpl<$Res, ShiftCashflowImage>;
  @useResult
  $Res call({int id, String uri, String name});
}

/// @nodoc
class _$ShiftCashflowImageCopyWithImpl<$Res, $Val extends ShiftCashflowImage>
    implements $ShiftCashflowImageCopyWith<$Res> {
  _$ShiftCashflowImageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? uri = null,
    Object? name = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      uri: null == uri
          ? _value.uri
          : uri // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ShiftCashflowImageImplCopyWith<$Res>
    implements $ShiftCashflowImageCopyWith<$Res> {
  factory _$$ShiftCashflowImageImplCopyWith(_$ShiftCashflowImageImpl value,
          $Res Function(_$ShiftCashflowImageImpl) then) =
      __$$ShiftCashflowImageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String uri, String name});
}

/// @nodoc
class __$$ShiftCashflowImageImplCopyWithImpl<$Res>
    extends _$ShiftCashflowImageCopyWithImpl<$Res, _$ShiftCashflowImageImpl>
    implements _$$ShiftCashflowImageImplCopyWith<$Res> {
  __$$ShiftCashflowImageImplCopyWithImpl(_$ShiftCashflowImageImpl _value,
      $Res Function(_$ShiftCashflowImageImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? uri = null,
    Object? name = null,
  }) {
    return _then(_$ShiftCashflowImageImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      uri: null == uri
          ? _value.uri
          : uri // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$ShiftCashflowImageImpl implements _ShiftCashflowImage {
  const _$ShiftCashflowImageImpl(
      {required this.id, required this.uri, required this.name});

  factory _$ShiftCashflowImageImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShiftCashflowImageImplFromJson(json);

  @override
  final int id;
  @override
  final String uri;
  @override
  final String name;

  @override
  String toString() {
    return 'ShiftCashflowImage(id: $id, uri: $uri, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShiftCashflowImageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.uri, uri) || other.uri == uri) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, uri, name);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ShiftCashflowImageImplCopyWith<_$ShiftCashflowImageImpl> get copyWith =>
      __$$ShiftCashflowImageImplCopyWithImpl<_$ShiftCashflowImageImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ShiftCashflowImageImplToJson(
      this,
    );
  }
}

abstract class _ShiftCashflowImage implements ShiftCashflowImage {
  const factory _ShiftCashflowImage(
      {required final int id,
      required final String uri,
      required final String name}) = _$ShiftCashflowImageImpl;

  factory _ShiftCashflowImage.fromJson(Map<String, dynamic> json) =
      _$ShiftCashflowImageImpl.fromJson;

  @override
  int get id;
  @override
  String get uri;
  @override
  String get name;
  @override
  @JsonKey(ignore: true)
  _$$ShiftCashflowImageImplCopyWith<_$ShiftCashflowImageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
