import 'dart:developer';
import 'dart:io' show Platform;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:selleri/utils/app_alert.dart';
import 'package:url_launcher/url_launcher.dart';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  log('onDidReceiveNotificationResponse: $notificationResponse');
  // handle action
}

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    InitializationSettings initializationSettings =
        const InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    _notificationsPlugin.initialize(
      initializationSettings,
      // to handle event when we receive notification
      onDidReceiveNotificationResponse: (details) async {
        log('onDidReceiveNotificationResponse: $details');
        if (details.payload != null) {
          final Uri url = Uri.parse(details.payload!.replaceFirst('://', ':/'));
          if (!await launchUrl(url)) {
            AppAlert.toast('Could not launch $url');
          }
        }
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    if (Platform.isAndroid) {
      final bool? androidPermissions = await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
      log('android notification permissions: $androidPermissions');
    } else {
      final bool? iosPermissions = await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);

      log('ios notification permissions: $iosPermissions');
    }
  }

  static Future<void> display(RemoteMessage message) async {
    // To display the notification in device
    try {
      log('display local notification => ${message.toString()}');
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      NotificationDetails notificationDetails = const NotificationDetails(
        android: AndroidNotificationDetails(
          "ChannelId",
          "MainChannel",
          groupKey: "selleri",
          color: Colors.green,
          importance: Importance.max,
          playSound: true,
          priority: Priority.high,
        ),
      );
      await _notificationsPlugin.show(id, message.notification?.title,
          message.notification?.body, notificationDetails,
          payload: message.data['link']);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
