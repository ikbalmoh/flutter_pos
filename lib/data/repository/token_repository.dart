import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:selleri/data/constants/store_key.dart';
import 'package:selleri/data/models/token.dart';

abstract class TokenRepositoryProtocol {
  Future<void> remove();

  Future<void> saveToken(Token token);

  Future<Token?> fetchToken();
}

final tokenRepositoryProvider = Provider(TokenRepository.new);

class TokenRepository implements TokenRepositoryProtocol {
  TokenRepository(this._ref);

  final Ref _ref;

  @override
  Future<void> remove() async {
    const storage = FlutterSecureStorage();
    try {
      await storage.delete(key: StoreKey.token.toString());
    } on Exception catch (e) {
      print(e);
    }
  }

  @override
  Future<Token?> fetchToken() async {
    const storage = FlutterSecureStorage();
    String? tokenValue = await storage.read(key: StoreKey.token.toString());
    if (tokenValue != null) {
      final jsonToken = json.decode(tokenValue);
      print('TOKEN $jsonToken');
      return Token.fromJson(jsonToken);
    }
    return null;
  }

  @override
  Future<void> saveToken(Token token) async {
    const storage = FlutterSecureStorage();
    try {
      await storage.write(
          key: StoreKey.token.toString(), value: token.toString());
    } on Exception catch (e) {}
  }
}
