import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/shared/model/app_config.dart' as model;

import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:selleri/shared/constants/store_key.dart';

part 'app_config_provider.g.dart';

@Riverpod(keepAlive: true)
class AppConfig extends _$AppConfig {
  static final db = FirebaseFirestore.instance;

  final remoteConfig = FirebaseRemoteConfig.instance;
  final storage = const FlutterSecureStorage();

  @override
  Future<model.AppConfig> build() async {
    _fetchRemoteConfig();
    final localData = await storage.read(key: StoreKey.appConfig.name);
    if (localData != null) {
      try {
        final config = model.AppConfig.fromJson(jsonDecode(localData));
        log('Local AppConfig: $config');
        return config;
      } catch (e) {
        log('Failed to parse local AppConfig: $e');
      }
    }
    return model.AppConfig.empty();
  }

  Future<model.AppConfig> _fetchRemoteConfig() async {
    log('Fetching remote AppConfig');

    try {
      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(minutes: 1),
          minimumFetchInterval: const Duration(hours: 1),
        ),
      );

      await remoteConfig.fetchAndActivate();

      final values = model.AppConfig(
        baseUrl: remoteConfig.getString('API_BASE_URL'),
        clientId: remoteConfig.getString('API_CLIENT_ID'),
        clientSecret: remoteConfig.getString('API_CLIENT_SECRET'),
        grantType: remoteConfig.getString('API_GRANT_TYPE'),
        appId: remoteConfig.getString('APP_ID'),
        qrisHost: remoteConfig.getString('QRIS_HOST'),
        qrisAppId: remoteConfig.getString('QRIS_APP_ID'),
        qrisVendor: remoteConfig.getString('QRIS_VENDOR'),
        qrisPaymentType: int.tryParse(
          remoteConfig.getString('QRIS_PAYMENT_TYPE_ID'),
        ),
        esHost: remoteConfig.getString('ES_HOST'),
        esKey: remoteConfig.getString('ES_KEY'),
      );

      await storage.write(
        key: StoreKey.appConfig.name,
        value: jsonEncode(values.toJson()),
      );

      log('remote app AppConfig: $values');

      if (state.hasValue) {
        state = AsyncData(values);
      }

      return values;
    } catch (e, st) {
      log('Failed to fetch remote config: $e\n$st');
      return model.AppConfig.empty();
    }
  }
}
