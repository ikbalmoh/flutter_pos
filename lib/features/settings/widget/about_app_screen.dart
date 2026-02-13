import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide AppBar;
import 'package:selleri/app/widget/app_bar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:selleri/shared/constants/store_key.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text('about_app'.tr()),
      ),
      body: const AboutApp(),
    );
  }
}

class AboutApp extends StatefulWidget {
  const AboutApp({super.key});

  @override
  State<AboutApp> createState() => _AboutAppState();
}

class _AboutAppState extends State<AboutApp> {
  final shorebirdCodePush = ShorebirdUpdater();

  String email = 'support@dgti.co.id';

  String appVersion = '0';
  String deviceId = '';
  int patch = 0;

  @override
  void initState() {
    fetchVersion();
    super.initState();
  }

  void fetchVersion() async {
    final storage = FlutterSecureStorage();

    deviceId = await storage.read(key: StoreKey.device.name) ?? '';
    PackageInfo.fromPlatform().then((packageInfo) {
      setState(() {
        appVersion = '${packageInfo.version}(${packageInfo.buildNumber})';
      });
    });
    shorebirdCodePush.readCurrentPatch().then((value) {
      if (value != null) {
        setState(() {
          patch = value.number;
        });
      }
    });
  }

  void call() {
    final Uri url = Uri.parse('tel:02287353061');
    launchUrl(url);
  }

  void openEmail() {
    final Uri url = Uri.parse('mailto:$email');
    launchUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: Text('app_version'.tr()),
          subtitle: Text('v$appVersion${patch > 0 ? '-$patch' : ''}',
              style: TextStyle(color: Colors.blueGrey)),
          tileColor: Colors.white,
        ),
        ListTile(
          title: Text('device_id'.tr()),
          subtitle: Text(deviceId, style: TextStyle(color: Colors.blueGrey)),
          tileColor: Colors.white,
        ),
        ListTile(
          title: Text('contact_support'.tr()),
          subtitle:
              const Text('022 8735 3061', style: TextStyle(color: Colors.blue)),
          tileColor: Colors.white,
          onTap: call,
          trailing: Icon(
            CupertinoIcons.phone,
            color: Colors.grey,
            size: 16,
          ),
        ),
        ListTile(
          title: Text('email_support'.tr()),
          subtitle: Text(
            email,
            style: TextStyle(color: Colors.blue),
          ),
          tileColor: Colors.white,
          onTap: openEmail,
          trailing: Icon(
            CupertinoIcons.mail,
            color: Colors.grey,
            size: 16,
          ),
        ),
      ],
    );
  }
}
