import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/shared/objectbox.dart';
import 'package:selleri/features/item/model/category.dart' as model;

part 'category_provider.g.dart';

@Riverpod(keepAlive: true)
class Category extends _$Category {
  @override
  Stream<List<model.Category>> build({bool? onlyHasItems = false}) {
    return objectBox.categoriesStream();
  }
}
