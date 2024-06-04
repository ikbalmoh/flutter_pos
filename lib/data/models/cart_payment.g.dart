// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CartPaymentImpl _$$CartPaymentImplFromJson(Map<String, dynamic> json) =>
    _$CartPaymentImpl(
      payDate: (json['pay_date'] as num?)?.toInt(),
      paymentMethodId: json['payment_method_id'] as String,
      paymentname: json['paymentname'] as String,
      paymentValue: (json['payment_value'] as num).toDouble(),
      reference: json['reference'] as String?,
      createdBy: json['created_by'] as String?,
    );

Map<String, dynamic> _$$CartPaymentImplToJson(_$CartPaymentImpl instance) =>
    <String, dynamic>{
      'pay_date': instance.payDate,
      'payment_method_id': instance.paymentMethodId,
      'paymentname': instance.paymentname,
      'payment_value': instance.paymentValue,
      'reference': instance.reference,
      'created_by': instance.createdBy,
    };
