// ignore_for_file: avoid_manual_providers_as_generated_provider_dependency
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/data/models/category.dart';
import 'package:selleri/data/models/item.dart';
import 'package:selleri/data/models/item_attribute_variant.dart';
import 'package:selleri/data/models/item_variant.dart';
import 'package:selleri/data/network/item.dart';
import 'package:selleri/data/objectbox.dart';
import 'package:selleri/data/repository/item_repository.dart';
import 'package:selleri/providers/promotion/promotions_provider.dart';
import 'package:selleri/utils/app_alert.dart';

part 'item_provider.g.dart';

@Riverpod(keepAlive: true)
class ItemsStream extends _$ItemsStream {
  @override
  Stream<List<Item>> build({
    String idCategory = '',
    String search = '',
    FilterStock filterStock = FilterStock.all,
  }) {
    return objectBox.itemsStream(
      idCategory: idCategory,
      search: search,
      filterStock: filterStock,
    );
  }

  Future<List<Category>> syncCategories() async {
    final ItemRepository itemRepository = ref.read(itemRepositoryProvider);
    List<Category> categories = await itemRepository.fetchCategoris();
    return categories;
  }

  Future<void> loadItems({
    bool refresh = false,
    bool fullSync = false,
    Function(String progress)? progressCallback,
  }) async {
    log('LOAD ITEMS: $refresh');
    final ItemRepository itemRepository = ref.read(itemRepositoryProvider);

    if (progressCallback != null) {
      progressCallback('loading_x'.tr(args: ['categories'.tr()]));
    }
    List<Category> categories = await syncCategories();

    if (progressCallback != null) {
      progressCallback('loading_x'.tr(args: ['promotions'.tr()]));
    }
    await ref.read(promotionsProvider.notifier).loadPromotions();

    if (refresh || objectBox.itemBox.isEmpty()) {
      for (var i = 0; i < categories.length; i++) {
        Category category = categories[i];
        if (progressCallback != null) {
          progressCallback(
              'loading_categories_items'.tr(args: [category.categoryName]));
        }

        final DateTime startLoad = DateTime.now();
        List<Item> items = await itemRepository.fetchItems(
          idCategory: category.idCategory,
          fullSync: fullSync,
        );
        final DateTime startSave = DateTime.now();
        objectBox.putItems(items);
        final DateTime endSate = DateTime.now();
        log('${items.length} ITEMS LOADED\n => Category: ${category.categoryName}\n => Load : ${startSave.difference(startLoad).inMilliseconds}ms\n => Save : ${endSate.difference(startSave).inMilliseconds}ms');
      }
    } else {
      await syncItems();
    }
  }

  void saveJsonItems(List<dynamic> jsonItems,
      {bool showUpdateMessage = false}) {
    List<Item> items = [];
    for (var json in jsonItems) {
      try {
        Item item = Item.fromJson(json);
        items.add(item);
      } catch (e) {
        log('parse item failed: $e');
      }
    }
    if (items.isNotEmpty) {
      objectBox.putItems(items);
    }
    if (showUpdateMessage) {
      List<String> messages = [items[0].itemName];
      if (items.length > 2) {
        messages.add(items[1].itemName);
        messages.add('and_x_others'.tr(args: [(items.length - 2).toString()]));
      } else if (items.length > 1) {
        messages.add("${'and'.tr()} ${items[1].itemName}");
      }
      messages.add('synced'.tr().toLowerCase());
      AppAlert.toast(messages.join(' '));
    }
  }

  Future<void> syncItems() async {
    if (objectBox.categoryBox.isEmpty()) {
      await loadItems();
    } else {
      log('SYNC ITEMS');

      List<Item> items =
          await ref.read(itemRepositoryProvider).fetchItems(fromLastSync: true);

      objectBox.putItems(items);
      log('SYNCED ITEMS: $items');
      if (items.isNotEmpty) {
        List<String> messages = [items[0].itemName];
        if (items.length > 2) {
          messages.add(', ${items[1].itemName}');
          messages
              .add('and_x_others'.tr(args: [(items.length - 2).toString()]));
        } else if (items.length > 1) {
          messages.add("${'and'.tr()} ${items[1].itemName}");
        }
        messages.add('synced'.tr().toLowerCase());
        AppAlert.toast(messages.join(' '));
      }
    }

    await ref.read(promotionsProvider.notifier).loadPromotions();
  }

  double getItemStock(String idItem) {
    final item = objectBox.getItem(idItem);
    return item?.stockItem ?? 0;
  }

  Future<Item> storeItem(Map<String, dynamic> itemPayload,
      List<AttributeVariant> attributes) async {
    final api = ref.watch(itemApiProvider);

    try {
      if (attributes.isNotEmpty) {
        List<Map<String, dynamic>> variants =
            attributes.asMap().entries.map<Map<String, dynamic>>((attr) {
          var idx = attr.key;
          var value = attr.value;
          return {
            'attr_name': value.attrName,
            'options': value.options.map((opt) {
              return {'option_name': opt};
            }).toList(),
            'is_primary': idx == 0 ? true : false,
          };
        }).toList();
        itemPayload['variants'] = {'attributes': variants};
      }

      Item item = await api.storeItem(itemPayload);

      objectBox.putItems([item]);

      return item;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<ItemVariant>> updateVariants(
      String idItem, List<ItemVariant> variants) async {
    try {
      final api = ref.watch(itemApiProvider);
      List<Map<String, dynamic>> attributes =
          variants.map<Map<String, dynamic>>((v) {
        return {
          "id_variant": v.idVariant,
          "item_price": v.itemPrice,
          "sku_number": v.skuNumber,
          "barcode_number": v.barcodeNumber
        };
      }).toList();
      final updatedVariants = await api.updateItemVariants(idItem, attributes);
      objectBox.putVariants(updatedVariants);
      return updatedVariants;
    } catch (e) {
      throw Exception(e);
    }
  }

  bool isScannedItemStockAvailable(ScanItemResult result) {
    if (result.item != null) {
      if (result.item!.stockControl == false) {
        return false;
      }
      if (result.variant != null) {
        return result.variant!.stockItem > 0;
      }
      return result.item!.stockItem > 0;
    }
    return false;
  }
}
