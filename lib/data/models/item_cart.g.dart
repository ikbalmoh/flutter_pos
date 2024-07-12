// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_cart.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ItemCartImpl _$$ItemCartImplFromJson(Map<String, dynamic> json) =>
    _$ItemCartImpl(
      identifier: json['identifier'] as String?,
      idItem: json['id_item'] as String,
      itemName: json['item_name'] as String,
      isPackage: Converters.dynamicToBool(json['is_package']),
      isManualPrice: Converters.dynamicToBool(json['is_manual_price']),
      price: (json['price'] as num).toDouble(),
      manualDiscount: Converters.dynamicToBool(json['manual_discount']),
      quantity: (json['quantity'] as num).toInt(),
      discount: (json['discount'] as num).toDouble(),
      discountIsPercent: Converters.dynamicToBool(json['discount_is_percent']),
      discountTotal: (json['discount_total'] as num).toDouble(),
      addedAt: json['added_at'] == null
          ? null
          : DateTime.parse(json['added_at'] as String),
      total: (json['total'] as num).toDouble(),
      note: json['note'] as String?,
      idVariant: Converters.dynamicToNum(json['id_variant']),
      variantName: json['variant_name'] as String?,
      details: (json['details'] as List<dynamic>)
          .map((e) => ItemCartDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
      picDetailId: json['pic_detail_id'] as String?,
      picName: json['pic_name'] as String?,
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
      'added_at': instance.addedAt?.toIso8601String(),
      'total': instance.total,
      'note': instance.note,
      'id_variant': instance.idVariant,
      'variant_name': instance.variantName,
      'details': instance.details.map((e) => e.toJson()).toList(),
      'pic_detail_id': instance.picDetailId,
      'pic_name': instance.picName,
    };
