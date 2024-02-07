import 'package:get/get.dart';
import 'package:selleri/modules/auth/auth.dart';
import 'package:selleri/modules/outlet/outlet.dart';

class AuthBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OutletController(OutletService()));
    Get.lazyPut(() => AuthController(AuthService()), fenix: true);
  }
}
