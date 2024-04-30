import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:selleri/data/models/category.dart';
import 'package:selleri/data/models/item.dart';
import 'package:selleri/data/models/outlet.dart';
import 'package:selleri/modules/item/item.dart';
import 'package:selleri/modules/outlet/outlet.dart';
import 'package:selleri/data/objectbox.dart' show objectBox;

class ItemController extends GetxController {
  OutletController outletController = Get.find();

  final GetStorage box = GetStorage();

  final ItemService _itemService;

  ItemController(this._itemService);

  final _categoryState = CategoryState().obs;
  final _itemState = ItemState().obs;

  CategoryState get category => _categoryState.value;
  ItemState get item => _itemState.value;

  @override
  void onInit() async {
    if (objectBox.categoryBox.count() == 0) {
      await loadCategories();
    }
    if (objectBox.itemBox.count() == 0) {
      loadItems();
    } else {
      if (kDebugMode) {
        print('${objectBox.itemBox.count()} ITEMS ALREADY ON DB');
      }
    }
    super.onInit();
  }

  Future loadCategories() async {
    try {
      Outlet? outlet = outletController.outlet is OutletSelected ? (outletController.outlet as OutletSelected).outlet : null;
      if (outlet == null) {
        return;
      }
      _categoryState.value = CategoryLoading();
      List<Category> categories = await _itemService
          .categories(outlet.idOutlet);
      _categoryState.value = CategoryLoaded();
      objectBox.putCategories(categories);
    } on Exception catch (e) {
      _categoryState.value = LoadCategoryFailed(message: e.toString());
    }
  }

  Future loadItems({int page = 1}) async {
    try {
      Outlet? outlet = outletController.outlet is OutletSelected ? (outletController.outlet as OutletSelected).outlet : null;
      if (outlet == null) {
        return;
      }
      String idOutlet = outlet.idOutlet;
      List<Category> categories = objectBox.categories();
      for (var i = 0; i < categories.length; i++) {
        Category category = categories[i];
        List<Item> items =
            await _itemService.items(idOutlet, category.idCategory);

        objectBox.putItems(items);
      }
    } on Exception catch (e) {
      _itemState.value = LoadItemFailed(message: e.toString());
    }
  }
}
