import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/utils/fetch.dart';
import 'package:selleri/config/api_url.dart';

class PromotionApi {
  final Dio api;

  PromotionApi({required this.api});

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

final promotionApiProvider = Provider<PromotionApi>((ref) {
  final api = ref.watch(apiProvider);
  return PromotionApi(api: api);
});
