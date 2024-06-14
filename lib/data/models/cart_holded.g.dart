// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_holded.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CartHoldedImpl _$$CartHoldedImplFromJson(Map<String, dynamic> json) =>
    _$CartHoldedImpl(
      transactionId: json['transaction_id'] as String,
      idOutlet: json['id_outlet'] as String,
      shiftId: json['shift_id'] as String,
      transactionDate: json['transaction_date'] as String,
      transactionNo: json['transaction_no'] as String,
      idCustomer: json['id_customer'] as String?,
      customerName: json['customer_name'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      createdName: json['created_name'] as String?,
      description: json['description'] as String?,
      dataHold: Cart.fromDataHold(json['data_hold'] as String),
    );

Map<String, dynamic> _$$CartHoldedImplToJson(_$CartHoldedImpl instance) =>
    <String, dynamic>{
      'transaction_id': instance.transactionId,
      'id_outlet': instance.idOutlet,
      'shift_id': instance.shiftId,
      'transaction_date': instance.transactionDate,
      'transaction_no': instance.transactionNo,
      'id_customer': instance.idCustomer,
      'customer_name': instance.customerName,
      'created_at': instance.createdAt.toIso8601String(),
      'created_name': instance.createdName,
      'description': instance.description,
      'data_hold': instance.dataHold,
    };
