// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sold_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SoldItemImpl _$$SoldItemImplFromJson(Map<String, dynamic> json) =>
    _$SoldItemImpl(
      idItem: json['id_item'] as String,
      name: json['name'] as String,
      sold: Converters.dynamicToDouble(json['sold']),
    );

Map<String, dynamic> _$$SoldItemImplToJson(_$SoldItemImpl instance) =>
    <String, dynamic>{
      'id_item': instance.idItem,
      'name': instance.name,
      'sold': instance.sold,
    };
