import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/features/auth/model/token.dart';
import 'package:selleri/shared/provider/app_config_provider.dart';
import 'package:selleri/shared/model/app_config.dart' as config_model;
import 'package:selleri/shared/utils/fetch.dart';
import 'package:selleri/shared/router/api_url.dart';

class AuthApi {
  final Dio api;
  final config_model.AppConfig? config;

  AuthApi({required this.api, required this.config});

  Future<dynamic> login(String username, String password) async {
    final data = {
      'username': username,
      'password': password,
      'grant_type': config?.grantType,
      'client_id': config?.clientId,
      'client_secret': config?.clientSecret,
    };
    final res = await api.post(ApiUrl.auth, data: data);

    return res.data;
  }

  Future user({String? accessToken}) async {
    final res = await api.get(
      ApiUrl.user,
      options: accessToken != null
          ? Options(headers: {'Authorization': 'Bearer $accessToken'})
          : null,
    );
    return res.data;
  }

  Future resetPassword(String email) async {
    final res = await api.post(ApiUrl.resetPassword, data: {'email': email});
    return res.data['success'] ?? false;
  }

  Future<Token> refreshToken(String refreshToken) async {
    final res = await api.post(
      ApiUrl.refreshToken,
      data: {'refresh_token': refreshToken},
    );
    return Token.fromJson(res.data);
  }

  Future<void> logout() async {
    await api.post(ApiUrl.logout);
  }
}

final authApiProvider = Provider<AuthApi>((ref) {
  final api = ref.watch(apiProvider);
  final config = ref.read(appConfigProvider).requireValue;
  return AuthApi(api: api, config: config);
});
