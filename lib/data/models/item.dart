import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:selleri/data/objectbox.dart';
import 'package:selleri/objectbox.g.dart';
import 'item_variant.dart';
import 'item_package.dart';
import 'converters/generic.dart';

part 'item.g.dart';

@Entity()
@JsonSerializable(fieldRename: FieldRename.snake)
class Item {
  int id;

  @Index()
  final String idItem;

  final String itemName;
  final double itemPrice;
  final bool isActive;
  final bool obsolete;
  final bool isPackage;
  final bool manualDiscount;
  final bool isManualPrice;
  final bool stockControl;
  final String idCategory;

  @JsonKey(fromJson: Converters.dynamicToDouble)
  final double stockItem;

  String? sku;
  String? barcode;
  String? categoryName;
  String? image;

  @Property(type: PropertyType.dateNano)
  DateTime? lastAdjustment;

  List<String>? promotions;
  List<String>? packageCategories;

  @VariantRelToManyConverter()
  final ToMany<ItemVariant> variants;

  @PackageItemRelToManyConverter()
  final ToMany<ItemPackage> packageItems;

  Item({
    required this.id,
    required this.idItem,
    required this.itemName,
    required this.itemPrice,
    required this.isActive,
    required this.obsolete,
    required this.isPackage,
    this.sku,
    this.barcode,
    required this.manualDiscount,
    required this.isManualPrice,
    required this.stockControl,
    required this.idCategory,
    this.categoryName,
    required this.stockItem,
    this.image,
    this.lastAdjustment,
    this.packageCategories,
    this.promotions,
    required this.variants,
    required this.packageItems,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    Item? existItem = objectBox.getItem(json['id_item']);
    json['id'] = existItem?.id ?? 0;
    json['variants'] = json['variants']?.map((variant) {
      ItemVariant? existVariant = objectBox.itemVariantBox
          .query(ItemVariant_.idVariant.equals(variant['id_variant']))
          .build()
          .findFirst();
      variant['id'] = existVariant?.id ?? 0;
      return variant;
    }).toList();
    json['package_items'] = json['package_items']?.map((package) {
      ItemPackage? existPackage = objectBox.itemPackageBox
          .query(ItemPackage_.idItem.equals(package['id_item']))
          .build()
          .findFirst();
      package['id'] = existPackage?.id ?? 0;
      return package;
    }).toList();
    return _$ItemFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ItemToJson(this);

  @override
  String toString() {
    return json.encode(toJson());
  }
}

class VariantRelToManyConverter
    implements JsonConverter<ToMany<ItemVariant>, List?> {
  const VariantRelToManyConverter();

  @override
  ToMany<ItemVariant> fromJson(List? json) => ToMany<ItemVariant>(
      items: json?.map((e) => ItemVariant.fromJson(e)).toList());

  @override
  List<Map<String, dynamic>>? toJson(ToMany<ItemVariant> rel) =>
      rel.map((ItemVariant obj) => obj.toJson()).toList();
}

class PackageItemRelToManyConverter
    implements JsonConverter<ToMany<ItemPackage>, List?> {
  const PackageItemRelToManyConverter();

  @override
  ToMany<ItemPackage> fromJson(List? json) => ToMany<ItemPackage>(
      items: json?.map((e) => ItemPackage.fromJson(e)).toList());

  @override
  List<Map<String, dynamic>>? toJson(ToMany<ItemPackage> rel) =>
      rel.map((ItemPackage obj) => obj.toJson()).toList();
}
