import 'package:selleri/utils/fetch.dart';
import 'package:selleri/config/api_url.dart';

class PromotionApi {
  final api = fetch();

  Future promotions(String idOulet) async {
    Map<String, dynamic> query = {
      'is_app': 1,
      'id_outlet': idOulet,
      'status': 1,
    };
    final res = await api.get(ApiUrl.promotions, queryParameters: query);
    return res.data;
  }

  Future promotionByCode(String code, String idOulet) async {
    Map<String, dynamic> query = {
      'code': code,
      'id_outlet': idOulet,
    };
    final res =
        await api.get(ApiUrl.promotionByVoucher, queryParameters: query);
    return res.data;
  }
}
