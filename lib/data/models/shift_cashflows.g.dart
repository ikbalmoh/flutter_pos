// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift_cashflows.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ShiftCashFlowsImpl _$$ShiftCashFlowsImplFromJson(Map<String, dynamic> json) =>
    _$ShiftCashFlowsImpl(
      data: (json['data'] as List<dynamic>)
          .map((e) => ShiftCashflow.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toDouble(),
    );

Map<String, dynamic> _$$ShiftCashFlowsImplToJson(
        _$ShiftCashFlowsImpl instance) =>
    <String, dynamic>{
      'data': instance.data.map((e) => e.toJson()).toList(),
      'total': instance.total,
    };
