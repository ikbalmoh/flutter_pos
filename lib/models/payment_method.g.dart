// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_method.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentMethod _$PaymentMethodFromJson(Map<String, dynamic> json) =>
    PaymentMethod(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as int,
      description: json['description'] as String?,
      showCaption: Converters.dynamicToBool(json['show_caption']),
      caption: json['caption'] as String?,
      chargeable: json['chargeable'] as bool?,
      chargeValue: json['charge_value'] as int?,
      namaAkun: json['nama_akun'] as String?,
      bankName: json['bank_name'] as String?,
      typeName: json['type_name'] as String?,
    );

Map<String, dynamic> _$PaymentMethodToJson(PaymentMethod instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'description': instance.description,
      'show_caption': instance.showCaption,
      'caption': instance.caption,
      'chargeable': instance.chargeable,
      'charge_value': instance.chargeValue,
      'nama_akun': instance.namaAkun,
      'bank_name': instance.bankName,
      'type_name': instance.typeName,
    };
