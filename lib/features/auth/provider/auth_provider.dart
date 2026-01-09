import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/shared/objectbox.dart';
import 'package:selleri/features/auth/repository/auth_repository.dart';
import 'package:selleri/features/auth/repository/token_repository.dart';
import 'package:selleri/features/cart/provider/cart_provider.dart';
import 'package:selleri/features/fcm/provider/fcm_provider.dart';
import 'package:selleri/features/item/provider/item_provider.dart';
import 'package:selleri/features/outlet/provider/outlet_provider.dart';
import 'package:selleri/features/shift/provider/shift_provider.dart';
import 'auth_state.dart';

export 'auth_state.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
class Auth extends _$Auth {
  late final AuthRepository _authRepoistory = ref.read(authRepositoryProvider);

  late final TokenRepository _tokenRepository =
      ref.read(tokenRepositoryProvider);

  @override
  FutureOr<AuthState> build() async {
    try {
      final token = await _tokenRepository.fetchToken();
      if (token != null) {
        final user = await _authRepoistory.fetchUser();
        if (user != null) {
          return Authenticated(user: user, token: token);
        }
      }
      return Initialized();
    } on DioException {
      return Initialized();
    } catch (e, st) {
      log('Auth initialization failed; $e\n$st');
      return Initialized();
    }
  }

  Future<void> login(String username, String password) async {
    try {
      state = AsyncData(Authenticating());
      state = AsyncData(await _authRepoistory.login(username, password));
    } catch (e) {
      state = AsyncData(AuthFailure(message: e.toString()));
    }
  }

  Future<bool> resetPassword(String email) async {
    try {
      return await _authRepoistory.resetPassword(email);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout({bool? skipLogout}) async {
    ref.read(fcmProvider.notifier).unsubscribe();
    ref.read(shiftProvider.notifier).shiftLoading();
    try {
      log('API LOGOUT');
      if (skipLogout == true) {
        await _tokenRepository.removeToken();
      } else {
        await _authRepoistory.logout();
      }
      state = AsyncData(UnAuthenticated());
    } catch (e) {
      log('LOGOUT ERROR: $e');
    } finally {
      log('API LOGOUT DONE');
    }
    Future.delayed(const Duration(seconds: 1), () async {
      await ref.read(outletProvider.notifier).clearOutlet();
      objectBox.clearAll();
      ref.invalidate(itemsProvider);
      ref.invalidate(cartProvider);
      ref.invalidate(outletProvider);
      ref.invalidate(shiftProvider);
    });
  }
}
