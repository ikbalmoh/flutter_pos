import 'package:selleri/utils/fetch.dart';
import 'package:selleri/config/api_url.dart';

class ItemApi {
  final api = fetch();

  Future categories(String idOulet) async {
    Map<String, dynamic> query = {'is_app': 1, 'id_outlet': idOulet};
    final res = await api.get(ApiUrl.listCategory, queryParameters: query);
    return res.data;
  }

  Future items(String idOutlet, {String? idCategory}) async {
    Map<String, dynamic> query = {
      'is_app': 1,
      'id_outlet': idOutlet,
    };
    if (idCategory != null) {
      query['id_category'] = idCategory;
    }
    final res = await api.get(ApiUrl.listItems, queryParameters: query);
    return res.data;
  }
}
