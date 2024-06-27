import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:selleri/data/constants/store_key.dart';
import 'package:selleri/utils/fetch.dart';
import 'package:selleri/config/api_url.dart';

const storage = FlutterSecureStorage();

class OutletApi {
  final api = fetch();

  Future outlets() async {
    final res = await api.get(ApiUrl.outlets, queryParameters: {'is_app': 1});
    return res.data;
  }

  Future<Map<String, dynamic>> configs(String id) async {
    final res = await api.get('${ApiUrl.outletConfig}/$id');
    return res.data['data'];
  }

  Future<dynamic> storeFcmToken(
      {required String token, required String outletId}) async {
    String? deviceId = await storage.read(key: StoreKey.device.toString());

    Map<String, dynamic> data = {
      "device_id": deviceId,
      "outlet_id": outletId,
      "fcm_token": token
    };

    try {
      final res = await api.post(ApiUrl.storeFcmToken, data: data);
      return res.data;
    } on DioException catch (e) {
      throw Exception(e);
    } catch (e) {
      rethrow;
    }
  }
}
