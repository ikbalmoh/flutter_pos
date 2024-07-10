// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_cart_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ItemCartDetailImpl _$$ItemCartDetailImplFromJson(Map<String, dynamic> json) =>
    _$ItemCartDetailImpl(
      itemId: json['item_id'] as String,
      name: json['name'] as String,
      variantId: (json['variant_id'] as num?)?.toInt(),
      quantity: (json['quantity'] as num?)?.toInt(),
      itemPrice: Converters.dynamicToDouble(json['item_price']),
    );

Map<String, dynamic> _$$ItemCartDetailImplToJson(
        _$ItemCartDetailImpl instance) =>
    <String, dynamic>{
      'item_id': instance.itemId,
      'name': instance.name,
      'variant_id': instance.variantId,
      'quantity': instance.quantity,
      'item_price': instance.itemPrice,
    };
