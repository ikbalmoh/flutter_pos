// ignore_for_file: avoid_manual_providers_as_generated_provider_dependency
import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/features/fcm/model/fcm_subscribe.dart';
import 'package:selleri/features/auth/repository/token_repository.dart';
import 'package:selleri/features/item/repository/item_repository.dart';
import 'package:selleri/features/auth/provider/auth_provider.dart';
import 'package:selleri/features/item/provider/item_provider.dart';
import 'package:selleri/features/notification/provider/notification_provider.dart';
import 'package:selleri/features/outlet/api/outlet_api.dart';
import 'package:selleri/features/outlet/provider/outlet_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:selleri/shared/utils/app_alert.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:selleri/shared/utils/local_notification_service.dart';

part 'fcm_provider.g.dart';

FirebaseMessaging messaging = FirebaseMessaging.instance;

@Riverpod(keepAlive: true)
class Fcm extends _$Fcm {
  @override
  FutureOr<FcmSubscribe?> build() async {
    await init();
    final auth = ref.watch(authProvider);
    final outlet = ref.watch(outletProvider);
    if (auth.value is Authenticated && outlet.value is OutletSelected) {
      return registerFcm(
        idCompany: (auth.value as Authenticated).user.user.company.idCompany,
        idOutlet: (outlet.value as OutletSelected).outlet.idOutlet,
      );
    } else {
      unsubscribe();
    }
    return future;
  }

  Timer? _debounceSync;

  Future<void> init() async {
    LocalNotificationService.initialize();

    await FirebaseMessaging.instance.setAutoInitEnabled(true);

    RemoteMessage? initialMessage = await messaging.getInitialMessage();
    if (initialMessage != null) {
      handleFcmMessage(initialMessage);
    }

    FirebaseMessaging.onMessage.listen(handleFcmMessage);

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    log("Handling a background message: $message");
  }

  void _handleMessage(RemoteMessage message) async {
    log('FCM MESSAGE OPENED APP: $message');
    if (message.data['link'] != null) {
      String link = message.data['link']!;
      final Uri url = Uri.parse(link.replaceFirst('://', ':/'));
      if (!await launchUrl(url)) {
        AppAlert.toast('Could not launch $url');
      }
    }
  }

  void manualSync(List<String> sources, List<String>? configOnly) {
    if (_debounceSync?.isActive ?? false) _debounceSync?.cancel();
    _debounceSync = Timer(const Duration(seconds: 1), () async {
      if (sources.contains('categories')) {
        await ref.read(itemRepositoryProvider).fetchCategoris();
      }
      if (sources.contains('items') || sources.contains('promotions')) {
        await ref.read(itemsProvider().notifier).syncItems();
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
      ref.read(notificationProvider.notifier).loadNotifications();
      LocalNotificationService.display(message);
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
                .read(itemsProvider().notifier)
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

  Future<FcmSubscribe?> registerFcm(
      {required String idCompany, required String idOutlet}) async {
    final api = ref.watch(outletApiProvider);

    try {
      String? token = await retrieveFcmToken();
      if (state.value?.token != token) {
        log("FCM TOKEN: $token");

        final authenticated = ref.read(authProvider).value is Authenticated;
        if (!authenticated) return null;

        final outletActive = ref.read(outletProvider).value is OutletSelected;
        if (!outletActive) return null;

        if (token != null) {
          await api.storeFcmToken(token: token, outletId: idOutlet);
        }

        String prefix = dotenv.env['APP_ID'] ?? 'selleri';

        String companyTopic = '$prefix-$idCompany';
        String outletTopic = '$prefix-$idOutlet';

        await messaging.subscribeToTopic(companyTopic);
        await messaging.subscribeToTopic(outletTopic);

        final data = FcmSubscribe(
          companyTopic: companyTopic,
          outletTopic: outletTopic,
          token: token!,
        );

        state = AsyncData(data);

        log('FCM SUBSCRIBED => $companyTopic | $outletTopic');

        return data;
      }

      return null;
    } catch (e) {
      log('FCM SUBSCRIPTION ERROR: $e');
      return null;
    }
  }

  Future<void> unsubscribe() async {
    try {
      if (state.value == null) {
        return;
      }
      final tokens = state.value!;
      log('UNSUBSCRIBING FCM ... $tokens');
      await messaging.unsubscribeFromTopic(tokens.companyTopic);
      log('FCM UNSUBSCRIBED from ${tokens.companyTopic}');
      await messaging.unsubscribeFromTopic(tokens.outletTopic);
      log('FCM UNSUBSCRIBED from ${tokens.outletTopic}');
      state =
          AsyncData(FcmSubscribe(companyTopic: '', outletTopic: '', token: ''));
      ref.read(tokenRepositoryProvider).removeToken();
    } catch (e) {
      log('UNSUBSCRIBING FCM FAILED => $e');
    }
  }
}
