import 'package:get_storage/get_storage.dart';
import 'package:selleri/data/network/api.dart' show AuthApi;

class AuthService {
  final api = AuthApi();
  final GetStorage box = GetStorage();

  Future login(String username, String password) async {
    return await api.login(username, password);
  }

  Future user() async {
    return await api.user();
  }
}
