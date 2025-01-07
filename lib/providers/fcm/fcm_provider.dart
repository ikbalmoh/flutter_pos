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
import 'package:selleri/providers/notification/notification_provider.dart';
import 'package:selleri/providers/outlet/outlet_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:selleri/utils/app_alert.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:selleri/utils/local_notification_service.dart';

part 'fcm_provider.g.dart';

FirebaseMessaging messaging = FirebaseMessaging.instance;

class FcmSubscribe {
  final String companyTopic;
  final String outletTopic;
  final String token;

  const FcmSubscribe({
    required this.companyTopic,
    required this.outletTopic,
    required this.token,
  });
}

@Riverpod(keepAlive: true)
class Fcm extends _$Fcm {
  @override
  FcmSubscribe build() {
    init();
    return const FcmSubscribe(companyTopic: '', outletTopic: '', token: '');
  }

  Timer? _debounceSync;

  init() async {
    LocalNotificationService.initialize();

    await FirebaseMessaging.instance.setAutoInitEnabled(true);

    RemoteMessage? initialMessage = await messaging.getInitialMessage();
    if (initialMessage != null) {
      handleFcmMessage(initialMessage);
    }

    FirebaseMessaging.onMessage.listen(handleFcmMessage);

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);

    final auth = ref.watch(authProvider);
    final outlet = ref.watch(outletProvider);
    if (auth.value is Authenticated && outlet.value is OutletSelected) {
      registerFcm(
        idCompany: (auth.value as Authenticated).user.user.company.idCompany,
        idOutlet: (outlet.value as OutletSelected).outlet.idOutlet,
      );
    }
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
      if (state.token != token) {
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

        state = FcmSubscribe(
          companyTopic: companyTopic,
          outletTopic: outletTopic,
          token: token!,
        );

        log('FCM SUBSCRIBED => $companyTopic | $outletTopic');
      }
    } catch (e) {
      log('FCM SUBSCRIPTION ERROR: $e');
    }
  }

  Future<void> unsubscribe() async {
    try {
      log('UNSUBSCRIBING FCM ...');
      if (state.companyTopic.isNotEmpty) {
        await messaging.subscribeToTopic(state.companyTopic);
        log('FCM UNSUBSCRIBED from ${state.companyTopic}');
      }
      if (state.outletTopic.isNotEmpty) {
        await messaging.subscribeToTopic(state.outletTopic);
        log('FCM UNSUBSCRIBED from ${state.outletTopic}');
      }
      state = const FcmSubscribe(companyTopic: '', outletTopic: '', token: '');
    } catch (e) {
      log('UNSUBSCRIBING FCM FAILED => $e');
    }
  }
}
