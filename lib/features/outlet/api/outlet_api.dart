import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:selleri/features/outlet/model/refund_reason.dart';
import 'package:selleri/shared/constants/store_key.dart';
import 'package:selleri/features/outlet/model/outlet.dart';
import 'package:selleri/shared/utils/fetch.dart';
import 'package:selleri/shared/router/api_url.dart';

const storage = FlutterSecureStorage();

abstract class OutletApiBase {
  Future<List<Outlet>> outlets();
  Future<Map<String, dynamic>> configs(String id, {List<String>? only});
  Future<Map<String, dynamic>> info(String id);
  Future<dynamic> storeFcmToken({
    required String token,
    required String outletId,
  });
  Future<List<RefundReason>> refundReasons();
}

class OutletApi implements OutletApiBase {
  final Dio api;

  OutletApi({required this.api});

  @override
  Future<List<Outlet>> outlets() async {
    try {
      final res = await api.get(ApiUrl.outlets, queryParameters: {'is_app': 1});
      List<Outlet> outlets = List<Outlet>.from(
        res.data['data'].map((o) => Outlet.fromJson(o)),
      );
      return outlets;
    } on DioException catch (e) {
      throw e.message!;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> configs(
    String id, {
    List<String>? only = const [],
  }) async {
    try {
      Map<String, dynamic> params = {"only[]": only};
      final res = await api.get(
        '${ApiUrl.outletConfig}/$id',
        queryParameters: params,
      );
      return res.data['data'];
    } on DioException catch (e) {
      throw e.message!;
    } catch (e) {
      rethrow;
    }
  }

  @override
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
      throw e.message!;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> storeFcmToken({
    required String token,
    required String outletId,
  }) async {
    String? deviceId = await storage.read(key: StoreKey.device.name);

    Map<String, dynamic> data = {
      "device_id": deviceId,
      "outlet_id": outletId,
      "fcm_token": token,
    };

    try {
      final res = await api.post(ApiUrl.storeFcmToken, data: data);
      return res.data;
    } on DioException catch (e) {
      throw e.message!;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<RefundReason>> refundReasons({String? module = 'delete_hold'}) async {
    try {
      final res = await api.get(ApiUrl.refundReasons, queryParameters: {
        'module': module,
      });
      log('reasons data: ${res.data}');
      List<RefundReason> refundReasons = List<RefundReason>.from(
        res.data.map(
          (o) => RefundReason.fromOption(o),
        ),
      );
      return refundReasons;
    } on DioException catch (e) {
      throw e.message!;
    } catch (e) {
      rethrow;
    }
  }
}

final outletApiProvider = Provider<OutletApi>((ref) {
  final api = ref.watch(apiProvider);
  return OutletApi(api: api);
});
