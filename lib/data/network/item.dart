import 'package:selleri/utils/fetch.dart';
import 'package:selleri/config/api_url.dart';

class ItemApi {
  final api = fetch();

  Future categories(String idOulet) async {
    Map<String, dynamic> query = {'is_app': 1, 'id_outlet': idOulet};
    final res = await api.get(ApiUrl.listCategory, queryParameters: query);
    return res.data;
  }

  Future items(String idOutlet, {String? idCategory, int? lastUpdate}) async {
    Map<String, dynamic> query = {
      'is_app': 1,
      'id_outlet': idOutlet,
      'last_update': lastUpdate,
    };
    if (idCategory != null) {
      query['id_category'] = idCategory;
    }
    final res = await api.get(ApiUrl.listItems, queryParameters: query);
    return res.data;
  }
}
