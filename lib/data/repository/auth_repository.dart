import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/data/models/token.dart';
import 'package:selleri/data/network/api.dart' show AuthApi;
import 'package:selleri/data/models/user.dart';
import 'package:selleri/data/repository/token_repository.dart';
import 'package:selleri/providers/auth/auth_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class AuthRepositoryProtocol {
  Future<AuthState> login(String username, String password);
  Future<AuthState> logout();
}

final authRepositoryProvider = Provider(AuthRepository.new);

class AuthRepository implements AuthRepositoryProtocol {
  AuthRepository(this._ref);

  final Ref _ref;

  final api = AuthApi();
  final GetStorage box = GetStorage();

  @override
  Future<AuthState> login(String username, String password) async {
    final TokenRepository tokenRepository = _ref.read(tokenRepositoryProvider);

    try {
      final response = await api.login(username, password);

      await tokenRepository.saveToken(Token.fromJson(response));

      User user = await getUser();
      box.write('user', user.toJson());
      return Authenticated(user: user, token: response['access_token']);
    } on DioException catch (e) {
      String message = e.response?.data['message'] ?? e.message;
      await tokenRepository.remove();
      return AuthFailure(message: message);
    } on PlatformException catch (e) {
      await tokenRepository.remove();
      return AuthFailure(message: e.message ?? e.toString());
    }
  }

  Future<User> getUser() async {
    final json = await api.user();
    return User.fromJson(json);
  }

  @override
  Future<AuthState> logout() async {
    final TokenRepository tokenRepository = _ref.read(tokenRepositoryProvider);
    await tokenRepository.remove();

    return Future.delayed(const Duration(seconds: 3), () => UnAuthenticated());
  }
}
