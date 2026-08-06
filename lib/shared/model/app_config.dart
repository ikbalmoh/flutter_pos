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
        baseUrl: '',
        clientId: '',
        clientSecret: '',
        grantType: '',
        appId: '',
        qrisHost: '',
        qrisAppId: '',
        qrisVendor: '',
        qrisPaymentType: null,
        esHost: '',
        esKey: '',
      );

  factory AppConfig.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    var data = snapshot.data()!;
    return AppConfig(
      baseUrl: data['API_HOST'] ?? '',
      clientId: data['API_CLIENT_ID'] ?? '',
      clientSecret: data['API_CLIENT_SECRET'] ?? '',
      grantType: data['API_GRANT_TYPE'] ?? '',
      appId: data['APP_ID'] ?? '',
      qrisHost: data['QRIS_HOST'] ?? '',
      qrisAppId: data['QRIS_APP_ID'] ?? '',
      qrisVendor: data['QRIS_VENDOR'] ?? '',
      esHost: data['ES_HOST'] ?? '',
      esKey: data['ES_KEY'] ?? '',
    );
  }
}
