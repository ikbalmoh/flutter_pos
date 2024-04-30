// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_variant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemVariant _$ItemVariantFromJson(Map<String, dynamic> json) => ItemVariant(
      id: (json['id'] as num).toInt(),
      idVariant: (json['id_variant'] as num).toInt(),
      itemPrice: (json['item_price'] as num).toDouble(),
      skuNumber: json['sku_number'] as String?,
      barcodeNumber: json['barcode_number'] as String?,
      variantName: json['variant_name'] as String,
      stockItem: Converters.dynamicToDouble(json['stock_item']),
      promotions: (json['promotions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      image: json['image'] == null
          ? null
          : ItemVariantImage.fromJson(json['image'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ItemVariantToJson(ItemVariant instance) =>
    <String, dynamic>{
      'id': instance.id,
      'id_variant': instance.idVariant,
      'stock_item': instance.stockItem,
      'variant_name': instance.variantName,
      'item_price': instance.itemPrice,
      'sku_number': instance.skuNumber,
      'barcode_number': instance.barcodeNumber,
      'promotions': instance.promotions,
      'image': instance.image,
    };
