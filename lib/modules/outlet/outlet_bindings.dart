import 'package:get/get.dart';
import 'package:selleri/modules/outlet/outlet.dart';

class OutletBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OutletController(OutletService()), fenix: true);
  }
}
