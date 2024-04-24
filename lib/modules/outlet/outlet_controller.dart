import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:selleri/models/outlet.dart';
import 'package:selleri/models/outlet_config.dart';
import 'package:selleri/modules/outlet/outlet.dart';
import 'package:selleri/routes/routes.dart';
import 'package:selleri/utils/app.dart';

class OutletController extends GetxController {
  final GetStorage box = GetStorage();

  final OutletService _service;

  OutletController(this._service);

  final _outletListState = const OutletListState().obs;
  final _outletState = const OutletState().obs;

  OutletListState get outletList => _outletListState.value;
  OutletState get outlet => _outletState.value;

  @override
  void onInit() {
    if (box.hasData('outlet') && _outletState.value is! OutletSelected) {
      selectOutlet(Outlet.fromJson(box.read('outlet')), confirm: false);
    } else {
      _outletListState.value = OutletListLoading();
      _outletState.value = OutletInitial();
    }
    super.onInit();
  }

  Future loadOutlets() async {
    _outletListState.value = OutletListLoading();
    try {
      List<Outlet> outlets = await _service.outlets();

      _outletListState.value = OutletListLoaded(outlets: outlets);
    } on DioException catch (e) {
      String message = e.response?.data['message'] ?? e.message;
      _outletListState.value = OutletListFailure(message: message);
    } on PlatformException catch (e) {
      _outletListState.value =
          OutletListFailure(message: e.message ?? e.toString());
    }
  }

  void selectOutlet(Outlet outlet, {bool confirm = false}) async {
    if (_outletState.value is OutletSelected) {
      return;
    }
    if (confirm) {
      return App.showConfirmDialog(
        title: outlet.outletName,
        subtitle: 'select_outlet_confirm'.tr,
        onConfirm: () {
          Get.back();
          selectOutlet(outlet, confirm: false);
        },
      );
    }
    _outletState.value = OutletLoading();
    try {
      OutletConfig? config = await _service.configs(outlet.idOutlet);

      if (kDebugMode) {
        print('Config $config');
      }
      _outletState.value = OutletSelected(outlet: outlet, config: config);
      box.write('outlet', outlet.toJson());
      box.write('outlet_config', config.toJson());
      if (Get.currentRoute != Routes.home) {
        if (kDebugMode) {
          print('RESET NAV TO HOME');
        }
        Get.offAllNamed(Routes.home,
            predicate: (route) => Get.currentRoute == Routes.home);
      }
    } on DioException catch (e) {
      String message = e.response?.data['message'] ?? e.message;
      _outletState.value = OutletFailure(message: message);
    } on PlatformException catch (e) {
      _outletState.value = OutletFailure(message: e.message ?? e.toString());
    }
  }
}
