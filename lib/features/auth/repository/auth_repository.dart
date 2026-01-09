import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/features/auth/model/token.dart';
import 'package:selleri/features/auth/model/user.dart';
import 'package:selleri/features/auth/api/auth_api.dart';
import 'package:selleri/features/outlet/repository/outlet_repository.dart';
import 'package:selleri/features/auth/repository/token_repository.dart';
import 'package:selleri/features/auth/provider/auth_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/shared/constants/store_key.dart';

part 'auth_repository.g.dart';

@riverpod
AuthRepository authRepository(Ref ref) => AuthRepository(ref);

abstract class AuthRepositoryProtocol {
  Future<AuthState> login(String username, String password);
  Future<void> logout();
  Future<User?> fetchUser();
}

class AuthRepository implements AuthRepositoryProtocol {
  AuthRepository(this._ref);

  final Ref _ref;

  @override
  Future<AuthState> login(String username, String password) async {
    final TokenRepository tokenRepository = _ref.read(tokenRepositoryProvider);
    final OutletRepository outletRepository =
        _ref.read(outletRepositoryProvider);

    final api = _ref.watch(authApiProvider);

    try {
      final response = await api.login(username, password);

      final Token token = Token.fromJson(response);

      await tokenRepository.saveToken(token);
      await outletRepository.remove();

      User? user = await fetchUser();
      if (user != null) {
        return Authenticated(user: user, token: token);
      }
      return const AuthFailure(message: 'user authentication failed');
    } on DioException catch (e) {
      return AuthFailure(message: e.message!);
    } on PlatformException catch (e) {
      await tokenRepository.removeToken();
      return AuthFailure(message: e.message ?? e.toString());
    }
  }

  @override
  Future<User?> fetchUser() async {
    const storage = FlutterSecureStorage();
    String? userString = await storage.read(key: StoreKey.user.name);

    if (userString != null) {
      final jsonUser = json.decode(userString);
      final user = User.fromJson(jsonUser);
      log('Offline User: $userString');
      return user;
    }

    final api = _ref.watch(authApiProvider);

    try {
      final json = await api.user();
      final user = User.fromJson(json);
      log('Online User: ${user.toString()}');
      await storage.write(key: StoreKey.user.name, value: user.toString());
      return user;
    } on DioException catch (e) {
      throw e.message!;
    } catch (e) {
      log('fetch user failed: $e');
      storage.delete(key: StoreKey.user.name);
      rethrow;
    }
  }

  Future<bool> resetPassword(String email) async {
    final api = _ref.watch(authApiProvider);

    try {
      final status = await api.resetPassword(email);
      return status;
    } on DioException catch (e) {
      throw e.message!;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    final api = _ref.watch(authApiProvider);

    try {
      await api.logout();
    } on DioException catch (e) {
      throw e.message!;
    } catch (e) {
      log('API LOGOUT ERROR: $e');
    } finally {
      _ref.read(tokenRepositoryProvider).removeToken();
    }
  }
}
