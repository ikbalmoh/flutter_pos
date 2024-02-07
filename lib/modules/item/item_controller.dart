import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:selleri/models/category.dart';
import 'package:selleri/modules/item/item.dart';
import 'package:selleri/modules/outlet/outlet.dart';
import 'package:selleri/data/objectbox.dart';
import 'package:selleri/data/objectbox.dart' show objectBox;

class ItemController extends GetxController {
  OutletController outletController = Get.find();

  final GetStorage box = GetStorage();

  final ItemService _itemService;

  ItemController(this._itemService);

  final _categoryState = CategoryState().obs;
  final _activeCategory = ''.obs;

  CategoryState get category => _categoryState.value;
  String get activeCategory => _activeCategory.value;

  @override
  void onInit() {
    if (objectBox.categories().isEmpty) {
      loadCategories();
    }
    super.onInit();
  }

  Future loadCategories() async {
    try {
      _categoryState.value = CategoryLoading();
      List<Category> categories = await _itemService
          .categories(outletController.activeOutlet.value!.idOutlet);
      _categoryState.value = CategoryLoaded();
      objectBox.putCategories(categories);
    } on Exception catch (e) {
      _categoryState.value = LoadCategoryFailed(message: e.toString());
    }
  }
}
