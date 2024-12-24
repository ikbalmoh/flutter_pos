import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/config/api_url.dart';
import 'package:selleri/data/models/receiving/purchase_info.dart';
import 'package:selleri/data/models/receiving/receiving_form.dart';
import 'package:selleri/utils/fetch.dart';
import 'package:selleri/utils/formater.dart';

class ReceivingApi {
  final Dio api;

  ReceivingApi({required this.api});

  Future<PurchaseInfo> purchaseInfo(
    String search, {
    required int type,
    required String idOutlet,
  }) async {
    try {
      final params = {"outlet_id": idOutlet, "search": search};
      String url = type == 1 ? ApiUrl.purchaseInfo : ApiUrl.transferInfo;
      final res = await api.get(url, queryParameters: params);
      final data = res.data['data'];
      return PurchaseInfo.fromJson(data);
    } on DioException catch (e) {
      throw e.message!;
    } catch (_) {
      rethrow;
    }
  }

  Future<String> submit(ReceivingForm form) async {
    try {
      final params = form.toJson();
      params['received_data'] =
          DateTimeFormater.dateToString(form.receiveDate, format: 'y-MM-dd');
      final res = await api.post(ApiUrl.receiving, data: params);
      return res.data['msg'] ?? 'receiving_submitted'.tr();
    } on DioException catch (e) {
      throw e.message!;
    } catch (_) {
      rethrow;
    }
  }
}

final receivingApiProvider = Provider<ReceivingApi>((ref) {
  final api = ref.watch(apiProvider);
  return ReceivingApi(api: api);
});
