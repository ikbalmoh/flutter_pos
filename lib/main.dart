import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:selleri/data/constants/store_key.dart';
import 'package:selleri/data/objectbox.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final deviceInfoPlugin = DeviceInfoPlugin();

Future initServices() async {
  if (kDebugMode) {
    print('INITIALIZING APP ...');
  }

  await initObjectBox();

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    if (kDebugMode) {
      print('ERROR DETAILS: $details');
    }
    if (kReleaseMode) exit(1);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    if (kDebugMode) {
      print('ERROR OCCURED:\n error => $error\n stack => $stack');
    }
    return true;
  };

  await dotenv.load(fileName: ".env");

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

  if (kDebugMode) {
    print('Device ID: $deviceId');
  }

  const storage = FlutterSecureStorage();

  if (deviceId != null && deviceId.isNotEmpty) {
    storage.write(key: StoreKey.device.toString(), value: deviceId);
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initServices();

  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}
