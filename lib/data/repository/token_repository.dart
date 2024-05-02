import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:selleri/data/constants/store_key.dart';
import 'package:selleri/data/models/token.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'token_repository.g.dart';

abstract class TokenRepositoryProtocol {
  Future<void> remove();

  Future<void> saveToken(Token token);

  Future<Token?> fetchToken();
}

@riverpod
TokenRepository tokenRepository(TokenRepositoryRef ref) => TokenRepository();

class TokenRepository implements TokenRepositoryProtocol {
  @override
  Future<void> remove() async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: StoreKey.token.toString());
  }

  @override
  Future<Token?> fetchToken() async {
    const storage = FlutterSecureStorage();
    String? tokenValue = await storage.read(key: StoreKey.token.toString());
    if (tokenValue != null) {
      final jsonToken = json.decode(tokenValue);
      return Token.fromJson(jsonToken);
    }
    return null;
  }

  @override
  Future<void> saveToken(Token token) async {
    const storage = FlutterSecureStorage();
    await storage.write(
        key: StoreKey.token.toString(), value: token.toString());
  }
}
