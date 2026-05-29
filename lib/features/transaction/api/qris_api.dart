import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/shared/constants/app_config.dart';

class QRISApi {
  final Dio api;

  QRISApi({required this.api});

  Future<String> requestQris({
    required String transactionNo,
    required String merchantId,
    required num amount,
  }) async {
    try {
      final url = '/api/third-party-payment/qris/mpm/generate';
      final params = {
        'amount': amount,
        'merchant_id': merchantId,
        'transaction_no': transactionNo,
        'vendor': AppConfig.qrisVendor,
        'expired_at': '',
      };
      final res = await api.post(url, data: params);
      return res.data['data']['qr_content'];
    } on DioException catch (e) {
      throw e.message!;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> checkStatus({
    required String transactionNo,
    required String merchantId,
  }) async {
    try {
      final url = '/api/third-party-payment/qris/mpm/status';
      final params = {
        'merchant_id': merchantId,
        'transaction_no': transactionNo,
        'vendor': AppConfig.qrisVendor,
      };
      final res = await api.post(url, data: params);
      return res.data['data']['transaction_status_code'] ?? '';
    } on DioException catch (e) {
      throw e.message!;
    } catch (e) {
      rethrow;
    }
  }
}

final qrisApiProvider = Provider<QRISApi>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.qrisHost,
      headers: {
        'X-App-ID': AppConfig.qrisAppId,
      },
    ),
  );

  return QRISApi(api: dio);
});
