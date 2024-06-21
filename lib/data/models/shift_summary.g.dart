// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ShiftSummaryImpl _$$ShiftSummaryImplFromJson(Map<String, dynamic> json) =>
    _$ShiftSummaryImpl(
      startingCash: (json['starting_cash'] as num).toDouble(),
      cashSales: (json['cash_sales'] as num).toDouble(),
      expense: (json['Expense'] as num).toDouble(),
      income: (json['Income'] as num).toDouble(),
      refunded: (json['Refunded'] as num).toDouble(),
      debitSales: (json['debit_sales'] as List<dynamic>?)
          ?.map((e) => ShiftPayment.fromJson(e as Map<String, dynamic>))
          .toList(),
      creditSales: (json['credit_sales'] as List<dynamic>?)
          ?.map((e) => ShiftPayment.fromJson(e as Map<String, dynamic>))
          .toList(),
      customSales: (json['custom_sales'] as List<dynamic>?)
          ?.map((e) => ShiftPayment.fromJson(e as Map<String, dynamic>))
          .toList(),
      expectedEnd: (json['expected_end'] as num).toDouble(),
      expectedCashEnd: (json['expected_cash_end'] as num).toDouble(),
      actualCash: (json['actual_cash'] as num).toDouble(),
      different: (json['different'] as num).toDouble(),
    );

Map<String, dynamic> _$$ShiftSummaryImplToJson(_$ShiftSummaryImpl instance) =>
    <String, dynamic>{
      'starting_cash': instance.startingCash,
      'cash_sales': instance.cashSales,
      'Expense': instance.expense,
      'Income': instance.income,
      'Refunded': instance.refunded,
      'debit_sales': instance.debitSales,
      'credit_sales': instance.creditSales,
      'custom_sales': instance.customSales,
      'expected_end': instance.expectedEnd,
      'expected_cash_end': instance.expectedCashEnd,
      'actual_cash': instance.actualCash,
      'different': instance.different,
    };
