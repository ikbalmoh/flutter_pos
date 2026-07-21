import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
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
  Future<User?> fetchUser({String? accessToken});
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

      // Clear cached user so fetchUser hits the API with the fresh token
      const storage = FlutterSecureStorage();
      await storage.delete(key: StoreKey.user.name);

      User? user = await fetchUser(accessToken: token.accessToken);
      if (user != null) {
        return Authenticated(user: user, token: token);
      }
      return const AuthFailure(message: 'user authentication failed');
    } on DioException catch (e) {
      FirebaseAnalytics.instance.logEvent(
        name: 'login_failed',
        parameters: {
          'username': username,
          'error_type': 'DioException',
          'status_code': e.response?.statusCode?.toString() ?? 'unknown',
          'message': e.message ?? 'unknown',
        },
      );
      return AuthFailure(message: e.message!);
    } on PlatformException catch (e, st) {
      await tokenRepository.removeToken();
      FirebaseAnalytics.instance.logEvent(
        name: 'login_failed',
        parameters: {
          'username': username,
          'error_type': 'PlatformException',
          'message': e.message ?? 'unknown',
        },
      );
      FirebaseCrashlytics.instance.recordError(
        e,
        st,
        reason: 'Login PlatformException',
        fatal: false,
        information: ['username: $username'],
      );
      return AuthFailure(message: e.message ?? e.toString());
    } catch (e, st) {
      log('Login failed unexpectedly: $e');
      FirebaseAnalytics.instance.logEvent(
        name: 'login_failed',
        parameters: {
          'username': username,
          'error_type': e.runtimeType.toString(),
          'message': e.toString(),
        },
      );
      FirebaseCrashlytics.instance.recordError(
        e,
        st,
        reason: 'Login unexpected error',
        fatal: false,
        information: ['username: $username'],
      );
      return AuthFailure(message: e.toString());
    }
  }

  @override
  Future<User?> fetchUser({String? accessToken}) async {
    const storage = FlutterSecureStorage();
    String? userString = await storage.read(key: StoreKey.user.name);

    if (userString != null) {
      final jsonUser = json.decode(userString);
      final user = User.fromJson(jsonUser);
      log('Offline User: ${user.user.name}');
      return user;
    }

    final api = _ref.watch(authApiProvider);

    try {
      // When accessToken is provided (e.g. right after login), pass it
      // directly as a header override so we don't depend on
      // FlutterSecureStorage being immediately readable by the interceptor.
      final json = await api.user(
        accessToken: accessToken,
      );
      final user = User.fromJson(json);
      log('Online User: ${user.user.name}');
      await storage.write(key: StoreKey.user.name, value: user.toString());
      return user;
    } on DioException catch (e) {
      log('fetch user DioException: ${e.message}');
      rethrow;
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
