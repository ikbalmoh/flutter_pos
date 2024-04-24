import 'package:get/get.dart';
import 'package:selleri/modules/auth/auth.dart';
import 'package:selleri/modules/outlet/outlet.dart';

class AuthBindings implements Bindings {
  AuthBindings();

  @override
  void dependencies() {
    Get.lazyPut(() => OutletController(OutletService()), fenix: true);
    Get.lazyPut(() => AuthController(AuthService()), fenix: true);
  }
}
