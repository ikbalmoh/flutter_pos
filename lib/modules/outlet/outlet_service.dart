import 'package:get_storage/get_storage.dart';
import 'package:selleri/data/network/api.dart' show OutletApi;
import 'package:selleri/models/outlet_config.dart';

class OutletService {
  final api = OutletApi();
  final GetStorage box = GetStorage();

  Future outlets() async {
    return await api.outlets();
  }

  Future<OutletConfig> configs(String idOutlet) async {
    final res = await api.configs(idOutlet);
    return OutletConfig.fromJson(res['data']);
  }
}
