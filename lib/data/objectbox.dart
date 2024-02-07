import 'package:selleri/models/category.dart';
import 'package:selleri/objectbox.g.dart';

class ObjectBox {
  late final Store store;

  late final Box<Category> categoryBox;

  ObjectBox._create(this.store) {
    categoryBox = Box<Category>(store);
  }

  static Future<ObjectBox> create() async {
    final store = await openStore();
    return ObjectBox._create(store);
  }

  List<Category> categories() {
    return categoryBox.getAll();
  }

  Stream<List<Category>> categoriesStream() {
    final builder = categoryBox.query()..order(Category_.categoryName);
    return builder.watch(triggerImmediately: true).map((query) => query.find());
  }

  void putCategories(List<Category> categories) {
    categoryBox.removeAll();
    categoryBox.putMany(categories);
  }
}

late ObjectBox objectBox;

Future initObjectBox() async {
  objectBox = await ObjectBox.create();
}
