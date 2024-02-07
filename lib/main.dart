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
import 'firebase_options.dart' as firebase_option;
import 'firebase_options_dev.dart' as firebase_option_dev;
import 'firebase_options_stage.dart' as firebase_option_stage;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

final deviceInfoPlugin = DeviceInfoPlugin();

Future initServices() async {
  log('INITIALIZING APP $appFlavor ...');

  final bool isDev = ['dev', 'stage'].contains(appFlavor);

  await EasyLocalization.ensureInitialized();

  await initObjectBox();

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

  String env = isDev ? ".env.stage" : ".env";

  await dotenv.load(fileName: env);

  String? deviceId = '';
  String? deviceName = '';

  if (defaultTargetPlatform == TargetPlatform.android) {
    AndroidDeviceInfo deviceInfo = await deviceInfoPlugin.androidInfo;
    deviceId = deviceInfo.fingerprint;
    deviceName = deviceInfo.device;
  } else if (defaultTargetPlatform == TargetPlatform.iOS) {
    IosDeviceInfo deviceInfo = await deviceInfoPlugin.iosInfo;
    deviceId = deviceInfo.identifierForVendor;
    deviceName = deviceInfo.name;
  } else if (defaultTargetPlatform == TargetPlatform.macOS) {
    MacOsDeviceInfo deviceInfo = await deviceInfoPlugin.macOsInfo;
    deviceId = deviceInfo.systemGUID;
    deviceName = deviceInfo.computerName;
  } else {
    WebBrowserInfo deviceInfo = await deviceInfoPlugin.webBrowserInfo;
    deviceId = deviceInfo.userAgent;
    deviceName = deviceInfo.browserName.name;
  }

  log('Device ID: $deviceId');

  const storage = FlutterSecureStorage();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

  if (deviceId != null && deviceId.isNotEmpty) {
    storage.write(key: StoreKey.device.name, value: deviceId);
  }
  storage.write(key: StoreKey.deviceName.name, value: deviceName);

  var firebaseOptions = firebase_option.DefaultFirebaseOptions.currentPlatform;
  if (appFlavor == 'stage') {
    firebaseOptions =
        firebase_option_stage.DefaultFirebaseOptions.currentPlatform;
  } else if (appFlavor == 'dev') {
    firebaseOptions =
        firebase_option_dev.DefaultFirebaseOptions.currentPlatform;
  }

  await Firebase.initializeApp(
    options: firebaseOptions,
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

  log(StoreKey.deviceName.name);

  WakelockPlus.enable();
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
        child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
            child: const App()),
      ),
    ),
  );
}
