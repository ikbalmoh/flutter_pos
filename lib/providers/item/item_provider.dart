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
  Stream<List<Item>> build({String idCategory = '', String search = ''}) {
    return objectBox.itemsStream(idCategory: idCategory, search: search);
  }

  Future<void> loadItems({bool refresh = false}) async {
    final ItemRepository itemRepository = ref.read(itemRepositoryProvider);

    if (!refresh && !objectBox.itemBox.isEmpty()) {
      return syncItems();
    }

    List<Category> categories = await itemRepository.fetchCategoris();
    for (var i = 0; i < categories.length; i++) {
      Category category = categories[i];
      List<Item> items =
          await itemRepository.fetchItems(idCategory: category.idCategory);

      objectBox.putItems(items);
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
  }
}
