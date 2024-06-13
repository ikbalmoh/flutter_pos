// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cart_holded.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CartHolded _$CartHoldedFromJson(Map<String, dynamic> json) {
  return _CartHolded.fromJson(json);
}

/// @nodoc
mixin _$CartHolded {
  String get transactionId => throw _privateConstructorUsedError;
  String get idOutlet => throw _privateConstructorUsedError;
  String get shiftId => throw _privateConstructorUsedError;
  String get transactionDate => throw _privateConstructorUsedError;
  String get transactionNo => throw _privateConstructorUsedError;
  String? get idCustomer => throw _privateConstructorUsedError;
  String? get customerName => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  String? get createdName => throw _privateConstructorUsedError;
  @JsonKey(fromJson: Cart.fromDataHold)
  Cart get dataHold => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CartHoldedCopyWith<CartHolded> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CartHoldedCopyWith<$Res> {
  factory $CartHoldedCopyWith(
          CartHolded value, $Res Function(CartHolded) then) =
      _$CartHoldedCopyWithImpl<$Res, CartHolded>;
  @useResult
  $Res call(
      {String transactionId,
      String idOutlet,
      String shiftId,
      String transactionDate,
      String transactionNo,
      String? idCustomer,
      String? customerName,
      DateTime createdAt,
      String? createdName,
      @JsonKey(fromJson: Cart.fromDataHold) Cart dataHold});

  $CartCopyWith<$Res> get dataHold;
}

/// @nodoc
class _$CartHoldedCopyWithImpl<$Res, $Val extends CartHolded>
    implements $CartHoldedCopyWith<$Res> {
  _$CartHoldedCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? transactionId = null,
    Object? idOutlet = null,
    Object? shiftId = null,
    Object? transactionDate = null,
    Object? transactionNo = null,
    Object? idCustomer = freezed,
    Object? customerName = freezed,
    Object? createdAt = null,
    Object? createdName = freezed,
    Object? dataHold = null,
  }) {
    return _then(_value.copyWith(
      transactionId: null == transactionId
          ? _value.transactionId
          : transactionId // ignore: cast_nullable_to_non_nullable
              as String,
      idOutlet: null == idOutlet
          ? _value.idOutlet
          : idOutlet // ignore: cast_nullable_to_non_nullable
              as String,
      shiftId: null == shiftId
          ? _value.shiftId
          : shiftId // ignore: cast_nullable_to_non_nullable
              as String,
      transactionDate: null == transactionDate
          ? _value.transactionDate
          : transactionDate // ignore: cast_nullable_to_non_nullable
              as String,
      transactionNo: null == transactionNo
          ? _value.transactionNo
          : transactionNo // ignore: cast_nullable_to_non_nullable
              as String,
      idCustomer: freezed == idCustomer
          ? _value.idCustomer
          : idCustomer // ignore: cast_nullable_to_non_nullable
              as String?,
      customerName: freezed == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdName: freezed == createdName
          ? _value.createdName
          : createdName // ignore: cast_nullable_to_non_nullable
              as String?,
      dataHold: null == dataHold
          ? _value.dataHold
          : dataHold // ignore: cast_nullable_to_non_nullable
              as Cart,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $CartCopyWith<$Res> get dataHold {
    return $CartCopyWith<$Res>(_value.dataHold, (value) {
      return _then(_value.copyWith(dataHold: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CartHoldedImplCopyWith<$Res>
    implements $CartHoldedCopyWith<$Res> {
  factory _$$CartHoldedImplCopyWith(
          _$CartHoldedImpl value, $Res Function(_$CartHoldedImpl) then) =
      __$$CartHoldedImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String transactionId,
      String idOutlet,
      String shiftId,
      String transactionDate,
      String transactionNo,
      String? idCustomer,
      String? customerName,
      DateTime createdAt,
      String? createdName,
      @JsonKey(fromJson: Cart.fromDataHold) Cart dataHold});

  @override
  $CartCopyWith<$Res> get dataHold;
}

/// @nodoc
class __$$CartHoldedImplCopyWithImpl<$Res>
    extends _$CartHoldedCopyWithImpl<$Res, _$CartHoldedImpl>
    implements _$$CartHoldedImplCopyWith<$Res> {
  __$$CartHoldedImplCopyWithImpl(
      _$CartHoldedImpl _value, $Res Function(_$CartHoldedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? transactionId = null,
    Object? idOutlet = null,
    Object? shiftId = null,
    Object? transactionDate = null,
    Object? transactionNo = null,
    Object? idCustomer = freezed,
    Object? customerName = freezed,
    Object? createdAt = null,
    Object? createdName = freezed,
    Object? dataHold = null,
  }) {
    return _then(_$CartHoldedImpl(
      transactionId: null == transactionId
          ? _value.transactionId
          : transactionId // ignore: cast_nullable_to_non_nullable
              as String,
      idOutlet: null == idOutlet
          ? _value.idOutlet
          : idOutlet // ignore: cast_nullable_to_non_nullable
              as String,
      shiftId: null == shiftId
          ? _value.shiftId
          : shiftId // ignore: cast_nullable_to_non_nullable
              as String,
      transactionDate: null == transactionDate
          ? _value.transactionDate
          : transactionDate // ignore: cast_nullable_to_non_nullable
              as String,
      transactionNo: null == transactionNo
          ? _value.transactionNo
          : transactionNo // ignore: cast_nullable_to_non_nullable
              as String,
      idCustomer: freezed == idCustomer
          ? _value.idCustomer
          : idCustomer // ignore: cast_nullable_to_non_nullable
              as String?,
      customerName: freezed == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdName: freezed == createdName
          ? _value.createdName
          : createdName // ignore: cast_nullable_to_non_nullable
              as String?,
      dataHold: null == dataHold
          ? _value.dataHold
          : dataHold // ignore: cast_nullable_to_non_nullable
              as Cart,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$CartHoldedImpl extends _CartHolded {
  const _$CartHoldedImpl(
      {required this.transactionId,
      required this.idOutlet,
      required this.shiftId,
      required this.transactionDate,
      required this.transactionNo,
      this.idCustomer,
      this.customerName,
      required this.createdAt,
      this.createdName,
      @JsonKey(fromJson: Cart.fromDataHold) required this.dataHold})
      : super._();

  factory _$CartHoldedImpl.fromJson(Map<String, dynamic> json) =>
      _$$CartHoldedImplFromJson(json);

  @override
  final String transactionId;
  @override
  final String idOutlet;
  @override
  final String shiftId;
  @override
  final String transactionDate;
  @override
  final String transactionNo;
  @override
  final String? idCustomer;
  @override
  final String? customerName;
  @override
  final DateTime createdAt;
  @override
  final String? createdName;
  @override
  @JsonKey(fromJson: Cart.fromDataHold)
  final Cart dataHold;

  @override
  String toString() {
    return 'CartHolded(transactionId: $transactionId, idOutlet: $idOutlet, shiftId: $shiftId, transactionDate: $transactionDate, transactionNo: $transactionNo, idCustomer: $idCustomer, customerName: $customerName, createdAt: $createdAt, createdName: $createdName, dataHold: $dataHold)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CartHoldedImpl &&
            (identical(other.transactionId, transactionId) ||
                other.transactionId == transactionId) &&
            (identical(other.idOutlet, idOutlet) ||
                other.idOutlet == idOutlet) &&
            (identical(other.shiftId, shiftId) || other.shiftId == shiftId) &&
            (identical(other.transactionDate, transactionDate) ||
                other.transactionDate == transactionDate) &&
            (identical(other.transactionNo, transactionNo) ||
                other.transactionNo == transactionNo) &&
            (identical(other.idCustomer, idCustomer) ||
                other.idCustomer == idCustomer) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.createdName, createdName) ||
                other.createdName == createdName) &&
            (identical(other.dataHold, dataHold) ||
                other.dataHold == dataHold));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      transactionId,
      idOutlet,
      shiftId,
      transactionDate,
      transactionNo,
      idCustomer,
      customerName,
      createdAt,
      createdName,
      dataHold);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CartHoldedImplCopyWith<_$CartHoldedImpl> get copyWith =>
      __$$CartHoldedImplCopyWithImpl<_$CartHoldedImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CartHoldedImplToJson(
      this,
    );
  }
}

abstract class _CartHolded extends CartHolded {
  const factory _CartHolded(
          {required final String transactionId,
          required final String idOutlet,
          required final String shiftId,
          required final String transactionDate,
          required final String transactionNo,
          final String? idCustomer,
          final String? customerName,
          required final DateTime createdAt,
          final String? createdName,
          @JsonKey(fromJson: Cart.fromDataHold) required final Cart dataHold}) =
      _$CartHoldedImpl;
  const _CartHolded._() : super._();

  factory _CartHolded.fromJson(Map<String, dynamic> json) =
      _$CartHoldedImpl.fromJson;

  @override
  String get transactionId;
  @override
  String get idOutlet;
  @override
  String get shiftId;
  @override
  String get transactionDate;
  @override
  String get transactionNo;
  @override
  String? get idCustomer;
  @override
  String? get customerName;
  @override
  DateTime get createdAt;
  @override
  String? get createdName;
  @override
  @JsonKey(fromJson: Cart.fromDataHold)
  Cart get dataHold;
  @override
  @JsonKey(ignore: true)
  _$$CartHoldedImplCopyWith<_$CartHoldedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
