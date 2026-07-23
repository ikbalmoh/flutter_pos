import 'package:selleri/shared/objectbox.dart' show objectBox;
// ignore: unnecessary_import
import 'package:objectbox/objectbox.dart';
import 'package:selleri/objectbox.g.dart';
import 'package:selleri/shared/utils/formater.dart';
import 'item_variant.dart';
import 'item_package.dart';
import '../../../shared/utils/model_converter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'item.freezed.dart';
part 'item.g.dart';

@Freezed(addImplicitFinal: false)
class Item with _$Item {
  @Entity(uid: 1396131410230828223, realClass: Item)
  @JsonSerializable(fieldRename: FieldRename.snake)
  factory Item({
    @Default(0) @Id() int id,
    @Index() required String idItem,
    required String itemName,
    @JsonKey(fromJson: ModelConverter.dynamicToDouble)
    required double itemPrice,
    @JsonKey(fromJson: ModelConverter.dynamicToBool) required bool isActive,
    @JsonKey(fromJson: ModelConverter.dynamicToBool) required bool obsolete,
    @JsonKey(fromJson: ModelConverter.dynamicToBool) required bool isPackage,
    @JsonKey(fromJson: ModelConverter.dynamicToBool)
    required bool manualDiscount,
    @JsonKey(fromJson: ModelConverter.dynamicToBool)
    required bool isManualPrice,
    @JsonKey(fromJson: ModelConverter.dynamicToBool) required bool stockControl,
    required String idCategory,
    @JsonKey(fromJson: ModelConverter.dynamicToDouble)
    required double stockItem,
    String? sku,
    String? barcode,
    String? categoryName,
    String? image,
    @Property(type: PropertyType.date)
    @JsonKey(fromJson: DateTimeFormater.stringToDateTime)
    DateTime? expiredDate,
    @JsonKey(fromJson: DateTimeFormater.stringToDateTime)
    DateTime? updatedAt,
    @Property(type: PropertyType.dateNano) DateTime? lastAdjustment,
    required List<String> promotions,
    bool? hasPromo,
    List<String>? packageCategories,
    @VariantRelToManyConverter() required ToMany<ItemVariant> variants,
    @PackageItemRelToManyConverter() required ToMany<ItemPackage> packageItems,
  }) = _Item;

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  factory Item.fromJsonData(Map<String, dynamic> json) {
    // Always work with a mutable copy — the _source map from Elasticsearch
    // (returned by Dio) is unmodifiable and cannot be mutated directly.
    json = Map<String, dynamic>.from(json);
    Item? existItem = objectBox.getItem(json['id_item']);
    if (existItem != null) {
      final Map<String, dynamic> itemJson = existItem.toJson();
      json = {
        ...itemJson,
        ...json,
      };
    }
    json['promotions'] = json['promotions'] ?? [];
    json['has_promo'] = (json['promotions'] as List).isNotEmpty;
    json['id'] = existItem?.id ?? 0;
    json['item_name'] = json['item_name'] ?? existItem?.itemName;
    json['variants'] = json['variants']?.map((variant) {
      ItemVariant? existVariant = objectBox.itemVariantBox
          .query(ItemVariant_.idVariant.equals(variant['id_variant']))
          .build()
          .findFirst();
      variant['id_item'] = json['id_item'];
      variant['id'] = existVariant?.id ?? 0;
      return variant;
    }).toList();
    json['package_items'] = json['package_items']?.map((package) {
      ItemPackage? existPackage = objectBox.itemPackageBox
          .query(ItemPackage_.idItemPackage.equals(package['id_item_package']))
          .build()
          .findFirst();
      package['id'] = existPackage?.id ?? 0;
      return package;
    }).toList();
    return _$ItemFromJson(json);
  }

  const Item._();

  bool isExpired() =>
      expiredDate != null ? DateTime.now().isAfter(expiredDate!) : false;

  List<ItemPackage> itemsHasExpiredDate() {
    if (isPackage && packageItems.isNotEmpty) {
      final expiredItems =
          packageItems.where((pkg) => pkg.item()?.expiredDate != null).toList();
      return expiredItems;
    }
    return [];
  }

  List<ItemPackage> expiredItems() {
    if (isPackage && packageItems.isNotEmpty) {
      final expiredItems =
          packageItems.where((pkg) => pkg.item()?.isExpired() == true).toList();
      return expiredItems;
    }
    return [];
  }

  int totalExpiredItems() {
    if (isPackage && packageItems.isNotEmpty) {
      return packageItems
          .where((pkg) => pkg.item()?.isExpired() == true)
          .length;
    }
    return 0;
  }

  bool hasExpiredItems() {
    if (isPackage && packageItems.isNotEmpty) {
      final expiredIndex =
          packageItems.indexWhere((pkg) => pkg.item()?.isExpired() == true);
      return expiredIndex >= 0;
    }
    return isExpired();
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

@freezed
class ScanItemResult with _$ScanItemResult {
  const factory ScanItemResult({
    Item? item,
    ItemVariant? variant,
  }) = _ScanItemResult;
}

enum FilterStock { all, available, empty }
