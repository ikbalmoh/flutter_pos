import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/shared/constants/app_config.dart';
import 'package:selleri/shared/utils/fetch.dart';
import 'package:selleri/shared/router/api_url.dart';

class AuthApi {
  final Dio api;

  AuthApi({required this.api});

  Future<dynamic> login(
    String username,
    String password,
  ) async {
    final data = {
      'username': username,
      'password': password,
      'grant_type': AppConfig.grantType,
      'client_id': AppConfig.clientId,
      'client_secret': AppConfig.clientSecret,
    };
    final res = await api.post(ApiUrl.auth, data: data);

    return res.data;
  }

  Future user() async {
    final res = await api.get(ApiUrl.user);
    return res.data;
  }

  Future resetPassword(String email) async {
    final res = await api.post(ApiUrl.resetPassword, data: {
      'email': email,
    });
    return res.data['success'] ?? false;
  }

  Future<void> logout() async {
    await api.post(ApiUrl.logout);
  }
}

final authApiProvider = Provider<AuthApi>((ref) {
  final api = ref.watch(apiProvider);
  return AuthApi(api: api);
});
