// ignore_for_file: avoid_manual_providers_as_generated_provider_dependency
import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/data/network/api.dart';
import 'package:selleri/data/repository/item_repository.dart';
import 'package:selleri/providers/auth/auth_provider.dart';
import 'package:selleri/providers/item/item_provider.dart';
import 'package:selleri/providers/outlet/outlet_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:selleri/utils/app_alert.dart';

part 'fcm_provider.g.dart';

FirebaseMessaging messaging = FirebaseMessaging.instance;
String company = '';
String outlet = '';

@Riverpod(keepAlive: true)
class Fcm extends _$Fcm {
  @override
  FutureOr<String?> build() async {
    FirebaseMessaging.onMessage.listen(handleFcmMessage);

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('FCM MESSAGE OPENED APP');
    });

    final auth = ref.watch(authProvider);
    final outlet = ref.watch(outletProvider);
    if (auth.value is Authenticated && outlet.value is OutletSelected) {
      registerFcm(
        idCompany: (auth.value as Authenticated).user.user.company.idCompany,
        idOutlet: (outlet.value as OutletSelected).outlet.idOutlet,
      );
    }
    return null;
  }

  Timer? _debounceSync;

  void manualSync(List<String> sources, List<String>? configOnly) {
    if (_debounceSync?.isActive ?? false) _debounceSync?.cancel();
    _debounceSync = Timer(const Duration(seconds: 1), () async {
      if (sources.contains('categories')) {
        await ref.read(itemRepositoryProvider).fetchCategoris();
      }
      if (sources.contains('items') || sources.contains('promotions')) {
        await ref.read(itemsStreamProvider().notifier).syncItems();
      }
      if (sources.contains('config')) {
        final only = configOnly ?? [];
        log('CONFIG ONLY: $configOnly');
        await ref.read(outletProvider.notifier).refreshConfig(only: only);
      }
    });
  }

  Future<String?> retrieveFcmToken() async {
    String? token = await messaging.getToken();
    return token;
  }

  void handleFcmMessage(RemoteMessage message) {
    log('FCM INCOMING MESSAGE');
    log('FCM message : ${message.toMap()}');

    if (message.notification != null) {
      log('FCM message contained a notification: ${message.notification?.toMap()}');
      // Show local notification
      // Fetch Notification
    }

    final data = message.data;
    log('FCM DATA $data');

    if (data.containsKey('type')) {
      final jsonData = json.decode(data['data']);
      switch (data['type']) {
        case 'items':
          AppAlert.toast('syncing_x'.tr(args: ['item'.tr()]));
          // sync items
          if (jsonData.isNotEmpty) {
            ref
                .read(itemsStreamProvider().notifier)
                .saveJsonItems(jsonData, showUpdateMessage: true);
          }
          break;

        case 'sync':
          final sources = List<String>.from(jsonData['sources'] ?? []);
          final config = List<String>.from(jsonData['config_only'] ?? []);
          AppAlert.toast('syncing_x'.tr(args: ['data']));
          log('TRIGGER SYNC\n => source: $sources\n => config: $config');
          manualSync(sources, config);
          break;

        default:
          log('FCM type ${data['type']} not yet handled');
          break;
      }
    } else {
      log('FCM has not type. ignored');
    }
  }

  Future<void> registerFcm(
      {required String idCompany, required String idOutlet}) async {
    final api = ref.watch(outletApiProvider);

    try {
      String? token = await retrieveFcmToken();
      company = idCompany;
      outlet = idOutlet;

      if (state.value != token) {
        state = AsyncValue.data(token);
        log("FCM TOKEN: $token");

        final authenticated = ref.read(authProvider).value is Authenticated;
        if (!authenticated) return;

        final outletActive = ref.read(outletProvider).value is OutletSelected;
        if (!outletActive) return;

        if (token != null) {
          await api.storeFcmToken(token: token, outletId: idOutlet);
        }

        String prefix = dotenv.env['APP_ID'] ?? 'selleri';

        String companyTopic = '$prefix-$idCompany';
        String outletTopic = '$prefix-$idOutlet';

        await messaging.subscribeToTopic(companyTopic);
        await messaging.subscribeToTopic(outletTopic);

        log('FCM SUBSCRIBED\n$companyTopic\n$outletTopic');
      }
    } catch (e) {
      log('FCM SUBSCRIPTION ERROR: $e');
    }
  }
}
