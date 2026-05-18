import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/shared/constants/app_config.dart';
import 'package:selleri/shared/utils/fetch.dart';

class QRISApi {
  final Dio api;

  QRISApi({required this.api});

  Future<String> requestQris({
    required String transactionNo,
    required String amount,
  }) async {
    try {
      final url = '/api/third-party-payment/qris/mpm/generate';
      final params = {
        'amount': amount,
        'merchant_id': AppConfig.qrisMerchantId,
        'transaction_no': transactionNo,
        'vendor': AppConfig.qrisVendor,
      };
      final res = await api.post(url, data: params);
      return res.data['data']['qr_content'];
    } on DioException catch (e) {
      throw e.message!;
    } catch (e) {
      rethrow;
    }
  }
  
  Future<bool> checkStatus({
    required String transactionNo,
  }) async {
    try {
      final url = '/api/third-party-payment/qris/mpm/status';
      final params = {
        'merchant_id': AppConfig.qrisMerchantId,
        'transaction_no': transactionNo,
        'vendor': AppConfig.qrisVendor,
      };
      final res = await api.get(url, queryParameters: params);
      return res.data['data']['transaction_status_name'] == 'PURCHASE_APPROVED';
    } on DioException catch (e) {
      throw e.message!;
    } catch (e) {
      rethrow;
    }
  }
}

final qrisApiProvider = Provider<QRISApi>((ref) {
  final dio = ref.watch(apiProvider);
  dio.options.baseUrl = AppConfig.qrisHost;
  dio.options.headers['X-App-ID'] = AppConfig.qrisAppId;

  return QRISApi(api: dio);
});
