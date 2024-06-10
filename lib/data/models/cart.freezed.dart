// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cart.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Cart _$CartFromJson(Map<String, dynamic> json) {
  return _Cart.fromJson(json);
}

/// @nodoc
mixin _$Cart {
  DateTime get transactionDate => throw _privateConstructorUsedError;
  String get transactionNo => throw _privateConstructorUsedError;
  String get idOutlet => throw _privateConstructorUsedError;
  String get outletName => throw _privateConstructorUsedError;
  String get shiftId => throw _privateConstructorUsedError;
  double get subtotal => throw _privateConstructorUsedError;
  @JsonKey(fromJson: Converters.dynamicToBool)
  bool get discIsPercent => throw _privateConstructorUsedError;
  double get discOverall => throw _privateConstructorUsedError;
  double get discOverallTotal => throw _privateConstructorUsedError;
  double get discPromotionsTotal => throw _privateConstructorUsedError;
  double get total => throw _privateConstructorUsedError;
  bool get ppnIsInclude => throw _privateConstructorUsedError;
  double get ppn => throw _privateConstructorUsedError;
  String? get taxName => throw _privateConstructorUsedError;
  double get ppnTotal => throw _privateConstructorUsedError;
  double get grandTotal => throw _privateConstructorUsedError;
  double get totalPayment => throw _privateConstructorUsedError;
  double get change => throw _privateConstructorUsedError;
  String? get idCustomer => throw _privateConstructorUsedError;
  String? get customerName => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  String? get personInCharge => throw _privateConstructorUsedError;
  DateTime? get holdAt => throw _privateConstructorUsedError;
  String get createdBy => throw _privateConstructorUsedError;
  String? get createdName => throw _privateConstructorUsedError;
  List<ItemCart> get items => throw _privateConstructorUsedError;
  List<CartPayment> get payments => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CartCopyWith<Cart> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CartCopyWith<$Res> {
  factory $CartCopyWith(Cart value, $Res Function(Cart) then) =
      _$CartCopyWithImpl<$Res, Cart>;
  @useResult
  $Res call(
      {DateTime transactionDate,
      String transactionNo,
      String idOutlet,
      String outletName,
      String shiftId,
      double subtotal,
      @JsonKey(fromJson: Converters.dynamicToBool) bool discIsPercent,
      double discOverall,
      double discOverallTotal,
      double discPromotionsTotal,
      double total,
      bool ppnIsInclude,
      double ppn,
      String? taxName,
      double ppnTotal,
      double grandTotal,
      double totalPayment,
      double change,
      String? idCustomer,
      String? customerName,
      String? notes,
      String? personInCharge,
      DateTime? holdAt,
      String createdBy,
      String? createdName,
      List<ItemCart> items,
      List<CartPayment> payments});
}

/// @nodoc
class _$CartCopyWithImpl<$Res, $Val extends Cart>
    implements $CartCopyWith<$Res> {
  _$CartCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? transactionDate = null,
    Object? transactionNo = null,
    Object? idOutlet = null,
    Object? outletName = null,
    Object? shiftId = null,
    Object? subtotal = null,
    Object? discIsPercent = null,
    Object? discOverall = null,
    Object? discOverallTotal = null,
    Object? discPromotionsTotal = null,
    Object? total = null,
    Object? ppnIsInclude = null,
    Object? ppn = null,
    Object? taxName = freezed,
    Object? ppnTotal = null,
    Object? grandTotal = null,
    Object? totalPayment = null,
    Object? change = null,
    Object? idCustomer = freezed,
    Object? customerName = freezed,
    Object? notes = freezed,
    Object? personInCharge = freezed,
    Object? holdAt = freezed,
    Object? createdBy = null,
    Object? createdName = freezed,
    Object? items = null,
    Object? payments = null,
  }) {
    return _then(_value.copyWith(
      transactionDate: null == transactionDate
          ? _value.transactionDate
          : transactionDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      transactionNo: null == transactionNo
          ? _value.transactionNo
          : transactionNo // ignore: cast_nullable_to_non_nullable
              as String,
      idOutlet: null == idOutlet
          ? _value.idOutlet
          : idOutlet // ignore: cast_nullable_to_non_nullable
              as String,
      outletName: null == outletName
          ? _value.outletName
          : outletName // ignore: cast_nullable_to_non_nullable
              as String,
      shiftId: null == shiftId
          ? _value.shiftId
          : shiftId // ignore: cast_nullable_to_non_nullable
              as String,
      subtotal: null == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double,
      discIsPercent: null == discIsPercent
          ? _value.discIsPercent
          : discIsPercent // ignore: cast_nullable_to_non_nullable
              as bool,
      discOverall: null == discOverall
          ? _value.discOverall
          : discOverall // ignore: cast_nullable_to_non_nullable
              as double,
      discOverallTotal: null == discOverallTotal
          ? _value.discOverallTotal
          : discOverallTotal // ignore: cast_nullable_to_non_nullable
              as double,
      discPromotionsTotal: null == discPromotionsTotal
          ? _value.discPromotionsTotal
          : discPromotionsTotal // ignore: cast_nullable_to_non_nullable
              as double,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
      ppnIsInclude: null == ppnIsInclude
          ? _value.ppnIsInclude
          : ppnIsInclude // ignore: cast_nullable_to_non_nullable
              as bool,
      ppn: null == ppn
          ? _value.ppn
          : ppn // ignore: cast_nullable_to_non_nullable
              as double,
      taxName: freezed == taxName
          ? _value.taxName
          : taxName // ignore: cast_nullable_to_non_nullable
              as String?,
      ppnTotal: null == ppnTotal
          ? _value.ppnTotal
          : ppnTotal // ignore: cast_nullable_to_non_nullable
              as double,
      grandTotal: null == grandTotal
          ? _value.grandTotal
          : grandTotal // ignore: cast_nullable_to_non_nullable
              as double,
      totalPayment: null == totalPayment
          ? _value.totalPayment
          : totalPayment // ignore: cast_nullable_to_non_nullable
              as double,
      change: null == change
          ? _value.change
          : change // ignore: cast_nullable_to_non_nullable
              as double,
      idCustomer: freezed == idCustomer
          ? _value.idCustomer
          : idCustomer // ignore: cast_nullable_to_non_nullable
              as String?,
      customerName: freezed == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      personInCharge: freezed == personInCharge
          ? _value.personInCharge
          : personInCharge // ignore: cast_nullable_to_non_nullable
              as String?,
      holdAt: freezed == holdAt
          ? _value.holdAt
          : holdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      createdName: freezed == createdName
          ? _value.createdName
          : createdName // ignore: cast_nullable_to_non_nullable
              as String?,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<ItemCart>,
      payments: null == payments
          ? _value.payments
          : payments // ignore: cast_nullable_to_non_nullable
              as List<CartPayment>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CartImplCopyWith<$Res> implements $CartCopyWith<$Res> {
  factory _$$CartImplCopyWith(
          _$CartImpl value, $Res Function(_$CartImpl) then) =
      __$$CartImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime transactionDate,
      String transactionNo,
      String idOutlet,
      String outletName,
      String shiftId,
      double subtotal,
      @JsonKey(fromJson: Converters.dynamicToBool) bool discIsPercent,
      double discOverall,
      double discOverallTotal,
      double discPromotionsTotal,
      double total,
      bool ppnIsInclude,
      double ppn,
      String? taxName,
      double ppnTotal,
      double grandTotal,
      double totalPayment,
      double change,
      String? idCustomer,
      String? customerName,
      String? notes,
      String? personInCharge,
      DateTime? holdAt,
      String createdBy,
      String? createdName,
      List<ItemCart> items,
      List<CartPayment> payments});
}

/// @nodoc
class __$$CartImplCopyWithImpl<$Res>
    extends _$CartCopyWithImpl<$Res, _$CartImpl>
    implements _$$CartImplCopyWith<$Res> {
  __$$CartImplCopyWithImpl(_$CartImpl _value, $Res Function(_$CartImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? transactionDate = null,
    Object? transactionNo = null,
    Object? idOutlet = null,
    Object? outletName = null,
    Object? shiftId = null,
    Object? subtotal = null,
    Object? discIsPercent = null,
    Object? discOverall = null,
    Object? discOverallTotal = null,
    Object? discPromotionsTotal = null,
    Object? total = null,
    Object? ppnIsInclude = null,
    Object? ppn = null,
    Object? taxName = freezed,
    Object? ppnTotal = null,
    Object? grandTotal = null,
    Object? totalPayment = null,
    Object? change = null,
    Object? idCustomer = freezed,
    Object? customerName = freezed,
    Object? notes = freezed,
    Object? personInCharge = freezed,
    Object? holdAt = freezed,
    Object? createdBy = null,
    Object? createdName = freezed,
    Object? items = null,
    Object? payments = null,
  }) {
    return _then(_$CartImpl(
      transactionDate: null == transactionDate
          ? _value.transactionDate
          : transactionDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      transactionNo: null == transactionNo
          ? _value.transactionNo
          : transactionNo // ignore: cast_nullable_to_non_nullable
              as String,
      idOutlet: null == idOutlet
          ? _value.idOutlet
          : idOutlet // ignore: cast_nullable_to_non_nullable
              as String,
      outletName: null == outletName
          ? _value.outletName
          : outletName // ignore: cast_nullable_to_non_nullable
              as String,
      shiftId: null == shiftId
          ? _value.shiftId
          : shiftId // ignore: cast_nullable_to_non_nullable
              as String,
      subtotal: null == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double,
      discIsPercent: null == discIsPercent
          ? _value.discIsPercent
          : discIsPercent // ignore: cast_nullable_to_non_nullable
              as bool,
      discOverall: null == discOverall
          ? _value.discOverall
          : discOverall // ignore: cast_nullable_to_non_nullable
              as double,
      discOverallTotal: null == discOverallTotal
          ? _value.discOverallTotal
          : discOverallTotal // ignore: cast_nullable_to_non_nullable
              as double,
      discPromotionsTotal: null == discPromotionsTotal
          ? _value.discPromotionsTotal
          : discPromotionsTotal // ignore: cast_nullable_to_non_nullable
              as double,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
      ppnIsInclude: null == ppnIsInclude
          ? _value.ppnIsInclude
          : ppnIsInclude // ignore: cast_nullable_to_non_nullable
              as bool,
      ppn: null == ppn
          ? _value.ppn
          : ppn // ignore: cast_nullable_to_non_nullable
              as double,
      taxName: freezed == taxName
          ? _value.taxName
          : taxName // ignore: cast_nullable_to_non_nullable
              as String?,
      ppnTotal: null == ppnTotal
          ? _value.ppnTotal
          : ppnTotal // ignore: cast_nullable_to_non_nullable
              as double,
      grandTotal: null == grandTotal
          ? _value.grandTotal
          : grandTotal // ignore: cast_nullable_to_non_nullable
              as double,
      totalPayment: null == totalPayment
          ? _value.totalPayment
          : totalPayment // ignore: cast_nullable_to_non_nullable
              as double,
      change: null == change
          ? _value.change
          : change // ignore: cast_nullable_to_non_nullable
              as double,
      idCustomer: freezed == idCustomer
          ? _value.idCustomer
          : idCustomer // ignore: cast_nullable_to_non_nullable
              as String?,
      customerName: freezed == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      personInCharge: freezed == personInCharge
          ? _value.personInCharge
          : personInCharge // ignore: cast_nullable_to_non_nullable
              as String?,
      holdAt: freezed == holdAt
          ? _value.holdAt
          : holdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      createdName: freezed == createdName
          ? _value.createdName
          : createdName // ignore: cast_nullable_to_non_nullable
              as String?,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<ItemCart>,
      payments: null == payments
          ? _value._payments
          : payments // ignore: cast_nullable_to_non_nullable
              as List<CartPayment>,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$CartImpl extends _Cart {
  const _$CartImpl(
      {required this.transactionDate,
      required this.transactionNo,
      required this.idOutlet,
      required this.outletName,
      required this.shiftId,
      required this.subtotal,
      @JsonKey(fromJson: Converters.dynamicToBool) required this.discIsPercent,
      required this.discOverall,
      required this.discOverallTotal,
      required this.discPromotionsTotal,
      required this.total,
      required this.ppnIsInclude,
      required this.ppn,
      this.taxName,
      required this.ppnTotal,
      required this.grandTotal,
      required this.totalPayment,
      required this.change,
      this.idCustomer,
      this.customerName,
      this.notes,
      this.personInCharge,
      this.holdAt,
      required this.createdBy,
      this.createdName,
      required final List<ItemCart> items,
      required final List<CartPayment> payments})
      : _items = items,
        _payments = payments,
        super._();

  factory _$CartImpl.fromJson(Map<String, dynamic> json) =>
      _$$CartImplFromJson(json);

  @override
  final DateTime transactionDate;
  @override
  final String transactionNo;
  @override
  final String idOutlet;
  @override
  final String outletName;
  @override
  final String shiftId;
  @override
  final double subtotal;
  @override
  @JsonKey(fromJson: Converters.dynamicToBool)
  final bool discIsPercent;
  @override
  final double discOverall;
  @override
  final double discOverallTotal;
  @override
  final double discPromotionsTotal;
  @override
  final double total;
  @override
  final bool ppnIsInclude;
  @override
  final double ppn;
  @override
  final String? taxName;
  @override
  final double ppnTotal;
  @override
  final double grandTotal;
  @override
  final double totalPayment;
  @override
  final double change;
  @override
  final String? idCustomer;
  @override
  final String? customerName;
  @override
  final String? notes;
  @override
  final String? personInCharge;
  @override
  final DateTime? holdAt;
  @override
  final String createdBy;
  @override
  final String? createdName;
  final List<ItemCart> _items;
  @override
  List<ItemCart> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  final List<CartPayment> _payments;
  @override
  List<CartPayment> get payments {
    if (_payments is EqualUnmodifiableListView) return _payments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_payments);
  }

  @override
  String toString() {
    return 'Cart(transactionDate: $transactionDate, transactionNo: $transactionNo, idOutlet: $idOutlet, outletName: $outletName, shiftId: $shiftId, subtotal: $subtotal, discIsPercent: $discIsPercent, discOverall: $discOverall, discOverallTotal: $discOverallTotal, discPromotionsTotal: $discPromotionsTotal, total: $total, ppnIsInclude: $ppnIsInclude, ppn: $ppn, taxName: $taxName, ppnTotal: $ppnTotal, grandTotal: $grandTotal, totalPayment: $totalPayment, change: $change, idCustomer: $idCustomer, customerName: $customerName, notes: $notes, personInCharge: $personInCharge, holdAt: $holdAt, createdBy: $createdBy, createdName: $createdName, items: $items, payments: $payments)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CartImpl &&
            (identical(other.transactionDate, transactionDate) ||
                other.transactionDate == transactionDate) &&
            (identical(other.transactionNo, transactionNo) ||
                other.transactionNo == transactionNo) &&
            (identical(other.idOutlet, idOutlet) ||
                other.idOutlet == idOutlet) &&
            (identical(other.outletName, outletName) ||
                other.outletName == outletName) &&
            (identical(other.shiftId, shiftId) || other.shiftId == shiftId) &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal) &&
            (identical(other.discIsPercent, discIsPercent) ||
                other.discIsPercent == discIsPercent) &&
            (identical(other.discOverall, discOverall) ||
                other.discOverall == discOverall) &&
            (identical(other.discOverallTotal, discOverallTotal) ||
                other.discOverallTotal == discOverallTotal) &&
            (identical(other.discPromotionsTotal, discPromotionsTotal) ||
                other.discPromotionsTotal == discPromotionsTotal) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.ppnIsInclude, ppnIsInclude) ||
                other.ppnIsInclude == ppnIsInclude) &&
            (identical(other.ppn, ppn) || other.ppn == ppn) &&
            (identical(other.taxName, taxName) || other.taxName == taxName) &&
            (identical(other.ppnTotal, ppnTotal) ||
                other.ppnTotal == ppnTotal) &&
            (identical(other.grandTotal, grandTotal) ||
                other.grandTotal == grandTotal) &&
            (identical(other.totalPayment, totalPayment) ||
                other.totalPayment == totalPayment) &&
            (identical(other.change, change) || other.change == change) &&
            (identical(other.idCustomer, idCustomer) ||
                other.idCustomer == idCustomer) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.personInCharge, personInCharge) ||
                other.personInCharge == personInCharge) &&
            (identical(other.holdAt, holdAt) || other.holdAt == holdAt) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.createdName, createdName) ||
                other.createdName == createdName) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            const DeepCollectionEquality().equals(other._payments, _payments));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        transactionDate,
        transactionNo,
        idOutlet,
        outletName,
        shiftId,
        subtotal,
        discIsPercent,
        discOverall,
        discOverallTotal,
        discPromotionsTotal,
        total,
        ppnIsInclude,
        ppn,
        taxName,
        ppnTotal,
        grandTotal,
        totalPayment,
        change,
        idCustomer,
        customerName,
        notes,
        personInCharge,
        holdAt,
        createdBy,
        createdName,
        const DeepCollectionEquality().hash(_items),
        const DeepCollectionEquality().hash(_payments)
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CartImplCopyWith<_$CartImpl> get copyWith =>
      __$$CartImplCopyWithImpl<_$CartImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CartImplToJson(
      this,
    );
  }
}

abstract class _Cart extends Cart {
  const factory _Cart(
      {required final DateTime transactionDate,
      required final String transactionNo,
      required final String idOutlet,
      required final String outletName,
      required final String shiftId,
      required final double subtotal,
      @JsonKey(fromJson: Converters.dynamicToBool)
      required final bool discIsPercent,
      required final double discOverall,
      required final double discOverallTotal,
      required final double discPromotionsTotal,
      required final double total,
      required final bool ppnIsInclude,
      required final double ppn,
      final String? taxName,
      required final double ppnTotal,
      required final double grandTotal,
      required final double totalPayment,
      required final double change,
      final String? idCustomer,
      final String? customerName,
      final String? notes,
      final String? personInCharge,
      final DateTime? holdAt,
      required final String createdBy,
      final String? createdName,
      required final List<ItemCart> items,
      required final List<CartPayment> payments}) = _$CartImpl;
  const _Cart._() : super._();

  factory _Cart.fromJson(Map<String, dynamic> json) = _$CartImpl.fromJson;

  @override
  DateTime get transactionDate;
  @override
  String get transactionNo;
  @override
  String get idOutlet;
  @override
  String get outletName;
  @override
  String get shiftId;
  @override
  double get subtotal;
  @override
  @JsonKey(fromJson: Converters.dynamicToBool)
  bool get discIsPercent;
  @override
  double get discOverall;
  @override
  double get discOverallTotal;
  @override
  double get discPromotionsTotal;
  @override
  double get total;
  @override
  bool get ppnIsInclude;
  @override
  double get ppn;
  @override
  String? get taxName;
  @override
  double get ppnTotal;
  @override
  double get grandTotal;
  @override
  double get totalPayment;
  @override
  double get change;
  @override
  String? get idCustomer;
  @override
  String? get customerName;
  @override
  String? get notes;
  @override
  String? get personInCharge;
  @override
  DateTime? get holdAt;
  @override
  String get createdBy;
  @override
  String? get createdName;
  @override
  List<ItemCart> get items;
  @override
  List<CartPayment> get payments;
  @override
  @JsonKey(ignore: true)
  _$$CartImplCopyWith<_$CartImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
