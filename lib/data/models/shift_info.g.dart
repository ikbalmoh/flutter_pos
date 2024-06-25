// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ShiftInfoImpl _$$ShiftInfoImplFromJson(Map<String, dynamic> json) =>
    _$ShiftInfoImpl(
      codeShift: json['code_shift'] as String,
      deviceName: json['device_name'] as String?,
      outletId: json['outlet_id'] as String,
      outletName: json['outlet_name'] as String?,
      openedBy: json['opened_by'] as String,
      closedBy: json['closed_by'] as String?,
      openShift: DateTime.parse(json['open_shift'] as String),
      closeShift:
          DateTimeFormater.stringToDateTime(json['close_shift'] as String),
      saldoKas: (json['saldo_kas'] as num).toDouble(),
      selisih: (json['selisih'] as num).toDouble(),
      cashFlows:
          ShiftCashFlows.fromJson(json['cash_flows'] as Map<String, dynamic>),
      summary: ShiftSummary.fromJson(json['summary'] as Map<String, dynamic>),
      soldItems: (json['sold_items'] as List<dynamic>)
          .map((e) => SoldItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      refundItems: json['refund_items'] as List<dynamic>,
      attachments: json['attachments'] as List<dynamic>,
    );

Map<String, dynamic> _$$ShiftInfoImplToJson(_$ShiftInfoImpl instance) =>
    <String, dynamic>{
      'code_shift': instance.codeShift,
      'device_name': instance.deviceName,
      'outlet_id': instance.outletId,
      'outlet_name': instance.outletName,
      'opened_by': instance.openedBy,
      'closed_by': instance.closedBy,
      'open_shift': instance.openShift.toIso8601String(),
      'close_shift': instance.closeShift?.toIso8601String(),
      'saldo_kas': instance.saldoKas,
      'selisih': instance.selisih,
      'cash_flows': instance.cashFlows,
      'summary': instance.summary,
      'sold_items': instance.soldItems,
      'refund_items': instance.refundItems,
      'attachments': instance.attachments,
    };
