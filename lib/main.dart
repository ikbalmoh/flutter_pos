import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:selleri/data/constants/store_key.dart';
import 'package:selleri/data/objectbox.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

final deviceInfoPlugin = DeviceInfoPlugin();

Future initServices() async {
  log('INITIALIZING APP ...');

  await EasyLocalization.ensureInitialized();

  await initObjectBox();

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    log('ERROR DETAILS: $details');
    if (kReleaseMode) exit(1);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    log('ERROR OCCURED:\n error => $error\n stack => $stack');
    return true;
  };

  String env = appFlavor == 'production' ? ".env" : ".env.staging";

  await dotenv.load(fileName: env);

  String? deviceId = '';

  if (defaultTargetPlatform == TargetPlatform.android) {
    AndroidDeviceInfo deviceInfo = await deviceInfoPlugin.androidInfo;
    deviceId = deviceInfo.fingerprint;
  } else if (defaultTargetPlatform == TargetPlatform.iOS) {
    IosDeviceInfo deviceInfo = await deviceInfoPlugin.iosInfo;
    deviceId = deviceInfo.identifierForVendor;
  } else if (defaultTargetPlatform == TargetPlatform.macOS) {
    MacOsDeviceInfo deviceInfo = await deviceInfoPlugin.macOsInfo;
    deviceId = deviceInfo.systemGUID;
  } else {
    WebBrowserInfo deviceInfo = await deviceInfoPlugin.webBrowserInfo;
    deviceId = deviceInfo.userAgent;
  }

  log('Device ID: $deviceId');

  const storage = FlutterSecureStorage();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

  if (deviceId != null && deviceId.isNotEmpty) {
    storage.write(key: StoreKey.device.toString(), value: deviceId);
  }

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    log('FCM NOTIFICATION: User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    log('FCM NOTIFICATION: User granted provisional permission');
  } else {
    log('FCM NOTIFICATION: User declined or has not accepted permission');
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initServices();

  runApp(
    ProviderScope(
      child: EasyLocalization(
        supportedLocales: const [Locale('en', 'US'), Locale('id', 'ID')],
        path: 'assets/translations',
        fallbackLocale: const Locale('id', 'ID'),
        child: const App(),
      ),
    ),
  );
}
