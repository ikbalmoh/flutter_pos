import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/data/objectbox.dart';
import 'package:selleri/data/models/category.dart';

part 'category_provider.g.dart';

@Riverpod(keepAlive: true)
class CategoriesStream extends _$CategoriesStream {
  @override
  Stream<List<Category>> build() {
    return objectBox.categoriesStream();
  }
}
