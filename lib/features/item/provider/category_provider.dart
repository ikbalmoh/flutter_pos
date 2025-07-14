import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/shared/objectbox.dart';
import 'package:selleri/features/item/model/category.dart';

part 'category_provider.g.dart';

@Riverpod(keepAlive: true)
class CategoriesStream extends _$CategoriesStream {
  @override
  Stream<List<Category>> build() {
    return objectBox.categoriesStream();
  }
}
