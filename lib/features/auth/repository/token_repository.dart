import 'dart:convert';
import 'package:selleri/shared/constants/store_key.dart';
import 'package:selleri/features/auth/model/token.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'token_repository.g.dart';

abstract class TokenRepositoryProtocol {
  Future<void> removeToken();

  Future<void> saveToken(Token token);

  Future<Token?> fetchToken();
}

@riverpod
TokenRepository tokenRepository(Ref ref) => TokenRepository();

class TokenRepository implements TokenRepositoryProtocol {
  @override
  Future<void> removeToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.remove(StoreKey.token.name);
    await prefs.remove(StoreKey.fcmSubscribe.name);
  }

  @override
  Future<Token?> fetchToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String? tokenValue = prefs.getString(StoreKey.token.name);
    if (tokenValue != null) {
      final jsonToken = json.decode(tokenValue);
      return Token.fromJson(jsonToken);
    }
    return null;
  }

  @override
  Future<void> saveToken(Token token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(StoreKey.token.name, token.toString());
  }
}
