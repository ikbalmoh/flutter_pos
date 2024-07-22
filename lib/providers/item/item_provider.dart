import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/data/models/category.dart';
import 'package:selleri/data/models/item.dart';
import 'package:selleri/data/objectbox.dart';
import 'package:selleri/data/repository/item_repository.dart';
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

  Future<void> loadItems({
    bool refresh = false,
    Function(String progress)? progressCallback,
  }) async {
    log('LOAD ITEMS: $refresh');
    final ItemRepository itemRepository = ref.read(itemRepositoryProvider);

    if (progressCallback != null) {
      progressCallback('loading_x'.tr(args: ['categories'.tr()]));
    }
    List<Category> categories = await itemRepository.fetchCategoris();

    if (refresh || objectBox.itemBox.isEmpty()) {
      for (var i = 0; i < categories.length; i++) {
        Category category = categories[i];
        if (progressCallback != null) {
          progressCallback(
              'loading_categories_items'.tr(args: [category.categoryName]));
        }

        final DateTime startLoad = DateTime.now();
        List<Item> items =
            await itemRepository.fetchItems(idCategory: category.idCategory);
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
    List<Item> items = List<Item>.from(jsonItems.map(
      (json) => Item.fromJson(json),
    ));
    objectBox.putItems(items);
    if (showUpdateMessage) {
      List<String> messages = [items[0].itemName];
      if (items.length > 1) {
        messages.add('and_x_others'.tr(args: [(items.length - 1).toString()]));
      }
      messages.add('synced'.tr().toLowerCase());
      AppAlert.toast(messages.join(' '));
    }
  }

  Future<void> syncItems() async {
    log('SYNC ITEMS');

    List<Item> items =
        await ref.read(itemRepositoryProvider).fetchItems(fromLastSync: true);

    objectBox.putItems(items);
    log('SYNCED ITEMS: $items');
    if (items.isNotEmpty) {
      List<String> messages = [items[0].itemName];
      if (items.length > 1) {
        messages.add('and_x_others'.tr(args: [(items.length - 1).toString()]));
      }
      messages.add('synced'.tr().toLowerCase());
      AppAlert.toast(messages.join(' '));
    }
  }

  double getItemStock(String idItem) {
    final item = objectBox.getItem(idItem);
    return item?.stockItem ?? 0;
  }
}
