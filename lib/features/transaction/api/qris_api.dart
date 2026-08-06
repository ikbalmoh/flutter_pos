import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/shared/provider/app_config_provider.dart';

class QRISApi {
  final Dio api;
  final String vendor;

  QRISApi({required this.api, required this.vendor});

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
        'vendor': vendor,
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
        'vendor': vendor,
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

final qrisApiProvider = FutureProvider<QRISApi>((ref) async {
  final appConfig = await ref.read(appConfigProvider.future);
  final dio = Dio(
    BaseOptions(
      baseUrl: appConfig.qrisHost!,
      headers: {
        'X-App-ID': appConfig.qrisAppId,
      },
    ),
  );

  return QRISApi(api: dio, vendor: appConfig.qrisVendor!);
});
