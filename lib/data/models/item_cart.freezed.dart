// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'item_cart.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ItemCart _$ItemCartFromJson(Map<String, dynamic> json) {
  return _ItemCart.fromJson(json);
}

/// @nodoc
mixin _$ItemCart {
  String get identifier => throw _privateConstructorUsedError;
  String get idItem => throw _privateConstructorUsedError;
  String get itemName => throw _privateConstructorUsedError;
  bool get isPackage => throw _privateConstructorUsedError;
  bool get isManualPrice => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  bool get manualDiscount => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  double get discount => throw _privateConstructorUsedError;
  @JsonKey(fromJson: Converters.dynamicToBool)
  bool get discountIsPercent => throw _privateConstructorUsedError;
  double get discountTotal => throw _privateConstructorUsedError;
  DateTime get addedAt => throw _privateConstructorUsedError;
  double get total => throw _privateConstructorUsedError;
  String get note => throw _privateConstructorUsedError;
  num? get idVariant => throw _privateConstructorUsedError;
  String? get variantName => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ItemCartCopyWith<ItemCart> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ItemCartCopyWith<$Res> {
  factory $ItemCartCopyWith(ItemCart value, $Res Function(ItemCart) then) =
      _$ItemCartCopyWithImpl<$Res, ItemCart>;
  @useResult
  $Res call(
      {String identifier,
      String idItem,
      String itemName,
      bool isPackage,
      bool isManualPrice,
      double price,
      bool manualDiscount,
      int quantity,
      double discount,
      @JsonKey(fromJson: Converters.dynamicToBool) bool discountIsPercent,
      double discountTotal,
      DateTime addedAt,
      double total,
      String note,
      num? idVariant,
      String? variantName});
}

/// @nodoc
class _$ItemCartCopyWithImpl<$Res, $Val extends ItemCart>
    implements $ItemCartCopyWith<$Res> {
  _$ItemCartCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? identifier = null,
    Object? idItem = null,
    Object? itemName = null,
    Object? isPackage = null,
    Object? isManualPrice = null,
    Object? price = null,
    Object? manualDiscount = null,
    Object? quantity = null,
    Object? discount = null,
    Object? discountIsPercent = null,
    Object? discountTotal = null,
    Object? addedAt = null,
    Object? total = null,
    Object? note = null,
    Object? idVariant = freezed,
    Object? variantName = freezed,
  }) {
    return _then(_value.copyWith(
      identifier: null == identifier
          ? _value.identifier
          : identifier // ignore: cast_nullable_to_non_nullable
              as String,
      idItem: null == idItem
          ? _value.idItem
          : idItem // ignore: cast_nullable_to_non_nullable
              as String,
      itemName: null == itemName
          ? _value.itemName
          : itemName // ignore: cast_nullable_to_non_nullable
              as String,
      isPackage: null == isPackage
          ? _value.isPackage
          : isPackage // ignore: cast_nullable_to_non_nullable
              as bool,
      isManualPrice: null == isManualPrice
          ? _value.isManualPrice
          : isManualPrice // ignore: cast_nullable_to_non_nullable
              as bool,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      manualDiscount: null == manualDiscount
          ? _value.manualDiscount
          : manualDiscount // ignore: cast_nullable_to_non_nullable
              as bool,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      discount: null == discount
          ? _value.discount
          : discount // ignore: cast_nullable_to_non_nullable
              as double,
      discountIsPercent: null == discountIsPercent
          ? _value.discountIsPercent
          : discountIsPercent // ignore: cast_nullable_to_non_nullable
              as bool,
      discountTotal: null == discountTotal
          ? _value.discountTotal
          : discountTotal // ignore: cast_nullable_to_non_nullable
              as double,
      addedAt: null == addedAt
          ? _value.addedAt
          : addedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
      note: null == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String,
      idVariant: freezed == idVariant
          ? _value.idVariant
          : idVariant // ignore: cast_nullable_to_non_nullable
              as num?,
      variantName: freezed == variantName
          ? _value.variantName
          : variantName // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ItemCartImplCopyWith<$Res>
    implements $ItemCartCopyWith<$Res> {
  factory _$$ItemCartImplCopyWith(
          _$ItemCartImpl value, $Res Function(_$ItemCartImpl) then) =
      __$$ItemCartImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String identifier,
      String idItem,
      String itemName,
      bool isPackage,
      bool isManualPrice,
      double price,
      bool manualDiscount,
      int quantity,
      double discount,
      @JsonKey(fromJson: Converters.dynamicToBool) bool discountIsPercent,
      double discountTotal,
      DateTime addedAt,
      double total,
      String note,
      num? idVariant,
      String? variantName});
}

/// @nodoc
class __$$ItemCartImplCopyWithImpl<$Res>
    extends _$ItemCartCopyWithImpl<$Res, _$ItemCartImpl>
    implements _$$ItemCartImplCopyWith<$Res> {
  __$$ItemCartImplCopyWithImpl(
      _$ItemCartImpl _value, $Res Function(_$ItemCartImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? identifier = null,
    Object? idItem = null,
    Object? itemName = null,
    Object? isPackage = null,
    Object? isManualPrice = null,
    Object? price = null,
    Object? manualDiscount = null,
    Object? quantity = null,
    Object? discount = null,
    Object? discountIsPercent = null,
    Object? discountTotal = null,
    Object? addedAt = null,
    Object? total = null,
    Object? note = null,
    Object? idVariant = freezed,
    Object? variantName = freezed,
  }) {
    return _then(_$ItemCartImpl(
      identifier: null == identifier
          ? _value.identifier
          : identifier // ignore: cast_nullable_to_non_nullable
              as String,
      idItem: null == idItem
          ? _value.idItem
          : idItem // ignore: cast_nullable_to_non_nullable
              as String,
      itemName: null == itemName
          ? _value.itemName
          : itemName // ignore: cast_nullable_to_non_nullable
              as String,
      isPackage: null == isPackage
          ? _value.isPackage
          : isPackage // ignore: cast_nullable_to_non_nullable
              as bool,
      isManualPrice: null == isManualPrice
          ? _value.isManualPrice
          : isManualPrice // ignore: cast_nullable_to_non_nullable
              as bool,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      manualDiscount: null == manualDiscount
          ? _value.manualDiscount
          : manualDiscount // ignore: cast_nullable_to_non_nullable
              as bool,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      discount: null == discount
          ? _value.discount
          : discount // ignore: cast_nullable_to_non_nullable
              as double,
      discountIsPercent: null == discountIsPercent
          ? _value.discountIsPercent
          : discountIsPercent // ignore: cast_nullable_to_non_nullable
              as bool,
      discountTotal: null == discountTotal
          ? _value.discountTotal
          : discountTotal // ignore: cast_nullable_to_non_nullable
              as double,
      addedAt: null == addedAt
          ? _value.addedAt
          : addedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
      note: null == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String,
      idVariant: freezed == idVariant
          ? _value.idVariant
          : idVariant // ignore: cast_nullable_to_non_nullable
              as num?,
      variantName: freezed == variantName
          ? _value.variantName
          : variantName // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$ItemCartImpl extends _ItemCart {
  const _$ItemCartImpl(
      {required this.identifier,
      required this.idItem,
      required this.itemName,
      required this.isPackage,
      required this.isManualPrice,
      required this.price,
      required this.manualDiscount,
      required this.quantity,
      required this.discount,
      @JsonKey(fromJson: Converters.dynamicToBool)
      required this.discountIsPercent,
      required this.discountTotal,
      required this.addedAt,
      required this.total,
      required this.note,
      this.idVariant,
      this.variantName})
      : super._();

  factory _$ItemCartImpl.fromJson(Map<String, dynamic> json) =>
      _$$ItemCartImplFromJson(json);

  @override
  final String identifier;
  @override
  final String idItem;
  @override
  final String itemName;
  @override
  final bool isPackage;
  @override
  final bool isManualPrice;
  @override
  final double price;
  @override
  final bool manualDiscount;
  @override
  final int quantity;
  @override
  final double discount;
  @override
  @JsonKey(fromJson: Converters.dynamicToBool)
  final bool discountIsPercent;
  @override
  final double discountTotal;
  @override
  final DateTime addedAt;
  @override
  final double total;
  @override
  final String note;
  @override
  final num? idVariant;
  @override
  final String? variantName;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ItemCartImpl &&
            (identical(other.identifier, identifier) ||
                other.identifier == identifier) &&
            (identical(other.idItem, idItem) || other.idItem == idItem) &&
            (identical(other.itemName, itemName) ||
                other.itemName == itemName) &&
            (identical(other.isPackage, isPackage) ||
                other.isPackage == isPackage) &&
            (identical(other.isManualPrice, isManualPrice) ||
                other.isManualPrice == isManualPrice) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.manualDiscount, manualDiscount) ||
                other.manualDiscount == manualDiscount) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.discount, discount) ||
                other.discount == discount) &&
            (identical(other.discountIsPercent, discountIsPercent) ||
                other.discountIsPercent == discountIsPercent) &&
            (identical(other.discountTotal, discountTotal) ||
                other.discountTotal == discountTotal) &&
            (identical(other.addedAt, addedAt) || other.addedAt == addedAt) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.idVariant, idVariant) ||
                other.idVariant == idVariant) &&
            (identical(other.variantName, variantName) ||
                other.variantName == variantName));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      identifier,
      idItem,
      itemName,
      isPackage,
      isManualPrice,
      price,
      manualDiscount,
      quantity,
      discount,
      discountIsPercent,
      discountTotal,
      addedAt,
      total,
      note,
      idVariant,
      variantName);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ItemCartImplCopyWith<_$ItemCartImpl> get copyWith =>
      __$$ItemCartImplCopyWithImpl<_$ItemCartImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ItemCartImplToJson(
      this,
    );
  }
}

abstract class _ItemCart extends ItemCart {
  const factory _ItemCart(
      {required final String identifier,
      required final String idItem,
      required final String itemName,
      required final bool isPackage,
      required final bool isManualPrice,
      required final double price,
      required final bool manualDiscount,
      required final int quantity,
      required final double discount,
      @JsonKey(fromJson: Converters.dynamicToBool)
      required final bool discountIsPercent,
      required final double discountTotal,
      required final DateTime addedAt,
      required final double total,
      required final String note,
      final num? idVariant,
      final String? variantName}) = _$ItemCartImpl;
  const _ItemCart._() : super._();

  factory _ItemCart.fromJson(Map<String, dynamic> json) =
      _$ItemCartImpl.fromJson;

  @override
  String get identifier;
  @override
  String get idItem;
  @override
  String get itemName;
  @override
  bool get isPackage;
  @override
  bool get isManualPrice;
  @override
  double get price;
  @override
  bool get manualDiscount;
  @override
  int get quantity;
  @override
  double get discount;
  @override
  @JsonKey(fromJson: Converters.dynamicToBool)
  bool get discountIsPercent;
  @override
  double get discountTotal;
  @override
  DateTime get addedAt;
  @override
  double get total;
  @override
  String get note;
  @override
  num? get idVariant;
  @override
  String? get variantName;
  @override
  @JsonKey(ignore: true)
  _$$ItemCartImplCopyWith<_$ItemCartImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
