// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shift_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ShiftInfo _$ShiftInfoFromJson(Map<String, dynamic> json) {
  return _ShiftInfo.fromJson(json);
}

/// @nodoc
mixin _$ShiftInfo {
  String get codeShift => throw _privateConstructorUsedError;
  String? get deviceName => throw _privateConstructorUsedError;
  String get outletId => throw _privateConstructorUsedError;
  String? get outletName => throw _privateConstructorUsedError;
  String get openedBy => throw _privateConstructorUsedError;
  String? get closedBy => throw _privateConstructorUsedError;
  DateTime get openShift => throw _privateConstructorUsedError;
  String? get closeShift => throw _privateConstructorUsedError;
  double get saldoKas => throw _privateConstructorUsedError;
  double get selisih => throw _privateConstructorUsedError;
  ShiftCashFlows get cashFlows => throw _privateConstructorUsedError;
  ShiftSummary get summary => throw _privateConstructorUsedError;
  List<SoldItem> get soldItems => throw _privateConstructorUsedError;
  List<dynamic> get refundItems => throw _privateConstructorUsedError;
  List<dynamic> get attachments => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ShiftInfoCopyWith<ShiftInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShiftInfoCopyWith<$Res> {
  factory $ShiftInfoCopyWith(ShiftInfo value, $Res Function(ShiftInfo) then) =
      _$ShiftInfoCopyWithImpl<$Res, ShiftInfo>;
  @useResult
  $Res call(
      {String codeShift,
      String? deviceName,
      String outletId,
      String? outletName,
      String openedBy,
      String? closedBy,
      DateTime openShift,
      String? closeShift,
      double saldoKas,
      double selisih,
      ShiftCashFlows cashFlows,
      ShiftSummary summary,
      List<SoldItem> soldItems,
      List<dynamic> refundItems,
      List<dynamic> attachments});

  $ShiftCashFlowsCopyWith<$Res> get cashFlows;
  $ShiftSummaryCopyWith<$Res> get summary;
}

/// @nodoc
class _$ShiftInfoCopyWithImpl<$Res, $Val extends ShiftInfo>
    implements $ShiftInfoCopyWith<$Res> {
  _$ShiftInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? codeShift = null,
    Object? deviceName = freezed,
    Object? outletId = null,
    Object? outletName = freezed,
    Object? openedBy = null,
    Object? closedBy = freezed,
    Object? openShift = null,
    Object? closeShift = freezed,
    Object? saldoKas = null,
    Object? selisih = null,
    Object? cashFlows = null,
    Object? summary = null,
    Object? soldItems = null,
    Object? refundItems = null,
    Object? attachments = null,
  }) {
    return _then(_value.copyWith(
      codeShift: null == codeShift
          ? _value.codeShift
          : codeShift // ignore: cast_nullable_to_non_nullable
              as String,
      deviceName: freezed == deviceName
          ? _value.deviceName
          : deviceName // ignore: cast_nullable_to_non_nullable
              as String?,
      outletId: null == outletId
          ? _value.outletId
          : outletId // ignore: cast_nullable_to_non_nullable
              as String,
      outletName: freezed == outletName
          ? _value.outletName
          : outletName // ignore: cast_nullable_to_non_nullable
              as String?,
      openedBy: null == openedBy
          ? _value.openedBy
          : openedBy // ignore: cast_nullable_to_non_nullable
              as String,
      closedBy: freezed == closedBy
          ? _value.closedBy
          : closedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      openShift: null == openShift
          ? _value.openShift
          : openShift // ignore: cast_nullable_to_non_nullable
              as DateTime,
      closeShift: freezed == closeShift
          ? _value.closeShift
          : closeShift // ignore: cast_nullable_to_non_nullable
              as String?,
      saldoKas: null == saldoKas
          ? _value.saldoKas
          : saldoKas // ignore: cast_nullable_to_non_nullable
              as double,
      selisih: null == selisih
          ? _value.selisih
          : selisih // ignore: cast_nullable_to_non_nullable
              as double,
      cashFlows: null == cashFlows
          ? _value.cashFlows
          : cashFlows // ignore: cast_nullable_to_non_nullable
              as ShiftCashFlows,
      summary: null == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as ShiftSummary,
      soldItems: null == soldItems
          ? _value.soldItems
          : soldItems // ignore: cast_nullable_to_non_nullable
              as List<SoldItem>,
      refundItems: null == refundItems
          ? _value.refundItems
          : refundItems // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      attachments: null == attachments
          ? _value.attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ShiftCashFlowsCopyWith<$Res> get cashFlows {
    return $ShiftCashFlowsCopyWith<$Res>(_value.cashFlows, (value) {
      return _then(_value.copyWith(cashFlows: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $ShiftSummaryCopyWith<$Res> get summary {
    return $ShiftSummaryCopyWith<$Res>(_value.summary, (value) {
      return _then(_value.copyWith(summary: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ShiftInfoImplCopyWith<$Res>
    implements $ShiftInfoCopyWith<$Res> {
  factory _$$ShiftInfoImplCopyWith(
          _$ShiftInfoImpl value, $Res Function(_$ShiftInfoImpl) then) =
      __$$ShiftInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String codeShift,
      String? deviceName,
      String outletId,
      String? outletName,
      String openedBy,
      String? closedBy,
      DateTime openShift,
      String? closeShift,
      double saldoKas,
      double selisih,
      ShiftCashFlows cashFlows,
      ShiftSummary summary,
      List<SoldItem> soldItems,
      List<dynamic> refundItems,
      List<dynamic> attachments});

  @override
  $ShiftCashFlowsCopyWith<$Res> get cashFlows;
  @override
  $ShiftSummaryCopyWith<$Res> get summary;
}

/// @nodoc
class __$$ShiftInfoImplCopyWithImpl<$Res>
    extends _$ShiftInfoCopyWithImpl<$Res, _$ShiftInfoImpl>
    implements _$$ShiftInfoImplCopyWith<$Res> {
  __$$ShiftInfoImplCopyWithImpl(
      _$ShiftInfoImpl _value, $Res Function(_$ShiftInfoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? codeShift = null,
    Object? deviceName = freezed,
    Object? outletId = null,
    Object? outletName = freezed,
    Object? openedBy = null,
    Object? closedBy = freezed,
    Object? openShift = null,
    Object? closeShift = freezed,
    Object? saldoKas = null,
    Object? selisih = null,
    Object? cashFlows = null,
    Object? summary = null,
    Object? soldItems = null,
    Object? refundItems = null,
    Object? attachments = null,
  }) {
    return _then(_$ShiftInfoImpl(
      codeShift: null == codeShift
          ? _value.codeShift
          : codeShift // ignore: cast_nullable_to_non_nullable
              as String,
      deviceName: freezed == deviceName
          ? _value.deviceName
          : deviceName // ignore: cast_nullable_to_non_nullable
              as String?,
      outletId: null == outletId
          ? _value.outletId
          : outletId // ignore: cast_nullable_to_non_nullable
              as String,
      outletName: freezed == outletName
          ? _value.outletName
          : outletName // ignore: cast_nullable_to_non_nullable
              as String?,
      openedBy: null == openedBy
          ? _value.openedBy
          : openedBy // ignore: cast_nullable_to_non_nullable
              as String,
      closedBy: freezed == closedBy
          ? _value.closedBy
          : closedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      openShift: null == openShift
          ? _value.openShift
          : openShift // ignore: cast_nullable_to_non_nullable
              as DateTime,
      closeShift: freezed == closeShift
          ? _value.closeShift
          : closeShift // ignore: cast_nullable_to_non_nullable
              as String?,
      saldoKas: null == saldoKas
          ? _value.saldoKas
          : saldoKas // ignore: cast_nullable_to_non_nullable
              as double,
      selisih: null == selisih
          ? _value.selisih
          : selisih // ignore: cast_nullable_to_non_nullable
              as double,
      cashFlows: null == cashFlows
          ? _value.cashFlows
          : cashFlows // ignore: cast_nullable_to_non_nullable
              as ShiftCashFlows,
      summary: null == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as ShiftSummary,
      soldItems: null == soldItems
          ? _value._soldItems
          : soldItems // ignore: cast_nullable_to_non_nullable
              as List<SoldItem>,
      refundItems: null == refundItems
          ? _value._refundItems
          : refundItems // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      attachments: null == attachments
          ? _value._attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$ShiftInfoImpl implements _ShiftInfo {
  const _$ShiftInfoImpl(
      {required this.codeShift,
      this.deviceName,
      required this.outletId,
      this.outletName,
      required this.openedBy,
      this.closedBy,
      required this.openShift,
      this.closeShift,
      required this.saldoKas,
      required this.selisih,
      required this.cashFlows,
      required this.summary,
      required final List<SoldItem> soldItems,
      required final List<dynamic> refundItems,
      required final List<dynamic> attachments})
      : _soldItems = soldItems,
        _refundItems = refundItems,
        _attachments = attachments;

  factory _$ShiftInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShiftInfoImplFromJson(json);

  @override
  final String codeShift;
  @override
  final String? deviceName;
  @override
  final String outletId;
  @override
  final String? outletName;
  @override
  final String openedBy;
  @override
  final String? closedBy;
  @override
  final DateTime openShift;
  @override
  final String? closeShift;
  @override
  final double saldoKas;
  @override
  final double selisih;
  @override
  final ShiftCashFlows cashFlows;
  @override
  final ShiftSummary summary;
  final List<SoldItem> _soldItems;
  @override
  List<SoldItem> get soldItems {
    if (_soldItems is EqualUnmodifiableListView) return _soldItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_soldItems);
  }

  final List<dynamic> _refundItems;
  @override
  List<dynamic> get refundItems {
    if (_refundItems is EqualUnmodifiableListView) return _refundItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_refundItems);
  }

  final List<dynamic> _attachments;
  @override
  List<dynamic> get attachments {
    if (_attachments is EqualUnmodifiableListView) return _attachments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_attachments);
  }

  @override
  String toString() {
    return 'ShiftInfo(codeShift: $codeShift, deviceName: $deviceName, outletId: $outletId, outletName: $outletName, openedBy: $openedBy, closedBy: $closedBy, openShift: $openShift, closeShift: $closeShift, saldoKas: $saldoKas, selisih: $selisih, cashFlows: $cashFlows, summary: $summary, soldItems: $soldItems, refundItems: $refundItems, attachments: $attachments)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShiftInfoImpl &&
            (identical(other.codeShift, codeShift) ||
                other.codeShift == codeShift) &&
            (identical(other.deviceName, deviceName) ||
                other.deviceName == deviceName) &&
            (identical(other.outletId, outletId) ||
                other.outletId == outletId) &&
            (identical(other.outletName, outletName) ||
                other.outletName == outletName) &&
            (identical(other.openedBy, openedBy) ||
                other.openedBy == openedBy) &&
            (identical(other.closedBy, closedBy) ||
                other.closedBy == closedBy) &&
            (identical(other.openShift, openShift) ||
                other.openShift == openShift) &&
            (identical(other.closeShift, closeShift) ||
                other.closeShift == closeShift) &&
            (identical(other.saldoKas, saldoKas) ||
                other.saldoKas == saldoKas) &&
            (identical(other.selisih, selisih) || other.selisih == selisih) &&
            (identical(other.cashFlows, cashFlows) ||
                other.cashFlows == cashFlows) &&
            (identical(other.summary, summary) || other.summary == summary) &&
            const DeepCollectionEquality()
                .equals(other._soldItems, _soldItems) &&
            const DeepCollectionEquality()
                .equals(other._refundItems, _refundItems) &&
            const DeepCollectionEquality()
                .equals(other._attachments, _attachments));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      codeShift,
      deviceName,
      outletId,
      outletName,
      openedBy,
      closedBy,
      openShift,
      closeShift,
      saldoKas,
      selisih,
      cashFlows,
      summary,
      const DeepCollectionEquality().hash(_soldItems),
      const DeepCollectionEquality().hash(_refundItems),
      const DeepCollectionEquality().hash(_attachments));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ShiftInfoImplCopyWith<_$ShiftInfoImpl> get copyWith =>
      __$$ShiftInfoImplCopyWithImpl<_$ShiftInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ShiftInfoImplToJson(
      this,
    );
  }
}

abstract class _ShiftInfo implements ShiftInfo {
  const factory _ShiftInfo(
      {required final String codeShift,
      final String? deviceName,
      required final String outletId,
      final String? outletName,
      required final String openedBy,
      final String? closedBy,
      required final DateTime openShift,
      final String? closeShift,
      required final double saldoKas,
      required final double selisih,
      required final ShiftCashFlows cashFlows,
      required final ShiftSummary summary,
      required final List<SoldItem> soldItems,
      required final List<dynamic> refundItems,
      required final List<dynamic> attachments}) = _$ShiftInfoImpl;

  factory _ShiftInfo.fromJson(Map<String, dynamic> json) =
      _$ShiftInfoImpl.fromJson;

  @override
  String get codeShift;
  @override
  String? get deviceName;
  @override
  String get outletId;
  @override
  String? get outletName;
  @override
  String get openedBy;
  @override
  String? get closedBy;
  @override
  DateTime get openShift;
  @override
  String? get closeShift;
  @override
  double get saldoKas;
  @override
  double get selisih;
  @override
  ShiftCashFlows get cashFlows;
  @override
  ShiftSummary get summary;
  @override
  List<SoldItem> get soldItems;
  @override
  List<dynamic> get refundItems;
  @override
  List<dynamic> get attachments;
  @override
  @JsonKey(ignore: true)
  _$$ShiftInfoImplCopyWith<_$ShiftInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
