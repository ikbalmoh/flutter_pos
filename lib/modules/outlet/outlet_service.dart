import 'package:get_storage/get_storage.dart';
import 'package:selleri/data/network/api.dart' show OutletApi;
import 'package:selleri/data/models/outlet.dart';
import 'package:selleri/data/models/outlet_config.dart';

class OutletService {
  final api = OutletApi();
  final GetStorage box = GetStorage();

  Future<List<Outlet>> outlets() async {
    final json = await api.outlets();
    return List<Outlet>.from(json['data'].map((o) => Outlet.fromJson(o)));
  }

  Future<OutletConfig> configs(String idOutlet) async {
    final json = await api.configs(idOutlet);
    return OutletConfig.fromJson(json['data']);
  }
}
