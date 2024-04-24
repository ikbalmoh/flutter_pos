import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:selleri/models/user.dart';
import 'package:selleri/models/outlet.dart';
import 'package:selleri/modules/auth/auth.dart';
import 'package:selleri/modules/outlet/outlet.dart';
import 'package:selleri/routes/routes.dart';
import 'package:selleri/utils/app.dart';

class AuthController extends GetxController {
  final GetStorage box = GetStorage();

  final AuthService _service;
  OutletController outletController = Get.find();

  AuthController(this._service);

  final _authState = const AuthState().obs;

  AuthState get state => _authState.value;

  @override
  void onInit() {
    super.onInit();

    // Route Redirection
    ever(_authState, (state) async {
      if (kDebugMode) {
        print('AUTH STATE CHANGED: $state');
        if (state is Authenticated) {
          print('TOKEN: ${box.read('access_token')}');
          if (Get.currentRoute != Routes.home) {
            await Future.delayed(const Duration(seconds: 1));
            if (box.hasData('outlet')) {
              outletController
                  .selectOutlet(Outlet.fromJson(box.read('outlet')));
            } else {
              Get.offAllNamed(
                Routes.outlet,
                predicate: (route) => Get.currentRoute == Routes.outlet,
              );
            }
          }
        } else if (state is UnAuthenticated || state is AuthFailure) {
          if (Get.currentRoute != Routes.login) {
            await Future.delayed(const Duration(seconds: 1));
            _clearAuth();
            Get.offAllNamed(
              Routes.login,
              predicate: (route) => Get.currentRoute == Routes.login,
            );
          }
        }
      }
    });
  }

  Future init() async {
    _authState.value = AuthLoading();
    if (box.hasData('access_token') && box.hasData('user')) {
      _checkAuthenticatedUser();
    } else {
      _clearAuth();
    }
  }

  Future login(String username, String password) async {
    _authState.value = AuthLoading();

    try {
      final data = await _service.login(username, password);

      box.write('access_token', data['access_token']);
      box.write('expires_in', data['expires_in']);
      box.write('refresh_token', data['refresh_token']);

      final dataUser = await _service.user();
      final user = User.fromJson(dataUser);

      box.write('user', user.toJson());

      _authState.value = Authenticated(user: user, token: data['access_token']);
    } on DioException catch (e) {
      String message = e.response?.data['message'] ?? e.message;
      _clearAuth(error: message);
    } on PlatformException catch (e) {
      _clearAuth(error: e.message);
    }
  }

  void _checkAuthenticatedUser() async {
    _authState.value = AuthLoading();
    try {
      final dataUser = await _service.user();
      final user = User.fromJson(dataUser);
      if (kDebugMode) {
        print('USER AUTHENTICATED: ${user.toString()}');
      }
      _authState.value =
          Authenticated(user: user, token: box.read('access_token'));
    } on DioException catch (e) {
      if (kDebugMode) {
        print('AUTH ERROR: $e');
      }
      String message = e.response?.data['message'] ?? e.message;
      _clearAuth(error: message);
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('AUTH ERROR: $e');
      }
      _clearAuth(error: e.message);
    }
  }

  void _clearAuth({String? error}) async {
    if (error != null) {
      _authState.value = AuthFailure(message: error);
      App.showSnackbar(
        'auth_failed'.tr,
        error,
        alertType: AlertType.error,
      );
    } else {
      _authState.value = UnAuthenticated();
    }

    box.remove('user');
    box.remove('access_token');
    box.remove('outlet');
  }

  Future logout() async {
    Get.defaultDialog(
      backgroundColor: Colors.white,
      titlePadding: const EdgeInsets.only(top: 20),
      contentPadding: const EdgeInsets.all(20),
      title: 'Logout',
      content: const Text('Apakah Anda ingin keluar dari aplikasi?'),
      confirm: TextButton(
        onPressed: () {
          Get.back();
          _clearAuth();
        },
        style: TextButton.styleFrom(foregroundColor: Colors.red),
        child: const Text('Logout'),
      ),
      cancel: TextButton(
        onPressed: () => Get.back(),
        style: TextButton.styleFrom(foregroundColor: Colors.grey.shade800),
        child: const Text('Tidak'),
      ),
    );
  }
}
