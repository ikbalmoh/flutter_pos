import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_config.freezed.dart';
part 'app_config.g.dart';

@freezed
abstract class AppConfig with _$AppConfig {
  const AppConfig._();

  const factory AppConfig({
    // API
    final String? baseUrl,
    final String? clientId,
    final String? clientSecret,
    final String? grantType,
    final String? appId,
    // QRIS
    final String? qrisHost,
    final String? qrisAppId,
    final String? qrisVendor,
    final int? qrisPaymentType,
    // ES
    final String? esHost,
    final String? esKey,
  }) = _AppConfig;

  factory AppConfig.fromJson(Map<String, dynamic> json) =>
      _$AppConfigFromJson(json);

  factory AppConfig.empty() => AppConfig(
        baseUrl: 'https://selleri.co.id/api',
        clientId: '2',
        clientSecret: '',
        grantType: 'password',
        appId: 'selleri',
        qrisHost: null,
        qrisAppId: null,
        qrisVendor: null,
        qrisPaymentType: null,
        esHost: null,
        esKey: null,
      );

  factory AppConfig.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    var data = snapshot.data()!;
    return AppConfig(
      baseUrl: data['API_HOST'] ?? AppConfig.empty().baseUrl,
      clientId: data['API_CLIENT_ID'] ?? AppConfig.empty().clientId,
      clientSecret: data['API_CLIENT_SECRET'] ?? AppConfig.empty().clientSecret,
      grantType: data['API_GRANT_TYPE'] ?? AppConfig.empty().grantType,
      appId: data['APP_ID'] ?? AppConfig.empty().appId,
      qrisHost: data['QRIS_HOST'] ?? AppConfig.empty().qrisHost,
      qrisAppId: data['QRIS_APP_ID'] ?? AppConfig.empty().qrisAppId,
      qrisVendor: data['QRIS_VENDOR'] ?? AppConfig.empty().qrisVendor,
      qrisPaymentType: data['QRIS_PAYMENT_TYPE'] ?? AppConfig.empty().qrisPaymentType,
      esHost: data['ES_HOST'] ?? AppConfig.empty().esHost,
      esKey: data['ES_KEY'] ?? AppConfig.empty().esKey,
    );
  }
}
