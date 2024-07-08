import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/data/network/api.dart';
import 'package:selleri/providers/auth/auth_provider.dart';
import 'package:selleri/providers/item/item_provider.dart';
import 'package:selleri/providers/outlet/outlet_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

part 'fcm_provider.g.dart';

FirebaseMessaging messaging = FirebaseMessaging.instance;
String company = '';
String outlet = '';

@Riverpod(keepAlive: true)
class FcmNotifier extends _$FcmNotifier {
  @override
  FutureOr<String?> build() async {
    FirebaseMessaging.onMessage.listen(handleFcmMessage);

    final auth = ref.watch(authNotifierProvider);
    final outlet = ref.watch(outletNotifierProvider);
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
      if (sources.contains('items')) {
        await ref.read(itemsStreamProvider().notifier).syncItems();
      }
      if (sources.contains('config')) {
        final only = configOnly ?? [];
        log('CONFIG ONLY: $configOnly');
        await ref.read(outletNotifierProvider.notifier).refreshConfig(only);
      }
    });
  }

  Future<String?> retrieveFcmToken() async {
    String? token = await messaging.getToken();
    return token;
  }

  void handleFcmMessage(RemoteMessage message) {
    log('INCOMING FCM MESSAGE');

    if (message.notification != null) {
      log('message contained a notification: ${message.notification}');
      // Show local notification
      // Fetch Notification
    }

    final data = message.data;
    log('FCM DATA $data');

    if (data.containsKey('type')) {
      final jsonData = json.decode(data['data']);
      switch (data['type']) {
        case 'items':
          // sync items
          if (jsonData.isNotEmpty) {
            ref
                .read(itemsStreamProvider().notifier)
                .saveJsonItems(jsonData, showUpdateMessage: true);
          }
          break;

        case 'transactions':
          // sync transactions
          break;

        case 'sync':
          final sources = List<String>.from(jsonData['sources'] ?? []);
          final config = List<String>.from(jsonData['config_only'] ?? []);
          log('TRIGGER SYNC\n => soruce: $sources\n => config: $config');
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
    final api = OutletApi();

    String? token = await retrieveFcmToken();
    company = idCompany;
    outlet = idOutlet;

    if (state.value != token) {
      state = AsyncValue.data(token);
      log("FCM TOKEN: $token");

      final authenticated =
          ref.read(authNotifierProvider).value is Authenticated;
      if (!authenticated) return;

      final outletActive =
          ref.read(outletNotifierProvider).value is OutletSelected;
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
  }
}
