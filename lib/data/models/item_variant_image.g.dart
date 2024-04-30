// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_variant_image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemVariantImage _$ItemVariantImageFromJson(Map<String, dynamic> json) =>
    ItemVariantImage(
      idItem: json['id_item'] as String,
      variantId: (json['variant_id'] as num).toInt(),
      imagePath: json['image_path'] as String,
      isPrimary: Converters.dynamicToBool(json['is_primary']),
    );

Map<String, dynamic> _$ItemVariantImageToJson(ItemVariantImage instance) =>
    <String, dynamic>{
      'id_item': instance.idItem,
      'variant_id': instance.variantId,
      'image_path': instance.imagePath,
      'is_primary': instance.isPrimary,
    };
