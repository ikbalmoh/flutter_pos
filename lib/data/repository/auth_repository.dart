import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/data/models/token.dart';
import 'package:selleri/data/models/user.dart';
import 'package:selleri/data/network/auth.dart';
import 'package:selleri/data/repository/token_repository.dart';
import 'package:selleri/providers/auth/auth_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'auth_repository.g.dart';

@riverpod
AuthRepository authRepository(Ref ref) => AuthRepository(ref);

abstract class AuthRepositoryProtocol {
  Future<AuthState> login(String username, String password);
  Future<void> logout();
}

class AuthRepository implements AuthRepositoryProtocol {
  AuthRepository(this._ref);

  final Ref _ref;

  @override
  Future<AuthState> login(String username, String password) async {
    final TokenRepository tokenRepository = _ref.read(tokenRepositoryProvider);

    final api = _ref.watch(authApiProvider);

    try {
      final response = await api.login(username, password);

      final Token token = Token.fromJson(response);

      await tokenRepository.saveToken(token);

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

  Future<User?> fetchUser() async {
    final api = _ref.watch(authApiProvider);

    try {
      final json = await api.user();
      return User.fromJson(json);
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
