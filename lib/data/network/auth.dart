import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/utils/fetch.dart';
import 'package:selleri/config/api_url.dart';

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
      'grant_type': dotenv.env['GRANT_TYPE'],
      'client_id': dotenv.env['CLIENT_ID'],
      'client_secret': dotenv.env['CLIENT_SECRET'],
    };
    final res = await api.post(ApiUrl.auth, data: data);

    return res.data;
  }

  Future user() async {
    final res = await api.get(ApiUrl.user);
    return res.data;
  }

  Future<void> logout() async {
    await api.post(ApiUrl.logout);
  }
}

final authApiProvider = Provider<AuthApi>((ref) {
  final api = ref.watch(apiProvider);
  return AuthApi(api: api);
});
