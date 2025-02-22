import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
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
import 'package:path/path.dart' as p;

class ObjectBox {
  late final Store store;
  static ObjectBox? _instance;

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
    if (_instance != null) {
      return _instance!;
    } else {
      final docsDir = await getApplicationDocumentsDirectory();
      final storePath = p.join(docsDir.path, "obx");
      late Store store;
      if (Store.isOpen(storePath)) {
        store = Store.attach(getObjectBoxModel(), storePath);
      } else {
        store = await openStore(directory: storePath);
      }
      _instance = ObjectBox._create(store);
      return _instance!;
    }
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

    // Filter Promo by day
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

    // FILTER PROMO BY CODE
    promotionQuery = promotionQuery.and(Promotion_.needCode.equals(false));

    Condition<Promotion> promotionTermsQuery = (Promotion_.type.equals(2))
        .and(Promotion_.requirementMinimumOrder.lessOrEqual(cart.subtotal));

    // Filter promotions by product
    if (cart.items.isNotEmpty) {
      List<ItemCart> items = List<ItemCart>.from(cart.items.toList());

      Condition<Promotion> requirementProductIds = (items[0].idVariant != null
              ? Promotion_.requirementVariantId
                  .containsElement(items[0].idVariant!.toString())
              : Promotion_.requirementProductId
                  .containsElement(items[0].idItem))
          .and(Promotion_.requirementQuantity.lessOrEqual(items[0].quantity));

      Condition<Promotion> requirementCategoryIds = (Promotion_
          .requirementProductId
          .containsElement(items[0].idCategory ?? '')
          .and(Promotion_.requirementQuantity.lessOrEqual(items[0].quantity)));

      for (var i = 1; i < items.length; i++) {
        ItemCart itemCart = items[i];
        requirementProductIds = requirementProductIds.or(
          (itemCart.idVariant != null
                  ? Promotion_.requirementVariantId
                      .containsElement(itemCart.idVariant!.toString())
                  : Promotion_.requirementProductId
                      .containsElement(itemCart.idItem))
              .and(
            Promotion_.requirementQuantity.lessOrEqual(itemCart.quantity),
          ),
        );

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
          .or(Promotion_.type.oneOf([3]).and(requirementProductQuery));
    }

    promotionQuery = promotionQuery.and(promotionTermsQuery);

    QueryBuilder<Promotion> builder = promotionBox.query(promotionQuery)
      ..order(Promotion_.needCode)
      ..order(Promotion_.priority)
      ..order(Promotion_.requirementMinimumOrder, flags: Order.descending)
      ..order(Promotion_.allTime);

    List<Promotion> promotions = builder.build().find();

    log('active promotions: ${promotions.map((p) => p.name)}');

    return promotions;
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
      itemQuery = itemQuery.and(Item_.itemName
          .contains(search, caseSensitive: false)
          .or(Item_.barcode.equals(search, caseSensitive: false))
          .or(Item_.sku.equals(search, caseSensitive: false)));
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

  List<ItemVariant> itemVariants(String idItem) {
    List<ItemVariant> variants =
        itemVariantBox.query(ItemVariant_.idItem.equals(idItem)).build().find();
    return variants;
  }

  ScanItemResult getItemByBarcode(String barcode) {
    Item? item;
    ItemVariant? variant = itemVariantBox
        .query(ItemVariant_.barcodeNumber.equals(barcode, caseSensitive: false))
        .build()
        .findFirst();
    if (variant != null) {
      item = getItem(variant.idItem);
    } else {
      item = itemBox
          .query(Item_.barcode.equals(barcode, caseSensitive: false))
          .build()
          .findFirst();
    }
    return ScanItemResult(item: item, variant: variant);
  }

  Item? getItem(String idItem) =>
      itemBox.query(Item_.idItem.equals(idItem)).build().findFirst();

  ItemVariant? getItemVariant(
          {required String idItem, required int variantId}) =>
      itemVariantBox
          .query(ItemVariant_.idItem
              .equals(idItem)
              .and(ItemVariant_.idVariant.equals(variantId)))
          .build()
          .findFirst();

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

  void putItems(List<Item> items) {
    log('PUT ITEMS =>\n$items');
    List<int> ids = itemBox.putMany(items);
    log('ITEMS HAS BEEN STORED: $ids');
    List<ItemVariant> itemVariants = [];
    for (var item in items) {
      if (item.variants.isNotEmpty) {
        itemVariants.addAll(item.variants.toList());
      }
    }
    if (itemVariants.isNotEmpty) {
      putVariants(itemVariants);
    }
  }

  void putVariants(List<ItemVariant> variants) {
    log('PUT VARIANTS =>\n$variants');
    List<int> ids = itemVariantBox.putMany(variants);
    log('VARIANTS HAS BEEN STORED: $ids');
  }

  int getTotalItem(
      {String idCategory = '', FilterStock? filterStock = FilterStock.all}) {
    Condition<Item> itemQuery = Item_.isActive.equals(true);

    if (idCategory != '') {
      itemQuery = itemQuery.and(Item_.idCategory.equals(idCategory));
    }
    if (filterStock == FilterStock.available) {
      itemQuery = itemQuery.and(Item_.stockItem.greaterThan(0));
    } else if (filterStock == FilterStock.empty) {
      itemQuery = itemQuery.and(Item_.stockItem.lessOrEqual(0));
    }
    final result = itemBox.query(itemQuery).build().count();

    return result;
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
