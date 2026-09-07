import 'dart:convert';

import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:selleri/features/cart/model/cart.dart';
import 'package:selleri/features/item/model/category.dart';
import 'package:selleri/features/customer/model/customer_group.dart';
import 'package:selleri/features/item/model/item.dart';
import 'package:selleri/features/item/model/item_cart.dart';
import 'package:selleri/features/item/model/item_package.dart';
import 'package:selleri/features/item/model/item_variant.dart';
import 'package:selleri/features/promotion/model/promotion.dart';
import 'package:selleri/features/transaction/model/offline_transaction.dart';
import 'package:selleri/objectbox.g.dart';
import 'dart:developer';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:path/path.dart' as p;

/// A singleton class that manages the ObjectBox local database instance.
/// It provides methods to perform CRUD operations on various entities
/// such as categories, items, promotions, and offline transactions.
class ObjectBox {
  late final Store store;
  static ObjectBox? _instance;

  late final Box<Category> categoryBox;
  late final Box<Item> itemBox;
  late final Box<ItemVariant> itemVariantBox;
  late final Box<ItemPackage> itemPackageBox;
  late final Box<Promotion> promotionBox;
  late final Box<CustomerGroup> customerGroupBox;
  late final Box<OfflineTransaction> transactionBox;

  ObjectBox._create(this.store) {
    categoryBox = Box<Category>(store);
    itemBox = Box<Item>(store);
    itemVariantBox = Box<ItemVariant>(store);
    itemPackageBox = Box<ItemPackage>(store);
    promotionBox = Box<Promotion>(store);
    customerGroupBox = Box<CustomerGroup>(store);
    transactionBox = Box<OfflineTransaction>(store);
  }

  /// Initializes and returns the [ObjectBox] instance.
  /// If an instance already exists, it returns the existing one.
  /// Otherwise, it opens the store in the application documents directory.
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

  /// Retrieves a list of active promotions applicable to the given [cart].
  /// This method applies various filters including day of week, date validity,
  /// minimum order subtotal, and specific products or categories in the cart.
  List<Promotion> transactionPromotions({required Cart cart}) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    // 1. Initial condition: Ensure the promotion is active (status = true)
    Condition<Promotion> promotionQuery = Promotion_.status.equals(true);

    // 2. Filter Promo by day: The promotion must either be valid for all days (days is null)
    // or valid specifically for today's day name (e.g., 'monday').
    promotionQuery = promotionQuery.and(
      Promotion_.days.isNull().or(
        Promotion_.days.containsElement(
          DateFormat('EEEE', 'en_US').format(DateTime.now()).toLowerCase(),
        ),
      ),
    );

    // 3. Filter promo by current date: The promotion must either be valid for all time (allTime = true)
    // or today's date must fall within the range of startDate and endDate (inclusive).
    promotionQuery = promotionQuery.and(
      Promotion_.allTime
          .equals(true)
          .or(
            Promotion_.startDate
                .lessOrEqualDate(today)
                .and(Promotion_.endDate.greaterOrEqualDate(today)),
          )
          .or(
            Promotion_.startDate
                .equalsDate(today)
                .or(Promotion_.endDate.equalsDate(today)),
          ),
    );

    // 4. Filter Promo by code: Exclude promotions that require a manual promo code,
    // since this method automatically applies eligible promotions.
    promotionQuery = promotionQuery.and(Promotion_.needCode.equals(false));

    // 5. Transaction Terms Condition: For promotions that apply to the overall transaction
    // (type 2: Transaction Discount, type 4: Free Shipping), check if the cart subtotal
    // meets or exceeds the minimum order requirement.
    Condition<Promotion> promotionTermsQuery = Promotion_.type
        .oneOf([2, 4])
        .and(Promotion_.requirementMinimumOrder.lessOrEqual(cart.subtotal));

    // 6. Filter promotions by product: If the cart has items, we need to check if
    // there are promotions specifically targeting these items or their categories.
    if (cart.items.isNotEmpty) {
      List<ItemCart> items = List<ItemCart>.from(cart.items.toList());

      // 7. Product Requirement Condition (Base): Setup the condition for the first item in the cart.
      // Match by variant ID if available, otherwise by item ID. Also ensure the cart item quantity
      // is greater than or equal to the promotion's minimum requirement quantity.
      Condition<Promotion> requirementProductIds = Promotion_
          .requirementProductId
          .containsElement('');

      // 8. Category Requirement Condition (Base): Setup the condition for the first item's category.
      // Match by the item's category ID and ensure the cart item quantity meets the requirement.
      Condition<Promotion> requirementCategoryIds = Promotion_
          .requirementProductId
          .containsElement('');

      Condition<Promotion> requirementSubCategoryIds = Promotion_
          .requirementProductId
          .containsElement('');

      // Iterate through the rest of the cart items to add them as OR conditions
      for (var i = 0; i < items.length; i++) {
        ItemCart itemCart = items[i];

        // 9. Append product/variant requirements for subsequent items using OR.
        requirementProductIds = requirementProductIds.or(
          (itemCart.idVariant != null
                  ? Promotion_.requirementVariantId.containsElement(
                      itemCart.idVariant!.toString(),
                    )
                  : Promotion_.requirementProductId.containsElement(
                      itemCart.idItem,
                    ))
              .and(
                Promotion_.requirementQuantity.lessOrEqual(
                  itemCart.quantity.toInt(),
                ),
              ),
        );

        // (Note: The block below seems to be an exact duplicate of the block above in the original code,
        //  but we keep it structurally identical and append it to the condition.)
        requirementProductIds = requirementProductIds.or(
          (itemCart.idVariant != null
                  ? Promotion_.requirementVariantId.containsElement(
                      itemCart.idVariant!.toString(),
                    )
                  : Promotion_.requirementProductId.containsElement(
                      itemCart.idItem,
                    ))
              .and(
                Promotion_.requirementQuantity.lessOrEqual(
                  itemCart.quantity.toInt(),
                ),
              ),
        );

        // 10. Append category requirements for subsequent items using OR.
        if (itemCart.idCategory != null) {
          requirementCategoryIds = requirementCategoryIds.or(
            (Promotion_.requirementProductId.containsElement(
              itemCart.idCategory!,
            )).and(
              Promotion_.requirementQuantity.lessOrEqual(
                itemCart.quantity.toInt(),
              ),
            ),
          );
        }

        if (itemCart.idSubCategory != null) {
          requirementSubCategoryIds = requirementSubCategoryIds.or(
            (Promotion_.requirementProductId.containsElement(
              itemCart.idSubCategory!,
            )).and(
              Promotion_.requirementQuantity.lessOrEqual(
                itemCart.quantity.toInt(),
              ),
            ),
          );
        }
      }

      // 11. Combine Product & Category queries: A promotion is matched if it specifically
      // targets products (requirementProductType = 1) AND the product condition is met,
      // OR if it targets categories (requirementProductType = 3) AND the category condition is met.
      Condition<Promotion> requirementProductQuery = Promotion_
          .requirementProductType
          .equals(1)
          .and(requirementProductIds)
          .or(
            Promotion_.requirementProductType
                .equals(3)
                .and(requirementCategoryIds),
          )
          .or(Promotion_.requirementProductType.equals(4).and(requirementSubCategoryIds));

      List<ItemCart> packageItems = items
          .where((item) => item.isPackage)
          .toList();

      if (packageItems.isNotEmpty) {
        // 12. Package Requirement Condition: If there are packages in the cart,
        // create a base condition matching the first package's item ID.
        Condition<Promotion> requirementPackageIds = Promotion_
            .requirementProductId
            .containsElement('');
        // 13. Append package requirements for subsequent package items using OR.
        for (var i = 0; i < packageItems.length; i++) {
          requirementPackageIds = requirementPackageIds.or(
            Promotion_.requirementProductId.containsElement(
              packageItems[i].idItem,
            ),
          );
        }

        // 14. Include package promotions in the overall product query (requirementProductType = 2).
        requirementProductQuery = requirementProductQuery.or(
          Promotion_.requirementProductType
              .equals(2)
              .and(requirementPackageIds),
        );
      }

      // 15. Final Terms Condition: Combine the transaction-wide terms (type 2, 4) with
      // product-specific promotions (type 1: item discount, type 3: free item) that met the product query.
      promotionTermsQuery = promotionTermsQuery.or(
        Promotion_.type.oneOf([1, 3]).and(requirementProductQuery),
      );
    }

    // 16. Combine all conditions (active, date/time, code, and terms) into the final query.
    promotionQuery = promotionQuery.and(promotionTermsQuery);

    // 17. Execute the query, ordering by type, whether it needs a code, priority, minimum order (desc), and all time.
    QueryBuilder<Promotion> builder = promotionBox.query(promotionQuery)
      ..order(Promotion_.type)
      ..order(Promotion_.needCode)
      ..order(Promotion_.priority)
      ..order(Promotion_.requirementMinimumOrder, flags: Order.descending)
      ..order(Promotion_.allTime);

    List<Promotion> promotions = builder.build().find();

    return promotions;
  }

  Stream<List<Promotion>> promotionsStream({
    int? type,
    double? requirementMinimumOrder,
    bool? needCode,
    bool? active,
    String? search,
    PickerDateRange? range,
  }) {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    Condition<Promotion> promotionQuery = Promotion_.allTime
        .equals(true)
        .or(
          Promotion_.endDate.greaterThanDate(
            today.subtract(const Duration(days: 30)),
          ),
        );

    if (active == true) {
      promotionQuery =
          (Promotion_.allTime
                  .equals(true)
                  .or(
                    Promotion_.startDate
                        .lessOrEqualDate(today)
                        .and(Promotion_.endDate.greaterOrEqualDate(today))
                        .or(
                          Promotion_.startDate
                              .equalsDate(today)
                              .or(Promotion_.endDate.equalsDate(today)),
                        ),
                  ))
              .and(
                Promotion_.days.isNull().or(
                  Promotion_.days.containsElement(
                    DateFormat(
                      'EEEE',
                      'en_US',
                    ).format(DateTime.now()).toLowerCase(),
                  ),
                ),
              );
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
      promotionQuery = promotionQuery.and(
        Promotion_.name
            .contains(search, caseSensitive: false)
            .or(Promotion_.promoCode.equals(search, caseSensitive: false)),
      );
    }

    if (type != null) {
      promotionQuery = promotionQuery.and(Promotion_.type.equals(type));
    }

    if (requirementMinimumOrder != null) {
      promotionQuery = promotionQuery.and(
        Promotion_.requirementMinimumOrder.lessOrEqual(requirementMinimumOrder),
      );
    }

    QueryBuilder<Promotion> builder = promotionBox.query(promotionQuery)
      ..order(Promotion_.needCode)
      ..order(Promotion_.status)
      ..order(Promotion_.allTime)
      ..order(Promotion_.priority)
      ..order(Promotion_.endDate);
    return builder.watch(triggerImmediately: true).map((query) => query.find());
  }

  ScanItemResult getPromotionReward({required Promotion promotion}) {
    Condition<Item> itemQuery = Item_.isActive.equals(true);
    ScanItemResult result = const ScanItemResult(item: null, variant: null);
    Item? item;
    ItemVariant? variant;
    if (promotion.rewardProductId == null) {
      return result;
    }
    if (promotion.rewardProductType == 1) {
      itemQuery = itemQuery.and(
        Item_.idItem.equals(promotion.rewardProductId!),
      );

      item = itemBox.query(itemQuery).build().findFirst();

      if (item == null) {
        return result;
      }

      if (promotion.rewardVariantId != null) {
        variant = itemVariantBox
            .query(
              ItemVariant_.idItem
                  .equals(promotion.rewardProductId!)
                  .and(
                    ItemVariant_.idVariant.equals(promotion.rewardVariantId!),
                  ),
            )
            .build()
            .findFirst();
      }

      result = ScanItemResult(item: item, variant: variant);
    }
    return result;
  }

  Stream<List<Item>> itemsStream({
    String idCategory = '',
    String search = '',
    bool? isPromo = false,
    FilterStock filterStock = FilterStock.all,
  }) {
    Condition<Item> itemQuery = Item_.isActive.equals(true);
    if (idCategory != '' && idCategory != 'promo') {
      itemQuery = itemQuery.and(Item_.idCategory.equals(idCategory));
    }
    if (search != '') {
      itemQuery = itemQuery.and(
        Item_.itemName
            .contains(search, caseSensitive: false)
            .or(Item_.barcode.equals(search, caseSensitive: false))
            .or(Item_.sku.equals(search, caseSensitive: false)),
      );
    }
    if (filterStock == FilterStock.available) {
      itemQuery = itemQuery.and(Item_.stockItem.greaterThan(0));
    } else if (filterStock == FilterStock.empty) {
      itemQuery = itemQuery.and(Item_.stockItem.lessOrEqual(0));
    }
    if (isPromo == true) {
      itemQuery = itemQuery.and(Item_.hasPromo.equals(true));
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
    List<ItemVariant> variants = itemVariantBox
        .query(ItemVariant_.idItem.equals(idItem))
        .build()
        .find();
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

  ItemVariant? getItemVariant({
    required String idItem,
    required int variantId,
  }) => itemVariantBox
      .query(
        ItemVariant_.idItem
            .equals(idItem)
            .and(ItemVariant_.idVariant.equals(variantId)),
      )
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
      .query(Promotion_.idPromotion.oneOf(idPromotions))
      .build()
      .find();

  /// Inserts or updates a list of items into the local database.
  /// This method also handles saving associated item variants and packages,
  /// and removes any variants or packages that are no longer associated with the items.
  void putItems(List<Item> items) async {
    try {
      List<int> ids = itemBox.putMany(items);
      if (kDebugMode) {
        print('PUT ${ids.length} ITEMS');
      }
      List<ItemVariant> itemVariants = [];
      List<int> removeVariants = [];
      for (var item in items) {
        final unusedVariant = getItem(item.idItem)?.variants
            .where((v) => !item.variants.map((vr) => vr.id).contains(v.id))
            .map((v) => v.id)
            .toList();
        if (unusedVariant != null) {
          removeVariants.addAll(unusedVariant);
        }
        if (item.variants.isNotEmpty) {
          itemVariants.addAll(item.variants.toList());
        }
      }
      if (removeVariants.isNotEmpty) {
        itemVariantBox.removeMany(removeVariants);
      }
      if (itemVariants.isNotEmpty) {
        putVariants(itemVariants);
      }
      // ITEM PACKAGES
      List<ItemPackage> itemPackages = [];
      List<int> removeItemPackageIds = [];
      for (var item in items) {
        if (item.isPackage) {
          final unusedPackages = getItem(item.idItem)?.packageItems
              .where(
                (pkg) => !item.packageItems
                    .map((pkg) => pkg.idItemPackage)
                    .contains(pkg.idItemPackage),
              )
              .map((pkg) => pkg.id)
              .toList();
          if (unusedPackages != null) {
            removeItemPackageIds.addAll(unusedPackages);
          }
        }
        if (item.packageItems.isNotEmpty) {
          itemPackages.addAll(item.packageItems.toList());
        }
      }
      if (removeItemPackageIds.isNotEmpty) {
        final removed = itemPackageBox.removeMany(removeItemPackageIds);
        log('removeItemPackageIds $removeItemPackageIds => $removed');
      }
      if (itemPackages.isNotEmpty) {
        putItemPackages(itemPackages);
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('PUT ITEMS ERROR => $e => $stackTrace');
      }
    }
  }

  void putItemPackages(List<ItemPackage> itemPackages) {
    if (itemPackages.isEmpty) {
      return;
    }
    if (kDebugMode) {
      print('PUT ITEM PACKAGES');
    }
    List<int> ids = itemPackageBox.putMany(itemPackages);
    if (kDebugMode) {
      print('ITEM PACKAGES HAS BEEN STORED: $ids');
    }
  }

  void putVariants(List<ItemVariant> variants) {
    if (kDebugMode) {
      print('PUT VARIANTS');
    }
    List<int> ids = itemVariantBox.putMany(variants);
    if (kDebugMode) {
      print('VARIANTS HAS BEEN STORED: $ids');
    }
  }

  int getTotalItem({
    String idCategory = '',
    FilterStock? filterStock = FilterStock.all,
    bool? isPromo = false,
  }) {
    Condition<Item> itemQuery = Item_.isActive.equals(true);

    if (idCategory != '' && idCategory != 'promo') {
      itemQuery = itemQuery.and(Item_.idCategory.equals(idCategory));
    }
    if (filterStock == FilterStock.available) {
      itemQuery = itemQuery.and(Item_.stockItem.greaterThan(0));
    } else if (filterStock == FilterStock.empty) {
      itemQuery = itemQuery.and(Item_.stockItem.lessOrEqual(0));
    }
    if (isPromo == true) {
      itemQuery = itemQuery.and(Item_.hasPromo.equals(true));
    }
    final result = itemBox.query(itemQuery).build().count();

    return result;
  }

  void putPromotions(List<Promotion> promotions) {
    if (promotions.isNotEmpty) {
      promotionBox.removeAll();
      promotionBox.putMany(promotions);
    }
    log(
      '${promotions.length} PROMOTIONS HAS BEEN STORED\n${promotions.map((p) => p.name)}',
    );
  }

  /// Stores an offline transaction in the local database.
  /// If a transaction with the same transaction number already exists, it is updated.
  /// The cart data is serialized to a JSON string before storage.
  Future<List<Cart>> putTransaction(Cart transaction) async {
    try {
      final ids = transactionBox
          .query(
            OfflineTransaction_.transactionNo.equals(transaction.transactionNo),
          )
          .build()
          .findIds();
      final int id = ids.isEmpty ? 0 : ids.first;
      final offlinedTransaction = OfflineTransaction(
        id: id,
        transactionNo: transaction.transactionNo,
        shiftId: transaction.shiftId,
        transaction: jsonEncode(
          transaction
              .copyWith(
                isOffline: true,
                payments: transaction.payments
                    .map(
                      (p) =>
                          p.copyWith(createdAt: p.createdAt ?? DateTime.now()),
                    )
                    .toList(),
              )
              .toJson(),
        ),
      );
      log('Transaction Stored to DB: ${offlinedTransaction.transaction}');
      await transactionBox.putAsync(offlinedTransaction);
      final transactions = await offlineTransactions();
      log(
        'Stored Offline Transactions: ${transactions.map((t) => t.transactionNo)}',
      );
      return transactions;
    } catch (e) {
      log('Error storing transaction: $e');
      rethrow;
    }
  }

  Future<List<Cart>> offlineTransactions({
    String? shiftId,
    String? transactionNo,
  }) async {
    Condition<OfflineTransaction> condition = OfflineTransaction_.id
        .greaterThan(0)
        .and(OfflineTransaction_.transactionNo.notNull());
    if (shiftId != null && shiftId.isNotEmpty) {
      condition.and(OfflineTransaction_.shiftId.equals(shiftId));
    }
    if (transactionNo != null && transactionNo.isNotEmpty) {
      condition.and(
        OfflineTransaction_.transactionNo.contains(
          transactionNo,
          caseSensitive: false,
        ),
      );
    }
    final builder = transactionBox.query();
    final offlineTransactions = await builder.build().findAsync();
    List<Cart> transactions = [];
    for (var i = 0; i < offlineTransactions.length; i++) {
      Cart cart = Cart.fromJson(jsonDecode(offlineTransactions[i].transaction));
      if (cart.transactionNo.isNotEmpty && cart.idOutlet.isNotEmpty) {
        transactions.add(cart);
      }
    }
    return transactions;
  }

  Future<int> deleteOfflineTransactions(List<String> idTransactions) async {
    int removed = await transactionBox
        .query(OfflineTransaction_.transactionNo.oneOf(idTransactions))
        .build()
        .removeAsync();
    return removed;
  }

  void clearAll() {
    categoryBox.removeAll();
    itemBox.removeAll();
    itemVariantBox.removeAll();
    itemPackageBox.removeAll();
    promotionBox.removeAll();
    transactionBox.removeAll();
  }
}

late ObjectBox objectBox;

Future initObjectBox() async {
  objectBox = await ObjectBox.create();
}
