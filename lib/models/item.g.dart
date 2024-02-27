// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Item _$ItemFromJson(Map<String, dynamic> json) => Item(
      id: json['id'] as int,
      idItem: json['id_item'] as String,
      itemName: json['item_name'] as String,
      itemPrice: (json['item_price'] as num).toDouble(),
      isActive: json['is_active'] as bool,
      obsolete: json['obsolete'] as bool,
      isPackage: json['is_package'] as bool,
      sku: json['sku'] as String?,
      barcode: json['barcode'] as String?,
      manualDiscount: json['manual_discount'] as bool,
      isManualPrice: json['is_manual_price'] as bool,
      stockControl: json['stock_control'] as bool,
      idCategory: json['id_category'] as String,
      categoryName: json['category_name'] as String?,
      stockItem: Converters.dynamicToDouble(json['stock_item']),
      image: json['image'] as String?,
      lastAdjustment: json['last_adjustment'] == null
          ? null
          : DateTime.parse(json['last_adjustment'] as String),
      packageCategories: (json['package_categories'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      promotions: (json['promotions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      variants:
          const VariantRelToManyConverter().fromJson(json['variants'] as List?),
      packageItems: const PackageItemRelToManyConverter()
          .fromJson(json['package_items'] as List?),
    );

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
      'id': instance.id,
      'id_item': instance.idItem,
      'item_name': instance.itemName,
      'item_price': instance.itemPrice,
      'is_active': instance.isActive,
      'obsolete': instance.obsolete,
      'is_package': instance.isPackage,
      'manual_discount': instance.manualDiscount,
      'is_manual_price': instance.isManualPrice,
      'stock_control': instance.stockControl,
      'id_category': instance.idCategory,
      'stock_item': instance.stockItem,
      'sku': instance.sku,
      'barcode': instance.barcode,
      'category_name': instance.categoryName,
      'image': instance.image,
      'last_adjustment': instance.lastAdjustment?.toIso8601String(),
      'promotions': instance.promotions,
      'package_categories': instance.packageCategories,
      'variants': const VariantRelToManyConverter().toJson(instance.variants),
      'package_items':
          const PackageItemRelToManyConverter().toJson(instance.packageItems),
    };
