import 'package:get/get.dart';
import 'package:selleri/modules/item/item.dart';

class ItemBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ItemController(ItemService()), fenix: true);
  }
}
