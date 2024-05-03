import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:selleri/data/models/cart.dart';
import 'package:selleri/modules/auth/auth.dart';
import 'package:selleri/modules/outlet/outlet.dart';

class CartController extends GetxController {
  OutletController outletController = Get.find();
  AuthController authController = Get.find();

  final GetStorage box = GetStorage();

  final _cart = Rxn<Cart>();

  Cart? get cart => _cart.value;

  int get totalQty => cart?.items.length ?? 0;

  @override
  void onInit() {
    // initNewCart();
    super.onInit();
  }
}
