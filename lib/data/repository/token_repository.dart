import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:selleri/data/constants/store_key.dart';
import 'package:selleri/data/models/token.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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
    const storage = FlutterSecureStorage();
    await storage.delete(key: StoreKey.token.name);
  }

  @override
  Future<Token?> fetchToken() async {
    const storage = FlutterSecureStorage();
    String? tokenValue = await storage.read(key: StoreKey.token.name);
    if (tokenValue != null) {
      final jsonToken = json.decode(tokenValue);
      return Token.fromJson(jsonToken);
    }
    return null;
  }

  @override
  Future<void> saveToken(Token token) async {
    const storage = FlutterSecureStorage();
    await storage.write(key: StoreKey.token.name, value: token.toString());
  }
}
