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

  final _outletListState = const OutletListState().obs;
  final activeOutlet = Rxn<Outlet>();

  OutletListState get outletList => _outletListState.value;

  @override
  void onInit() {
    if (box.hasData('outlet')) {
      activeOutlet.value = Outlet.fromJson(box.read('outlet'));
    } else {
      _outletListState.value = OutletLoading();
    }
    super.onInit();
  }

  Future loadOutlets() async {
    _outletListState.value = OutletLoading();
    try {
      final data = await _service.outlets();
      List<Outlet> outlets =
          List<Outlet>.from(data['data'].map((o) => Outlet.fromJson(o)));

      _outletListState.value = OutletListLoaded(outlets: outlets);
    } on DioException catch (e) {
      String message = e.response?.data['message'] ?? e.message;
      _outletListState.value = OutletListFailure(message: message);
    } on PlatformException catch (e) {
      _outletListState.value =
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
      activeOutlet.value = outlet;
      Get.offAllNamed(Routes.home);
    }
  }
}
