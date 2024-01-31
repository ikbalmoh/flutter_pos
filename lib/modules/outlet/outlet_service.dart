import 'package:get_storage/get_storage.dart';
import 'package:selleri/data/network/api.dart' show OutletApi;

class OutletService {
  final api = OutletApi();
  final GetStorage box = GetStorage();

  Future outlets() async {
    return await api.outlets();
  }
}
