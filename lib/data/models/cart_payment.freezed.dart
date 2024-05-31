// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cart_payment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CartPayment _$CartPaymentFromJson(Map<String, dynamic> json) {
  return _CartPayment.fromJson(json);
}

/// @nodoc
mixin _$CartPayment {
  String get paymentMethodId => throw _privateConstructorUsedError;
  String get paymentname => throw _privateConstructorUsedError;
  double get paymentValue => throw _privateConstructorUsedError;
  String? get reference => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CartPaymentCopyWith<CartPayment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CartPaymentCopyWith<$Res> {
  factory $CartPaymentCopyWith(
          CartPayment value, $Res Function(CartPayment) then) =
      _$CartPaymentCopyWithImpl<$Res, CartPayment>;
  @useResult
  $Res call(
      {String paymentMethodId,
      String paymentname,
      double paymentValue,
      String? reference});
}

/// @nodoc
class _$CartPaymentCopyWithImpl<$Res, $Val extends CartPayment>
    implements $CartPaymentCopyWith<$Res> {
  _$CartPaymentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? paymentMethodId = null,
    Object? paymentname = null,
    Object? paymentValue = null,
    Object? reference = freezed,
  }) {
    return _then(_value.copyWith(
      paymentMethodId: null == paymentMethodId
          ? _value.paymentMethodId
          : paymentMethodId // ignore: cast_nullable_to_non_nullable
              as String,
      paymentname: null == paymentname
          ? _value.paymentname
          : paymentname // ignore: cast_nullable_to_non_nullable
              as String,
      paymentValue: null == paymentValue
          ? _value.paymentValue
          : paymentValue // ignore: cast_nullable_to_non_nullable
              as double,
      reference: freezed == reference
          ? _value.reference
          : reference // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CartPaymentImplCopyWith<$Res>
    implements $CartPaymentCopyWith<$Res> {
  factory _$$CartPaymentImplCopyWith(
          _$CartPaymentImpl value, $Res Function(_$CartPaymentImpl) then) =
      __$$CartPaymentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String paymentMethodId,
      String paymentname,
      double paymentValue,
      String? reference});
}

/// @nodoc
class __$$CartPaymentImplCopyWithImpl<$Res>
    extends _$CartPaymentCopyWithImpl<$Res, _$CartPaymentImpl>
    implements _$$CartPaymentImplCopyWith<$Res> {
  __$$CartPaymentImplCopyWithImpl(
      _$CartPaymentImpl _value, $Res Function(_$CartPaymentImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? paymentMethodId = null,
    Object? paymentname = null,
    Object? paymentValue = null,
    Object? reference = freezed,
  }) {
    return _then(_$CartPaymentImpl(
      paymentMethodId: null == paymentMethodId
          ? _value.paymentMethodId
          : paymentMethodId // ignore: cast_nullable_to_non_nullable
              as String,
      paymentname: null == paymentname
          ? _value.paymentname
          : paymentname // ignore: cast_nullable_to_non_nullable
              as String,
      paymentValue: null == paymentValue
          ? _value.paymentValue
          : paymentValue // ignore: cast_nullable_to_non_nullable
              as double,
      reference: freezed == reference
          ? _value.reference
          : reference // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$CartPaymentImpl implements _CartPayment {
  const _$CartPaymentImpl(
      {required this.paymentMethodId,
      required this.paymentname,
      required this.paymentValue,
      this.reference});

  factory _$CartPaymentImpl.fromJson(Map<String, dynamic> json) =>
      _$$CartPaymentImplFromJson(json);

  @override
  final String paymentMethodId;
  @override
  final String paymentname;
  @override
  final double paymentValue;
  @override
  final String? reference;

  @override
  String toString() {
    return 'CartPayment(paymentMethodId: $paymentMethodId, paymentname: $paymentname, paymentValue: $paymentValue, reference: $reference)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CartPaymentImpl &&
            (identical(other.paymentMethodId, paymentMethodId) ||
                other.paymentMethodId == paymentMethodId) &&
            (identical(other.paymentname, paymentname) ||
                other.paymentname == paymentname) &&
            (identical(other.paymentValue, paymentValue) ||
                other.paymentValue == paymentValue) &&
            (identical(other.reference, reference) ||
                other.reference == reference));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, paymentMethodId, paymentname, paymentValue, reference);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CartPaymentImplCopyWith<_$CartPaymentImpl> get copyWith =>
      __$$CartPaymentImplCopyWithImpl<_$CartPaymentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CartPaymentImplToJson(
      this,
    );
  }
}

abstract class _CartPayment implements CartPayment {
  const factory _CartPayment(
      {required final String paymentMethodId,
      required final String paymentname,
      required final double paymentValue,
      final String? reference}) = _$CartPaymentImpl;

  factory _CartPayment.fromJson(Map<String, dynamic> json) =
      _$CartPaymentImpl.fromJson;

  @override
  String get paymentMethodId;
  @override
  String get paymentname;
  @override
  double get paymentValue;
  @override
  String? get reference;
  @override
  @JsonKey(ignore: true)
  _$$CartPaymentImplCopyWith<_$CartPaymentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
