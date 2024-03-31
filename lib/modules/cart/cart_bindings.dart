import 'package:get/get.dart';
import 'package:selleri/modules/cart/cart.dart';

class CartBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CartController(), fenix: true);
  }
}
