import 'package:intl/intl.dart';
import 'package:selleri/data/models/cart.dart';
import 'package:selleri/data/models/category.dart';
import 'package:selleri/data/models/customer_group.dart';
import 'package:selleri/data/models/item.dart';
import 'package:selleri/data/models/item_cart.dart';
import 'package:selleri/data/models/item_package.dart';
import 'package:selleri/data/models/item_variant.dart';
import 'package:selleri/data/models/promotion.dart';
import 'package:selleri/objectbox.g.dart';
import 'dart:developer';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ObjectBox {
  late final Store store;

  late final Box<Category> categoryBox;
  late final Box<Item> itemBox;
  late final Box<ItemVariant> itemVariantBox;
  late final Box<ItemPackage> itemPackageBox;
  late final Box<Promotion> promotionBox;
  late final Box<CustomerGroup> customerGroupBox;

  ObjectBox._create(this.store) {
    categoryBox = Box<Category>(store);
    itemBox = Box<Item>(store);
    itemVariantBox = Box<ItemVariant>(store);
    itemPackageBox = Box<ItemPackage>(store);
    promotionBox = Box<Promotion>(store);
    customerGroupBox = Box<CustomerGroup>(store);
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

  List<Promotion> transactionPromotions({required Cart cart}) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    Condition<Promotion> promotionQuery = Promotion_.status.equals(true);

    promotionQuery = promotionQuery.and(Promotion_.days.isNull().or(
        Promotion_.days.containsElement(
            DateFormat('EEEE').format(DateTime.now()).toLowerCase())));

    // Filter promo by current date
    promotionQuery = promotionQuery.and(Promotion_.allTime
        .equals(true)
        .or(Promotion_.startDate
            .lessOrEqualDate(today)
            .and(Promotion_.endDate.greaterOrEqualDate(today)))
        .or(Promotion_.startDate
            .equalsDate(today)
            .or(Promotion_.endDate.equalsDate(today))));

    // Disable promo A get B
    promotionQuery = promotionQuery.and(Promotion_.type.notEquals(1));

    // FILTER PROMO BY CODE
    promotionQuery = promotionQuery.and(Promotion_.needCode.equals(false));

    // FILTER PROMO BY CODE
    promotionQuery = promotionQuery.and(Promotion_.needCode.equals(false));

    Condition<Promotion> promotionTermsQuery = Promotion_.type
        .equals(2)
        .and(Promotion_.requirementMinimumOrder.lessOrEqual(cart.subtotal));

    // Filter promotions by product
    if (cart.items.isNotEmpty) {
      List<ItemCart> items = List<ItemCart>.from(cart.items.toList());

      Condition<Promotion> requirementProductIds = (Promotion_
          .requirementProductId
          .containsElement(items[0].idItem)
          .and(Promotion_.requirementQuantity.lessOrEqual(items[0].quantity)));

      Condition<Promotion> requirementCategoryIds = (Promotion_
          .requirementProductId
          .containsElement(items[0].idCategory ?? '')
          .and(Promotion_.requirementQuantity.lessOrEqual(items[0].quantity)));

      for (var i = 1; i < items.length; i++) {
        ItemCart itemCart = items[i];
        requirementProductIds = requirementProductIds.or((itemCart.idVariant !=
                    null
                ? Promotion_.requirementVariantId
                    .containsElement(itemCart.idVariant!.toString())
                : Promotion_.requirementProductId
                    .containsElement(itemCart.idItem))
            .and(
                Promotion_.requirementQuantity.lessOrEqual(itemCart.quantity)));
        requirementCategoryIds = requirementCategoryIds.or((Promotion_
                .requirementProductId
                .containsElement(itemCart.idCategory ?? ''))
            .and(
                Promotion_.requirementQuantity.lessOrEqual(itemCart.quantity)));
      }

      Condition<Promotion> requirementProductQuery = Promotion_
          .requirementProductType
          .equals(1)
          .and(requirementProductIds)
          .or(Promotion_.requirementProductType
              .equals(3)
              .and(requirementCategoryIds));

      List<ItemCart> packageItems =
          items.where((item) => item.isPackage).toList();

      if (packageItems.isNotEmpty) {
        Condition<Promotion> requirementPackageIds = Promotion_
            .requirementProductId
            .containsElement(packageItems[0].idItem);
        for (var i = 1; i < packageItems.length; i++) {
          requirementPackageIds = requirementPackageIds.or(Promotion_
              .requirementProductId
              .containsElement(packageItems[i].idItem));
        }

        requirementProductQuery = requirementProductQuery.or(Promotion_
            .requirementProductType
            .equals(2)
            .and(requirementPackageIds));
      }

      promotionTermsQuery = promotionTermsQuery
          .or(Promotion_.type.equals(3).and(requirementProductQuery));
    }

    promotionQuery = promotionQuery.and(promotionTermsQuery);

    QueryBuilder<Promotion> builder = promotionBox.query(promotionQuery)
      ..order(Promotion_.needCode)
      ..order(Promotion_.priority)
      ..order(Promotion_.requirementMinimumOrder, flags: Order.descending)
      ..order(Promotion_.allTime);

    return builder.build().find();
  }

  Stream<List<Promotion>> promotionsStream(
      {int? type,
      double? requirementMinimumOrder,
      bool? needCode,
      bool? active,
      String? search,
      PickerDateRange? range}) {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    Condition<Promotion> promotionQuery = (Promotion_.allTime.equals(true).or(
          Promotion_.endDate.greaterThanDate(
            today.subtract(const Duration(days: 30)),
          ),
        )).and(Promotion_.type.notEquals(1));

    if (active == true) {
      promotionQuery = (Promotion_.allTime.equals(true).or(Promotion_.startDate
              .lessOrEqualDate(today)
              .and(Promotion_.endDate.greaterOrEqualDate(today))
              .or(Promotion_.startDate
                  .equalsDate(today)
                  .or(Promotion_.endDate.equalsDate(today)))))
          .and(Promotion_.days.isNull().or(Promotion_.days.containsElement(
              DateFormat('EEEE').format(DateTime.now()).toLowerCase())));
    }

    if (range != null) {
      var rangeQuery = Promotion_.startDate.lessOrEqualDate(range.startDate!);
      if (range.endDate != null) {
        rangeQuery.and(Promotion_.endDate.greaterOrEqualDate(range.endDate!));
      }
      promotionQuery = promotionQuery.and(
        Promotion_.allTime.equals(true).or(rangeQuery),
      );
    }

    if (range != null) {
      promotionQuery = promotionQuery.and(
        Promotion_.allTime.equals(true).or(rangeQuery),
      );
    }

    if (needCode != null) {
      promotionQuery = promotionQuery.and(Promotion_.needCode.equals(needCode));
    }

    if (search != null) {
      promotionQuery = promotionQuery.and(Promotion_.name
          .contains(search, caseSensitive: false)
          .or(Promotion_.promoCode.equals(search, caseSensitive: false)));
    }

    if (type != null) {
      promotionQuery = promotionQuery.and(Promotion_.type.equals(type));
    }

    if (requirementMinimumOrder != null) {
      promotionQuery = promotionQuery.and(Promotion_.requirementMinimumOrder
          .lessOrEqual(requirementMinimumOrder));
    }

    QueryBuilder<Promotion> builder = promotionBox.query(promotionQuery)
      ..order(Promotion_.needCode)
      ..order(Promotion_.status)
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

  CustomerGroup? getCustomerGroup(int groupId) => customerGroupBox
      .query(CustomerGroup_.groupId.equals(groupId))
      .build()
      .findFirst();

  Promotion? getPromotion(String idPromotion) => promotionBox
      .query(Promotion_.idPromotion.equals(idPromotion))
      .build()
      .findFirst();

  List<Promotion>? getPromotions(List<String> idPromotions) => promotionBox
      .query(Promotion_.idPromotion
          .oneOf(idPromotions)
          .and(Promotion_.type.notEquals(1)))
      .build()
      .find();

  List<Promotion>? getPromotions(List<String> idPromotions) => promotionBox
      .query(Promotion_.idPromotion.oneOf(idPromotions))
      .build()
      .find();

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

  void putPromotions(List<Promotion> promotions) {
    promotionBox.putMany(promotions);
    log('${promotions.length} PROMOTIONS HAS BEEN STORED\n$promotions');
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
