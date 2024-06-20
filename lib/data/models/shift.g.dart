// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ShiftImpl _$$ShiftImplFromJson(Map<String, dynamic> json) => _$ShiftImpl(
      id: json['id'] as String,
      outletId: json['outlet_id'] as String,
      deviceId: json['device_id'] as String,
      startShift: DateTime.parse(json['start_shift'] as String),
      openAmount: (json['open_amount'] as num).toDouble(),
      createdBy: json['created_by'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      outletName: json['outlet_name'] as String,
      createdName: json['created_name'] as String,
      codeShift: json['code_shift'] as String?,
      closeShift: json['close_shift'] == null
          ? null
          : DateTime.parse(json['close_shift'] as String),
      customSalesAmount: (json['custom_sales_amount'] as num?)?.toInt(),
      updatedBy: json['updated_by'] as String?,
      closeAmount: (json['close_amount'] as num?)?.toDouble(),
      diffAmount: (json['diff_amount'] as num?)?.toDouble(),
      refundAmount: (json['refund_amount'] as num?)?.toDouble(),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      updatedName: json['updated_name'] as String?,
      closedBy: json['closed_by'] as String?,
      income: (json['income'] as num?)?.toDouble(),
      expense: (json['expense'] as num?)?.toDouble(),
      cashSales: (json['cash_sales'] as num?)?.toDouble(),
      debitSalesAmount: (json['debit_sales_amount'] as num?)?.toDouble(),
      debitSales: json['debit_sales'] as List<dynamic>?,
      creditSalesAmount: (json['credit_sales_amount'] as num?)?.toDouble(),
      creditSales: json['credit_sales'] as List<dynamic>?,
      customSales: json['custom_sales'] as List<dynamic>?,
      expectedEnd: (json['expected_end'] as num?)?.toInt(),
      expectedCash: (json['expected_cash'] as num?)?.toInt(),
      sold: (json['sold'] as num?)?.toInt(),
      soldItems: (json['sold_items'] as List<dynamic>?)
          ?.map((e) => SoldItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ShiftImplToJson(_$ShiftImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'outlet_id': instance.outletId,
      'device_id': instance.deviceId,
      'start_shift': instance.startShift.toIso8601String(),
      'open_amount': instance.openAmount,
      'created_by': instance.createdBy,
      'created_at': instance.createdAt.toIso8601String(),
      'outlet_name': instance.outletName,
      'created_name': instance.createdName,
      'code_shift': instance.codeShift,
      'close_shift': instance.closeShift?.toIso8601String(),
      'custom_sales_amount': instance.customSalesAmount,
      'updated_by': instance.updatedBy,
      'close_amount': instance.closeAmount,
      'diff_amount': instance.diffAmount,
      'refund_amount': instance.refundAmount,
      'updated_at': instance.updatedAt?.toIso8601String(),
      'updated_name': instance.updatedName,
      'closed_by': instance.closedBy,
      'income': instance.income,
      'expense': instance.expense,
      'cash_sales': instance.cashSales,
      'debit_sales_amount': instance.debitSalesAmount,
      'debit_sales': instance.debitSales,
      'credit_sales_amount': instance.creditSalesAmount,
      'credit_sales': instance.creditSales,
      'custom_sales': instance.customSales,
      'expected_end': instance.expectedEnd,
      'expected_cash': instance.expectedCash,
      'sold': instance.sold,
      'sold_items': instance.soldItems,
    };
