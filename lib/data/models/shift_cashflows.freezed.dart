// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shift_cashflows.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ShiftCashFlows _$ShiftCashFlowsFromJson(Map<String, dynamic> json) {
  return _ShiftCashFlows.fromJson(json);
}

/// @nodoc
mixin _$ShiftCashFlows {
  List<ShiftCashflow> get data => throw _privateConstructorUsedError;
  double get total => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ShiftCashFlowsCopyWith<ShiftCashFlows> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShiftCashFlowsCopyWith<$Res> {
  factory $ShiftCashFlowsCopyWith(
          ShiftCashFlows value, $Res Function(ShiftCashFlows) then) =
      _$ShiftCashFlowsCopyWithImpl<$Res, ShiftCashFlows>;
  @useResult
  $Res call({List<ShiftCashflow> data, double total});
}

/// @nodoc
class _$ShiftCashFlowsCopyWithImpl<$Res, $Val extends ShiftCashFlows>
    implements $ShiftCashFlowsCopyWith<$Res> {
  _$ShiftCashFlowsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? total = null,
  }) {
    return _then(_value.copyWith(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as List<ShiftCashflow>,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ShiftCashFlowsImplCopyWith<$Res>
    implements $ShiftCashFlowsCopyWith<$Res> {
  factory _$$ShiftCashFlowsImplCopyWith(_$ShiftCashFlowsImpl value,
          $Res Function(_$ShiftCashFlowsImpl) then) =
      __$$ShiftCashFlowsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<ShiftCashflow> data, double total});
}

/// @nodoc
class __$$ShiftCashFlowsImplCopyWithImpl<$Res>
    extends _$ShiftCashFlowsCopyWithImpl<$Res, _$ShiftCashFlowsImpl>
    implements _$$ShiftCashFlowsImplCopyWith<$Res> {
  __$$ShiftCashFlowsImplCopyWithImpl(
      _$ShiftCashFlowsImpl _value, $Res Function(_$ShiftCashFlowsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? total = null,
  }) {
    return _then(_$ShiftCashFlowsImpl(
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<ShiftCashflow>,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$ShiftCashFlowsImpl implements _ShiftCashFlows {
  const _$ShiftCashFlowsImpl(
      {required final List<ShiftCashflow> data, required this.total})
      : _data = data;

  factory _$ShiftCashFlowsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShiftCashFlowsImplFromJson(json);

  final List<ShiftCashflow> _data;
  @override
  List<ShiftCashflow> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  final double total;

  @override
  String toString() {
    return 'ShiftCashFlows(data: $data, total: $total)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShiftCashFlowsImpl &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.total, total) || other.total == total));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_data), total);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ShiftCashFlowsImplCopyWith<_$ShiftCashFlowsImpl> get copyWith =>
      __$$ShiftCashFlowsImplCopyWithImpl<_$ShiftCashFlowsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ShiftCashFlowsImplToJson(
      this,
    );
  }
}

abstract class _ShiftCashFlows implements ShiftCashFlows {
  const factory _ShiftCashFlows(
      {required final List<ShiftCashflow> data,
      required final double total}) = _$ShiftCashFlowsImpl;

  factory _ShiftCashFlows.fromJson(Map<String, dynamic> json) =
      _$ShiftCashFlowsImpl.fromJson;

  @override
  List<ShiftCashflow> get data;
  @override
  double get total;
  @override
  @JsonKey(ignore: true)
  _$$ShiftCashFlowsImplCopyWith<_$ShiftCashFlowsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
