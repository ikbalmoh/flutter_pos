import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/data/models/category.dart';
import 'package:selleri/data/models/item.dart';
import 'package:selleri/data/objectbox.dart';
import 'package:selleri/data/repository/item_repository.dart';

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
      return;
    }

    List<Category> categories = await itemRepository.fetchCategoris();
    for (var i = 0; i < categories.length; i++) {
      Category category = categories[i];
      List<Item> items = await itemRepository.fetchItems(category.idCategory);

      objectBox.putItems(items);
    }
  }
}
