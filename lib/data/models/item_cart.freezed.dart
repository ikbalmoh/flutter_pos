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
  String? get identifier => throw _privateConstructorUsedError;
  String get idItem => throw _privateConstructorUsedError;
  String get itemName => throw _privateConstructorUsedError;
  @JsonKey(fromJson: Converters.dynamicToBool)
  bool get isPackage => throw _privateConstructorUsedError;
  @JsonKey(fromJson: Converters.dynamicToBool)
  bool get isManualPrice => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  @JsonKey(fromJson: Converters.dynamicToBool)
  bool get manualDiscount => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  double get discount => throw _privateConstructorUsedError;
  @JsonKey(fromJson: Converters.dynamicToBool)
  bool get discountIsPercent => throw _privateConstructorUsedError;
  double get discountTotal => throw _privateConstructorUsedError;
  DateTime? get addedAt => throw _privateConstructorUsedError;
  double get total => throw _privateConstructorUsedError;
  String? get note => throw _privateConstructorUsedError;
  @JsonKey(fromJson: Converters.dynamicToNum)
  num? get idVariant => throw _privateConstructorUsedError;
  String? get variantName => throw _privateConstructorUsedError;
  List<ItemCartDetail> get details => throw _privateConstructorUsedError;

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
      {String? identifier,
      String idItem,
      String itemName,
      @JsonKey(fromJson: Converters.dynamicToBool) bool isPackage,
      @JsonKey(fromJson: Converters.dynamicToBool) bool isManualPrice,
      double price,
      @JsonKey(fromJson: Converters.dynamicToBool) bool manualDiscount,
      int quantity,
      double discount,
      @JsonKey(fromJson: Converters.dynamicToBool) bool discountIsPercent,
      double discountTotal,
      DateTime? addedAt,
      double total,
      String? note,
      @JsonKey(fromJson: Converters.dynamicToNum) num? idVariant,
      String? variantName,
      List<ItemCartDetail> details});
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
    Object? identifier = freezed,
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
    Object? addedAt = freezed,
    Object? total = null,
    Object? note = freezed,
    Object? idVariant = freezed,
    Object? variantName = freezed,
    Object? details = null,
  }) {
    return _then(_value.copyWith(
      identifier: freezed == identifier
          ? _value.identifier
          : identifier // ignore: cast_nullable_to_non_nullable
              as String?,
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
      addedAt: freezed == addedAt
          ? _value.addedAt
          : addedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      idVariant: freezed == idVariant
          ? _value.idVariant
          : idVariant // ignore: cast_nullable_to_non_nullable
              as num?,
      variantName: freezed == variantName
          ? _value.variantName
          : variantName // ignore: cast_nullable_to_non_nullable
              as String?,
      details: null == details
          ? _value.details
          : details // ignore: cast_nullable_to_non_nullable
              as List<ItemCartDetail>,
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
      {String? identifier,
      String idItem,
      String itemName,
      @JsonKey(fromJson: Converters.dynamicToBool) bool isPackage,
      @JsonKey(fromJson: Converters.dynamicToBool) bool isManualPrice,
      double price,
      @JsonKey(fromJson: Converters.dynamicToBool) bool manualDiscount,
      int quantity,
      double discount,
      @JsonKey(fromJson: Converters.dynamicToBool) bool discountIsPercent,
      double discountTotal,
      DateTime? addedAt,
      double total,
      String? note,
      @JsonKey(fromJson: Converters.dynamicToNum) num? idVariant,
      String? variantName,
      List<ItemCartDetail> details});
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
    Object? identifier = freezed,
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
    Object? addedAt = freezed,
    Object? total = null,
    Object? note = freezed,
    Object? idVariant = freezed,
    Object? variantName = freezed,
    Object? details = null,
  }) {
    return _then(_$ItemCartImpl(
      identifier: freezed == identifier
          ? _value.identifier
          : identifier // ignore: cast_nullable_to_non_nullable
              as String?,
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
      addedAt: freezed == addedAt
          ? _value.addedAt
          : addedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      idVariant: freezed == idVariant
          ? _value.idVariant
          : idVariant // ignore: cast_nullable_to_non_nullable
              as num?,
      variantName: freezed == variantName
          ? _value.variantName
          : variantName // ignore: cast_nullable_to_non_nullable
              as String?,
      details: null == details
          ? _value._details
          : details // ignore: cast_nullable_to_non_nullable
              as List<ItemCartDetail>,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$ItemCartImpl extends _ItemCart {
  const _$ItemCartImpl(
      {this.identifier,
      required this.idItem,
      required this.itemName,
      @JsonKey(fromJson: Converters.dynamicToBool) required this.isPackage,
      @JsonKey(fromJson: Converters.dynamicToBool) required this.isManualPrice,
      required this.price,
      @JsonKey(fromJson: Converters.dynamicToBool) required this.manualDiscount,
      required this.quantity,
      required this.discount,
      @JsonKey(fromJson: Converters.dynamicToBool)
      required this.discountIsPercent,
      required this.discountTotal,
      this.addedAt,
      required this.total,
      this.note,
      @JsonKey(fromJson: Converters.dynamicToNum) this.idVariant,
      this.variantName,
      required final List<ItemCartDetail> details})
      : _details = details,
        super._();

  factory _$ItemCartImpl.fromJson(Map<String, dynamic> json) =>
      _$$ItemCartImplFromJson(json);

  @override
  final String? identifier;
  @override
  final String idItem;
  @override
  final String itemName;
  @override
  @JsonKey(fromJson: Converters.dynamicToBool)
  final bool isPackage;
  @override
  @JsonKey(fromJson: Converters.dynamicToBool)
  final bool isManualPrice;
  @override
  final double price;
  @override
  @JsonKey(fromJson: Converters.dynamicToBool)
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
  final DateTime? addedAt;
  @override
  final double total;
  @override
  final String? note;
  @override
  @JsonKey(fromJson: Converters.dynamicToNum)
  final num? idVariant;
  @override
  final String? variantName;
  final List<ItemCartDetail> _details;
  @override
  List<ItemCartDetail> get details {
    if (_details is EqualUnmodifiableListView) return _details;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_details);
  }

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
                other.variantName == variantName) &&
            const DeepCollectionEquality().equals(other._details, _details));
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
      variantName,
      const DeepCollectionEquality().hash(_details));

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
      {final String? identifier,
      required final String idItem,
      required final String itemName,
      @JsonKey(fromJson: Converters.dynamicToBool)
      required final bool isPackage,
      @JsonKey(fromJson: Converters.dynamicToBool)
      required final bool isManualPrice,
      required final double price,
      @JsonKey(fromJson: Converters.dynamicToBool)
      required final bool manualDiscount,
      required final int quantity,
      required final double discount,
      @JsonKey(fromJson: Converters.dynamicToBool)
      required final bool discountIsPercent,
      required final double discountTotal,
      final DateTime? addedAt,
      required final double total,
      final String? note,
      @JsonKey(fromJson: Converters.dynamicToNum) final num? idVariant,
      final String? variantName,
      required final List<ItemCartDetail> details}) = _$ItemCartImpl;
  const _ItemCart._() : super._();

  factory _ItemCart.fromJson(Map<String, dynamic> json) =
      _$ItemCartImpl.fromJson;

  @override
  String? get identifier;
  @override
  String get idItem;
  @override
  String get itemName;
  @override
  @JsonKey(fromJson: Converters.dynamicToBool)
  bool get isPackage;
  @override
  @JsonKey(fromJson: Converters.dynamicToBool)
  bool get isManualPrice;
  @override
  double get price;
  @override
  @JsonKey(fromJson: Converters.dynamicToBool)
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
  DateTime? get addedAt;
  @override
  double get total;
  @override
  String? get note;
  @override
  @JsonKey(fromJson: Converters.dynamicToNum)
  num? get idVariant;
  @override
  String? get variantName;
  @override
  List<ItemCartDetail> get details;
  @override
  @JsonKey(ignore: true)
  _$$ItemCartImplCopyWith<_$ItemCartImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
