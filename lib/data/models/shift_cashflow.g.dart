// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift_cashflow.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ShiftCashflowImpl _$$ShiftCashflowImplFromJson(Map<String, dynamic> json) =>
    _$ShiftCashflowImpl(
      id: json['id'] as String,
      codeCf: json['code_cf'] as String,
      transDate: DateTime.parse(json['trans_date'] as String),
      shiftId: json['shift_id'] as String,
      outletId: json['outlet_id'] as String,
      status: (json['status'] as num).toInt(),
      amount: (json['amount'] as num).toDouble(),
      images: (json['images'] as List<dynamic>)
          .map((e) => ShiftCashflowImage.fromJson(e as Map<String, dynamic>))
          .toList(),
      descriptions: json['descriptions'] as String?,
    );

Map<String, dynamic> _$$ShiftCashflowImplToJson(_$ShiftCashflowImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code_cf': instance.codeCf,
      'trans_date': instance.transDate.toIso8601String(),
      'shift_id': instance.shiftId,
      'outlet_id': instance.outletId,
      'status': instance.status,
      'amount': instance.amount,
      'images': instance.images.map((e) => e.toJson()).toList(),
      'descriptions': instance.descriptions,
    };
