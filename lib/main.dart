import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/app/widget/app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:selleri/shared/constants/store_key.dart';
import 'package:selleri/shared/objectbox.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:selleri/shared/utils/firebase.dart';
import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_udid/flutter_udid.dart';

final deviceInfoPlugin = DeviceInfoPlugin();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log("Handling a background message: $message");
  await FirebaseHelper().init();
}

Future initServices() async {
  log('INITIALIZING APP $appFlavor ...');

  final bool isDev = ['dev', 'stage'].contains(appFlavor);

  await EasyLocalization.ensureInitialized();

  await initObjectBox();

  PlatformDispatcher.instance.onError = (error, stack) {
    log('ERROR OCCURED:\n error => $error\n stack => $stack');
    return true;
  };

  String env = isDev ? ".env.stage" : ".env";

  await dotenv.load(fileName: env);

  String deviceId = await FlutterUdid.consistentUdid;
  String? deviceName = '';

  if (defaultTargetPlatform == TargetPlatform.android) {
    AndroidDeviceInfo deviceInfo = await deviceInfoPlugin.androidInfo;
    deviceId = deviceInfo.fingerprint;
    deviceName = deviceInfo.model;
  } else if (defaultTargetPlatform == TargetPlatform.iOS) {
    IosDeviceInfo deviceInfo = await deviceInfoPlugin.iosInfo;
    deviceName = deviceInfo.name;
  } else if (defaultTargetPlatform == TargetPlatform.macOS) {
    MacOsDeviceInfo deviceInfo = await deviceInfoPlugin.macOsInfo;
    deviceName = deviceInfo.computerName;
  } else {
    WebBrowserInfo deviceInfo = await deviceInfoPlugin.webBrowserInfo;
    deviceName = deviceInfo.browserName.name;
  }

  log('Device ID: $deviceId');

  const storage = FlutterSecureStorage();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

  storage.write(key: StoreKey.device.name, value: deviceId);
  storage.write(key: StoreKey.deviceName.name, value: deviceName);

  await FirebaseHelper().init();

  const fatalError = true;
  // Non-async exceptions
  FlutterError.onError = (errorDetails) {
    if (fatalError) {
      // record a "fatal" exception
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      // ignore: dead_code
    } else {
      // record a "non-fatal" exception
      FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
    }
  };
  // Async exceptions
  PlatformDispatcher.instance.onError = (error, stack) {
    if (fatalError) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      // ignore: dead_code
    } else {
      // record a "non-fatal" exception
      FirebaseCrashlytics.instance.recordError(error, stack);
    }
    return true;
  };

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (!kDebugMode) {
    WakelockPlus.enable();
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
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
          child: const App(),
        ),
      ),
    ),
  );
}
