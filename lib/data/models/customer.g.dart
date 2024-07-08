// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CustomerImpl _$$CustomerImplFromJson(Map<String, dynamic> json) =>
    _$CustomerImpl(
      idCustomer: json['id_customer'] as String,
      code: json['code'] as String,
      customerName: json['customer_name'] as String,
      barcode: json['barcode'] as String?,
      dob: json['dob'] as String?,
      email: json['email'] as String?,
      npwp: json['npwp'] as String?,
      phoneNumber: json['phone_number'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      province: json['province'] as String?,
      postalCode: json['postal_code'] as String?,
      createdBy: json['created_by'] as String?,
      updatedBy: json['updated_by'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      cardId: (json['card_id'] as num?)?.toInt(),
      cardIdNumber: json['card_id_number'] as String?,
      isMember: json['is_member'] as bool?,
      expiredDate: json['expired_date'] == null
          ? null
          : DateTime.parse(json['expired_date'] as String),
      groupNames: json['group_names'] as String?,
      groups: (json['groups'] as List<dynamic>?)
          ?.map((e) => CustomerGroup.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$CustomerImplToJson(_$CustomerImpl instance) =>
    <String, dynamic>{
      'id_customer': instance.idCustomer,
      'code': instance.code,
      'customer_name': instance.customerName,
      'barcode': instance.barcode,
      'dob': instance.dob,
      'email': instance.email,
      'npwp': instance.npwp,
      'phone_number': instance.phoneNumber,
      'address': instance.address,
      'city': instance.city,
      'province': instance.province,
      'postal_code': instance.postalCode,
      'created_by': instance.createdBy,
      'updated_by': instance.updatedBy,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'card_id': instance.cardId,
      'card_id_number': instance.cardIdNumber,
      'is_member': instance.isMember,
      'expired_date': instance.expiredDate?.toIso8601String(),
      'group_names': instance.groupNames,
      'groups': instance.groups?.map((e) => e.toJson()).toList(),
    };
