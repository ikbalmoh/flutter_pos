// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shift_payment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ShiftPayment _$ShiftPaymentFromJson(Map<String, dynamic> json) {
  return _ShiftPayment.fromJson(json);
}

/// @nodoc
mixin _$ShiftPayment {
  String get paymentMethodId => throw _privateConstructorUsedError;
  String get paymentName => throw _privateConstructorUsedError;
  double get value => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ShiftPaymentCopyWith<ShiftPayment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShiftPaymentCopyWith<$Res> {
  factory $ShiftPaymentCopyWith(
          ShiftPayment value, $Res Function(ShiftPayment) then) =
      _$ShiftPaymentCopyWithImpl<$Res, ShiftPayment>;
  @useResult
  $Res call({String paymentMethodId, String paymentName, double value});
}

/// @nodoc
class _$ShiftPaymentCopyWithImpl<$Res, $Val extends ShiftPayment>
    implements $ShiftPaymentCopyWith<$Res> {
  _$ShiftPaymentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? paymentMethodId = null,
    Object? paymentName = null,
    Object? value = null,
  }) {
    return _then(_value.copyWith(
      paymentMethodId: null == paymentMethodId
          ? _value.paymentMethodId
          : paymentMethodId // ignore: cast_nullable_to_non_nullable
              as String,
      paymentName: null == paymentName
          ? _value.paymentName
          : paymentName // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ShiftPaymentImplCopyWith<$Res>
    implements $ShiftPaymentCopyWith<$Res> {
  factory _$$ShiftPaymentImplCopyWith(
          _$ShiftPaymentImpl value, $Res Function(_$ShiftPaymentImpl) then) =
      __$$ShiftPaymentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String paymentMethodId, String paymentName, double value});
}

/// @nodoc
class __$$ShiftPaymentImplCopyWithImpl<$Res>
    extends _$ShiftPaymentCopyWithImpl<$Res, _$ShiftPaymentImpl>
    implements _$$ShiftPaymentImplCopyWith<$Res> {
  __$$ShiftPaymentImplCopyWithImpl(
      _$ShiftPaymentImpl _value, $Res Function(_$ShiftPaymentImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? paymentMethodId = null,
    Object? paymentName = null,
    Object? value = null,
  }) {
    return _then(_$ShiftPaymentImpl(
      paymentMethodId: null == paymentMethodId
          ? _value.paymentMethodId
          : paymentMethodId // ignore: cast_nullable_to_non_nullable
              as String,
      paymentName: null == paymentName
          ? _value.paymentName
          : paymentName // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$ShiftPaymentImpl implements _ShiftPayment {
  const _$ShiftPaymentImpl(
      {required this.paymentMethodId,
      required this.paymentName,
      required this.value});

  factory _$ShiftPaymentImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShiftPaymentImplFromJson(json);

  @override
  final String paymentMethodId;
  @override
  final String paymentName;
  @override
  final double value;

  @override
  String toString() {
    return 'ShiftPayment(paymentMethodId: $paymentMethodId, paymentName: $paymentName, value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShiftPaymentImpl &&
            (identical(other.paymentMethodId, paymentMethodId) ||
                other.paymentMethodId == paymentMethodId) &&
            (identical(other.paymentName, paymentName) ||
                other.paymentName == paymentName) &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, paymentMethodId, paymentName, value);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ShiftPaymentImplCopyWith<_$ShiftPaymentImpl> get copyWith =>
      __$$ShiftPaymentImplCopyWithImpl<_$ShiftPaymentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ShiftPaymentImplToJson(
      this,
    );
  }
}

abstract class _ShiftPayment implements ShiftPayment {
  const factory _ShiftPayment(
      {required final String paymentMethodId,
      required final String paymentName,
      required final double value}) = _$ShiftPaymentImpl;

  factory _ShiftPayment.fromJson(Map<String, dynamic> json) =
      _$ShiftPaymentImpl.fromJson;

  @override
  String get paymentMethodId;
  @override
  String get paymentName;
  @override
  double get value;
  @override
  @JsonKey(ignore: true)
  _$$ShiftPaymentImplCopyWith<_$ShiftPaymentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
