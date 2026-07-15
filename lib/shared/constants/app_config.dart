import 'dart:convert';
import 'package:flutter/services.dart';

class AppConfig {
  AppConfig._();

  static String baseUrl = "";
  static String clientId = "";
  static String clientSecret = "";
  static String grantType = "";
  static String appId = "";
  // QRIS
  static String qrisHost = "";
  static String qrisAppId =
      String.fromEnvironment('QRIS_APP_ID', defaultValue: "selleri");
  static String qrisVendor =
      String.fromEnvironment('QRIS_VENDOR', defaultValue: "dsp");
  static int qrisPaymentTypeId =
      int.fromEnvironment('QRIS_PAYMENT_TYPE_ID', defaultValue: 6);

  // ES
  static String esHost = "";
  static String esKey = "";

  static Future<void> init({bool isStage = false}) async {
    final fileName = isStage ? 'env/env.stage.json' : 'env/env.json';
    final raw = await rootBundle.loadString(fileName);
    final Map<String, dynamic> config = jsonDecode(raw);

    baseUrl = config['HOST'] ?? "";
    qrisHost = config['QRIS_HOST'] ?? "";
    clientId = config['CLIENT_ID'] ?? "";
    clientSecret = config['CLIENT_SECRET'] ?? "";
    grantType = config['GRANT_TYPE'] ?? "";
    appId = config['APP_ID'] ?? "";
    // ES
    esHost = config['ES_HOST'] ?? "";
    esKey = config['ES_KEY'] ?? "";
  }
}
