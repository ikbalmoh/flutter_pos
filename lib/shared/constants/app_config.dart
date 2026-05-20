import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  AppConfig._();
  // dotenv
  static String baseUrl = dotenv.env['HOST'] ?? "";
  static String clientId = dotenv.env['CLIENT_ID'] ?? "";
  static String clientSecret = dotenv.env['CLIENT_SECRET'] ?? "";
  static String grantType = dotenv.env['GRANT_TYPE'] ?? "";
  static String appId = dotenv.env['APP_ID'] ?? "";

  static String qrisHost = String.fromEnvironment('QRIS_HOST',
      defaultValue: "https://svc-relay-q3n.dgti.co.id");
  static String qrisAppId =
      String.fromEnvironment('QRIS_APP_ID', defaultValue: "selleri");
  static String qrisVendor =
      String.fromEnvironment('QRIS_VENDOR', defaultValue: "dsp");
  static int qrisPaymentTypeId =
      int.fromEnvironment('QRIS_PAYMENT_TYPE_ID', defaultValue: 6);
}
