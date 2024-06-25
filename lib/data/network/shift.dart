import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:selleri/config/api_url.dart';
import 'package:selleri/data/constants/store_key.dart';
import 'package:selleri/data/models/pagination.dart';
import 'package:selleri/data/models/shift.dart';
import 'package:selleri/data/models/shift_info.dart';
import 'package:selleri/utils/fetch.dart';
import 'package:selleri/utils/formater.dart';

const storage = FlutterSecureStorage();

class ShiftApi {
  final api = fetch();

  Future<Shift?> startShift(Shift shift) async {
    Map<String, dynamic> data = {
      "id": shift.id,
      "outlet_id": shift.outletId,
      "device_id": shift.deviceId,
      "start_shift": DateTimeFormater.dateToString(shift.startShift),
      "open_amount": shift.openAmount,
      "created_by": shift.createdBy
    };
    final res = await api.post('${ApiUrl.shifts}/store', data: [data]);
    List success = res.data['data']['success'];
    if (success.isNotEmpty) {
      return Shift.fromJson(success[0]);
    }
    return null;
  }

  Future<void> currentShift() async {
    String? deviceId = await storage.read(key: StoreKey.device.toString());
    api.get('/info/urrent-shift/$deviceId');
  }

  Future<ShiftInfo?> shiftInfo(String shiftId) async {
    final res = await api.get('${ApiUrl.shifts}/$shiftId');
    return ShiftInfo.fromJson(res.data['data']);
  }

  Future closeShift(String id, Map<String, dynamic> data) async {
    try {
      final Map<String, dynamic> mapData = Map.from(data);
      if (data['images'] != null) {
        for (var i = 0; i < data['images']?.length; i++) {
          final img = data['images'][i];
          mapData['cash_flows[0][images][$i]'] =
              await MultipartFile.fromFile(img.path, filename: img.name);
        }
      }
      log('STORE CLOSE SHIFT: $mapData');
      final FormData formData = FormData.fromMap(mapData);
      final res = await api.post('${ApiUrl.shifts}/$id/closing', data: formData);
      return res;
    } on DioException catch (e) {
      throw Exception(e);
    } catch (e) {
      rethrow;
    }
  }

  Future storeCashflow(Map<String, dynamic> data) async {
    try {
      final Map<String, dynamic> mapData = {
        "cash_flows[0][id]": data['id'],
        "cash_flows[0][shift_id]": data['shift_id'],
        "cash_flows[0][outlet_id]": data['outlet_id'],
        "cash_flows[0][trans_date]": data['trans_date'],
        "cash_flows[0][status]": data['status'],
        "cash_flows[0][amount]": data['amount'],
        "cash_flows[0][descriptions]": data['descriptions'],
      };
      if (data['deleted_at'] != null) {
        mapData["cash_flows[0][deleted_at]"] = data['deleted_at'];
      }
      if (data['images'] != null) {
        for (var i = 0; i < data['images']?.length; i++) {
          final img = data['images'][i];
          mapData['cash_flows[0][images][$i]'] =
              await MultipartFile.fromFile(img.path, filename: img.name);
        }
      }
      if (data['remove_images'] != null) {
        for (var i = 0; i < data['remove_images']?.length; i++) {
          final id = data['remove_images'][i];
          mapData['cash_flows[0][remove_images][$i]'] = id;
        }
      }
      log('STORE CASHFLOW: $mapData');
      final FormData formData = FormData.fromMap(mapData);
      final res = await api.post(ApiUrl.cashFlows, data: formData);
      return res;
    } on DioException catch (e) {
      throw Exception(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<Pagination<Shift>> shifts(
      {required String idOutlet, int? page, String? q}) async {
    try {
      final Map<String, dynamic> params = {
        'id_outlet': idOutlet,
        'q': q,
        'page': page
      };
      final res = await api.get(ApiUrl.shifts, queryParameters: params);
      final data = res.data['data'];
      final pagination = Pagination<Shift>.fromJson(data, (shift) {
        return Shift.fromJson(shift as Map<String, dynamic>);
      });

      return pagination;
    } on DioException catch (e) {
      throw Exception(e.response?.data['msg'] ?? e.message);
    } on Exception catch (e) {
      log('LIST SHIFT API ERROR: $e');
      rethrow;
    }
  }
}
