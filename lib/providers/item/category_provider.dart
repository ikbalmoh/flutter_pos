import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/data/objectbox.dart';
import 'package:selleri/data/models/category.dart';
import 'package:selleri/data/repository/item_repository.dart';

part 'category_provider.g.dart';

@Riverpod(keepAlive: true)
class Categories extends _$Categories {
  @override
  Stream<List<Category>> build() {
    return objectBox.categoriesStream();
  }

  late final ItemRepository itemRepository = ref.read(itemRepositoryProvider);

  Future<void> loadCategory() async {
    if (!objectBox.categoryBox.isEmpty()) {
      return;
    }

    final categories = await itemRepository.fetchCategoris();
    objectBox.putCategories(categories);
  }
}
