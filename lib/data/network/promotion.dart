import 'package:selleri/utils/fetch.dart';
import 'package:selleri/config/api_url.dart';
import 'package:selleri/utils/formater.dart';

class PromotionApi {
  final api = fetch();

  Future promotions(String idOulet) async {
    Map<String, dynamic> query = {
      'is_app': 1,
      'id_outlet': idOulet,
      'status': 1,
      'from': DateTimeFormater.dateToString(DateTime.now(), format: 'y-MM-dd')
    };
    final res = await api.get(ApiUrl.promotions, queryParameters: query);
    return res.data;
  }
}
