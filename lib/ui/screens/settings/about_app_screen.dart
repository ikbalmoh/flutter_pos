import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';

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
  final shorebirdCodePush = ShorebirdCodePush();

  String appVersion = '0';
  String buildNumber = '0';
  int patchVersion = 0;

  @override
  void initState() {
    fetchVersion();
    super.initState();
  }

  void fetchVersion() {
    PackageInfo.fromPlatform().then((packageInfo) {
      setState(() {
        appVersion = packageInfo.version;
        buildNumber = packageInfo.buildNumber;
      });
    });
    shorebirdCodePush.currentPatchNumber().then((value) {
      if (value != null) {
        setState(() {
          patchVersion = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: Text('app_version'.tr()),
          subtitle: Text(appVersion),
          tileColor: Colors.white,
        ),
        ListTile(
          title: Text('build_number'.tr()),
          subtitle: Text(buildNumber),
          tileColor: Colors.white,
        ),
        ListTile(
          title: Text('patch_version'.tr()),
          subtitle: Text('$patchVersion'),
          tileColor: Colors.white,
        ),
      ],
    );
  }
}
