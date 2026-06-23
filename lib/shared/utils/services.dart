import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'package:selleri/shared/constants/app_config.dart';
import 'package:selleri/shared/constants/store_key.dart';
import 'package:selleri/shared/objectbox.dart';
import 'package:selleri/shared/utils/firebase.dart';

final deviceInfoPlugin = DeviceInfoPlugin();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log("Handling a background message: $message");
  await FirebaseHelper().init();
}

Future<void> initServices() async {
  log('INITIALIZING APP $appFlavor ...');

  final bool isDev = ['dev', 'stage'].contains(appFlavor);

  await EasyLocalization.ensureInitialized();

  await initObjectBox();

  PlatformDispatcher.instance.onError = (error, stack) {
    log('ERROR OCCURED:\n error => $error\n stack => $stack');
    return true;
  };

  await AppConfig.init(isStage: isDev);

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

  // Configure Crashlytics metadata
  FirebaseCrashlytics.instance.setCustomKey('device_id', deviceId);
  FirebaseCrashlytics.instance.setCustomKey('device_name', deviceName);
  FirebaseCrashlytics.instance.setCustomKey('flavor', appFlavor ?? 'default');

  final userString = await storage.read(key: StoreKey.user.name);
  if (userString != null) {
    try {
      final userJson = json.decode(userString);
      final userAccount = userJson['user'];
      if (userAccount != null) {
        final userId = userAccount['id_user']?.toString() ?? '';
        final userName = userAccount['name']?.toString() ?? '';
        final userEmail = userAccount['email']?.toString() ?? '';

        if (userId.isNotEmpty) {
          FirebaseCrashlytics.instance.setUserIdentifier(userId);
        }
        FirebaseCrashlytics.instance.setCustomKey('user_name', userName);
        FirebaseCrashlytics.instance.setCustomKey('user_email', userEmail);
      }
    } catch (e) {
      log('Error parsing user config for Crashlytics: $e');
    }
  }

  final outletString = await storage.read(key: StoreKey.outlet.name);
  if (outletString != null) {
    try {
      final outletJson = json.decode(outletString);
      final outletId = outletJson['id_outlet']?.toString() ?? '';
      final outletName = outletJson['outlet_name']?.toString() ?? '';

      FirebaseCrashlytics.instance.setCustomKey('outlet_id', outletId);
      FirebaseCrashlytics.instance.setCustomKey('outlet_name', outletName);
    } catch (e) {
      log('Error parsing outlet config for Crashlytics: $e');
    }
  }

  const fatalError = true;
  // Non-async exceptions
  FlutterError.onError = (errorDetails) {
    final metadata = _getErrorMetadata(errorDetails.stack);
    final module = metadata['module'] ?? 'unknown';
    final fileLoc = metadata['file'] ?? 'unknown';

    FirebaseCrashlytics.instance.setCustomKey('error_module', module);
    FirebaseCrashlytics.instance.setCustomKey('error_file', fileLoc);
    if (errorDetails.context != null) {
      FirebaseCrashlytics.instance.setCustomKey('error_context', errorDetails.context!.toString());
    }
    FirebaseCrashlytics.instance.log('Flutter Error in Module: $module, File: $fileLoc. Library: ${errorDetails.library}');

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
    final metadata = _getErrorMetadata(stack);
    final module = metadata['module'] ?? 'unknown';
    final fileLoc = metadata['file'] ?? 'unknown';

    FirebaseCrashlytics.instance.setCustomKey('error_module', module);
    FirebaseCrashlytics.instance.setCustomKey('error_file', fileLoc);
    FirebaseCrashlytics.instance.log('Platform Dispatcher Error in Module: $module, File: $fileLoc');

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

Map<String, String> _getErrorMetadata(StackTrace? stackTrace) {
  if (stackTrace == null) return {'module': 'unknown', 'file': 'unknown'};
  final lines = stackTrace.toString().split('\n');
  for (final line in lines) {
    if (line.contains('package:selleri/')) {
      final match = RegExp(r'(package:selleri/[^\s\)]+)').firstMatch(line);
      if (match != null) {
        final fileLoc = match.group(1)!;
        String module = 'app';
        if (fileLoc.contains('package:selleri/features/')) {
          final featureMatch = RegExp(r'package:selleri/features/([^/]+)/').firstMatch(fileLoc);
          if (featureMatch != null && featureMatch.groupCount >= 1) {
            module = 'feature:${featureMatch.group(1)}';
          }
        } else if (fileLoc.contains('package:selleri/shared/')) {
          module = 'shared';
        } else {
          final generalMatch = RegExp(r'package:selleri/([^/]+)/').firstMatch(fileLoc);
          if (generalMatch != null && generalMatch.groupCount >= 1) {
            module = generalMatch.group(1)!;
          }
        }
        return {
          'module': module,
          'file': fileLoc,
        };
      }
    }
  }
  return {'module': 'external', 'file': 'external'};
}
