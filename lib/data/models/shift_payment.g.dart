// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift_payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ShiftPaymentImpl _$$ShiftPaymentImplFromJson(Map<String, dynamic> json) =>
    _$ShiftPaymentImpl(
      paymentMethodId: json['payment_method_id'] as String,
      paymentName: json['payment_name'] as String,
      value: (json['value'] as num).toDouble(),
    );

Map<String, dynamic> _$$ShiftPaymentImplToJson(_$ShiftPaymentImpl instance) =>
    <String, dynamic>{
      'payment_method_id': instance.paymentMethodId,
      'payment_name': instance.paymentName,
      'value': instance.value,
    };
