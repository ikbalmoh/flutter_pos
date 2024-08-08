import 'package:selleri/data/models/category.dart';
import 'package:selleri/data/models/item.dart';
import 'package:selleri/data/models/item_package.dart';
import 'package:selleri/data/models/item_variant.dart';
import 'package:selleri/data/models/promotion.dart';
import 'package:selleri/objectbox.g.dart';
import 'dart:developer';

class ObjectBox {
  late final Store store;

  late final Box<Category> categoryBox;
  late final Box<Item> itemBox;
  late final Box<ItemVariant> itemVariantBox;
  late final Box<ItemPackage> itemPackageBox;
  late final Box<Promotion> promotionBox;

  ObjectBox._create(this.store) {
    categoryBox = Box<Category>(store);
    itemBox = Box<Item>(store);
    itemVariantBox = Box<ItemVariant>(store);
    itemPackageBox = Box<ItemPackage>(store);
    promotionBox = Box<Promotion>(store);
  }

  static Future<ObjectBox> create() async {
    final store = await openStore();
    return ObjectBox._create(store);
  }

  List<Category> categories() {
    return categoryBox.query(Category_.isActive.equals(true)).build().find();
  }

  Stream<List<Category>> categoriesStream() {
    final builder = categoryBox.query()..order(Category_.categoryName);
    return builder.watch(triggerImmediately: true).map((query) => query.find());
  }

  Stream<List<Promotion>> promotionsStream({
    int? type,
    double? requirementMinimumOrder,
    bool? needCode,
    bool? active,
  }) {
    final DateTime today = DateTime.now();
    Condition<Promotion> promotionQuery = (Promotion_.allTime.equals(true).or(
          Promotion_.endDate.greaterThanDate(
            today.subtract(
              const Duration(days: 30),
            ),
          ),
        ));

    if (active == true) {
      promotionQuery = Promotion_.allTime
          .equals(true)
          .or(Promotion_.startDate.lessOrEqualDate(DateTime.now()).and(
                Promotion_.endDate.greaterOrEqualDate(
                  DateTime.now(),
                ),
              ));
    }

    if (needCode != null) {
      promotionQuery = promotionQuery.and(Promotion_.needCode.equals(needCode));
    }

    if (type != null) {
      promotionQuery = promotionQuery.and(Promotion_.type.equals(type));
    }

    if (requirementMinimumOrder != null) {
      promotionQuery = promotionQuery.and(Promotion_.requirementMinimumOrder
          .lessOrEqual(requirementMinimumOrder));
    }

    QueryBuilder<Promotion> builder = promotionBox.query(promotionQuery)
      ..order(Promotion_.status, flags: Order.descending)
      ..order(Promotion_.allTime)
      ..order(Promotion_.priority)
      ..order(Promotion_.endDate);
    return builder.watch(triggerImmediately: true).map((query) => query.find());
  }

  Stream<List<Item>> itemsStream({
    String idCategory = '',
    String search = '',
    FilterStock filterStock = FilterStock.all,
  }) {
    Condition<Item> itemQuery = Item_.isActive.equals(true);
    if (idCategory != '') {
      itemQuery = itemQuery.and(Item_.idCategory.equals(idCategory));
    }
    if (search != '') {
      itemQuery =
          itemQuery.and(Item_.itemName.contains(search, caseSensitive: false));
    }
    if (filterStock == FilterStock.available) {
      itemQuery = itemQuery.and(Item_.stockItem.greaterThan(0));
    } else if (filterStock == FilterStock.empty) {
      itemQuery = itemQuery.and(Item_.stockItem.lessOrEqual(0));
    }
    QueryBuilder<Item> builder = itemBox.query(itemQuery)
      ..order(Item_.stockItem, flags: Order.descending)
      ..order(Item_.itemName);
    return builder.watch(triggerImmediately: true).map((query) => query.find());
  }

  void putCategories(List<Category> categories) {
    categoryBox.removeAll();
    categoryBox.putMany(categories);
  }

  ScanItemResult getItemByBarcode(String barcode) {
    Item? item =
        itemBox.query(Item_.barcode.equals(barcode)).build().findFirst();
    ItemVariant? variant;
    if (item != null && item.variants.isNotEmpty) {
      item = null;
    } else if (item == null) {
      variant = itemVariantBox
          .query(ItemVariant_.barcodeNumber.equals(barcode))
          .build()
          .findFirst();
      if (variant != null) {
        item = getItem(variant.idItem);
      }
    }
    return ScanItemResult(item: item, variant: variant);
  }

  Item? getItem(String idItem) =>
      itemBox.query(Item_.idItem.equals(idItem)).build().findFirst();

  Promotion? getPromotion(String idPromotion) => promotionBox
      .query(Promotion_.idPromotion.equals(idPromotion))
      .build()
      .findFirst();

  void putItems(List<Item> items) {
    itemBox.putMany(items);
    log('${items.length} ITEMS HAS BEEN STORED');
  }

  int getTotalItem({required String idCategory}) {
    if (idCategory != '') {
      return itemBox.query(Item_.idCategory.equals(idCategory)).build().count();
    }
    return itemBox.count();
  }

  void putPromotions(List<Promotion> promotions) {
    if (promotions.isNotEmpty) {
      promotionBox.removeAll();
      promotionBox.putMany(promotions);
    }
    log('${promotions.length} PROMOTIONS HAS BEEN STORED\n${promotions.map((p) => p.name)}');
  }

  void clearAll() {
    categoryBox.removeAll();
    itemBox.removeAll();
    itemVariantBox.removeAll();
    itemPackageBox.removeAll();
    promotionBox.removeAll();
  }
}

late ObjectBox objectBox;

Future initObjectBox() async {
  objectBox = await ObjectBox.create();
}
