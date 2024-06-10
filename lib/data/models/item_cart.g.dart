// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_cart.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ItemCartImpl _$$ItemCartImplFromJson(Map<String, dynamic> json) =>
    _$ItemCartImpl(
      identifier: json['identifier'] as String,
      idItem: json['id_item'] as String,
      itemName: json['item_name'] as String,
      isPackage: json['is_package'] as bool,
      isManualPrice: json['is_manual_price'] as bool,
      price: (json['price'] as num).toDouble(),
      manualDiscount: json['manual_discount'] as bool,
      quantity: (json['quantity'] as num).toInt(),
      discount: (json['discount'] as num).toDouble(),
      discountIsPercent: Converters.dynamicToBool(json['discount_is_percent']),
      discountTotal: (json['discount_total'] as num).toDouble(),
      addedAt: DateTime.parse(json['added_at'] as String),
      total: (json['total'] as num).toDouble(),
      note: json['note'] as String,
      idVariant: json['id_variant'] as num?,
      variantName: json['variant_name'] as String?,
    );

Map<String, dynamic> _$$ItemCartImplToJson(_$ItemCartImpl instance) =>
    <String, dynamic>{
      'identifier': instance.identifier,
      'id_item': instance.idItem,
      'item_name': instance.itemName,
      'is_package': instance.isPackage,
      'is_manual_price': instance.isManualPrice,
      'price': instance.price,
      'manual_discount': instance.manualDiscount,
      'quantity': instance.quantity,
      'discount': instance.discount,
      'discount_is_percent': instance.discountIsPercent,
      'discount_total': instance.discountTotal,
      'added_at': instance.addedAt.toIso8601String(),
      'total': instance.total,
      'note': instance.note,
      'id_variant': instance.idVariant,
      'variant_name': instance.variantName,
    };
