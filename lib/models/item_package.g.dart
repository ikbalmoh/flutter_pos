// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_package.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemPackage _$ItemPackageFromJson(Map<String, dynamic> json) => ItemPackage(
      id: json['id'] as int,
      idItem: json['id_item'] as String,
      itemName: json['item_name'] as String,
      variantId: json['variant_id'] as int,
      quantityItem: json['quantity_item'] as int,
      itemPrice: Converters.dynamicToDouble(json['item_price']),
    );

Map<String, dynamic> _$ItemPackageToJson(ItemPackage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'id_item': instance.idItem,
      'item_name': instance.itemName,
      'variant_id': instance.variantId,
      'quantity_item': instance.quantityItem,
      'item_price': instance.itemPrice,
    };
