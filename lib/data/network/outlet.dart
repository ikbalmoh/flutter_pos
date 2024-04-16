import 'package:selleri/utils/fetch.dart';
import 'package:selleri/config/api_url.dart';

class OutletApi {
  final api = fetch();

  Future outlets() async {
    final res = await api.get(ApiUrl.outlets, queryParameters: {'is_app': 1});
    return res.data;
  }

  Future configs(String id) async {
    final res = await api.get('${ApiUrl.outletConfig}/$id');
    return res.data;
  }
}
