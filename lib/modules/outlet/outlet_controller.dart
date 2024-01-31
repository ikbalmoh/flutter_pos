import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:selleri/models/outlet.dart';
import 'package:selleri/modules/outlet/outlet.dart';
import 'package:selleri/routes/routes.dart';
import 'package:selleri/utils/app.dart';

class OutletController extends GetxController {
  final GetStorage box = GetStorage();

  final OutletService _service;

  OutletController(this._service);

  final _outletState = const OutletState().obs;

  @override
  void onInit() {
    if (box.hasData('outlet')) {
      _outletState.value =
          OutletSelected(outlet: Outlet.fromJson(box.read('outlet')));
    } else {
      _outletState.value = OutletLoading();
    }
    super.onInit();
  }

  OutletState get state => _outletState.value;

  Future loadOutlets() async {
    _outletState.value = OutletLoading();
    try {
      final data = await _service.outlets();
      List<Outlet> outlets =
          List<Outlet>.from(data['data'].map((o) => Outlet.fromJson(o)));

      _outletState.value = OutletListLoaded(outlets: outlets);
    } on DioException catch (e) {
      String message = e.response?.data['message'] ?? e.message;
      _outletState.value = OutletListFailure(message: message);
    } on PlatformException catch (e) {
      _outletState.value =
          OutletListFailure(message: e.message ?? e.toString());
    }
  }

  void selectOutlet(Outlet outlet, {bool confirm = false}) {
    if (confirm) {
      App.showConfirmDialog(
        title: outlet.outletName,
        subtitle: 'select_outlet_confirm'.tr,
        onConfirm: () => selectOutlet(outlet, confirm: false),
      );
    } else {
      box.write('outlet', outlet.toJson());
      _outletState.value = OutletSelected(outlet: outlet);
      Get.offAllNamed(Routes.home);
    }
  }
}
