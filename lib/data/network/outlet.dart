import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:selleri/data/constants/store_key.dart';
import 'package:selleri/data/models/outlet.dart';
import 'package:selleri/utils/fetch.dart';
import 'package:selleri/config/api_url.dart';

const storage = FlutterSecureStorage();

class OutletApi {
  final api = fetch();

  Future<List<Outlet>> outlets() async {
    try {
      final res = await api.get(ApiUrl.outlets, queryParameters: {'is_app': 1});
      List<Outlet> outlets =
          List<Outlet>.from(res.data['data'].map((o) => Outlet.fromJson(o)));
      return outlets;
    } on DioException catch (e) {
      throw e.response?.data['msg'] ?? e.message;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> configs(
    String id, {
    List<String>? only = const [],
  }) async {
    try {
      Map<String, dynamic> params = {"only[]": only};
      final res =
          await api.get('${ApiUrl.outletConfig}/$id', queryParameters: params);
      return res.data['data'];
    } on DioException catch (e) {
      throw e.response?.data['msg'] ?? e.message;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> info(String id) async {
    try {
      String? deviceId = await storage.read(key: StoreKey.device.name);
      String? deviceName = await storage.read(key: StoreKey.deviceName.name);

      final Map<String, dynamic> queryParameters = {
        'device_id': deviceId,
        'device_name': deviceName,
      };

      final res = await api.get(
        '${ApiUrl.outletInfo}/$id',
        queryParameters: queryParameters,
      );
      return res.data;
    } on DioException catch (e) {
      throw e.response?.data['msg'] ?? e.message;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> storeFcmToken(
      {required String token, required String outletId}) async {
    String? deviceId = await storage.read(key: StoreKey.device.name);

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

  Future<Map<String, dynamic>> configs(String id) async {
    final res = await api.get('${ApiUrl.outletConfig}/$id');
    return res.data['data'];
  }
}
