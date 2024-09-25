import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:selleri/router/routes.dart';
import 'package:selleri/ui/components/app_drawer/app_drawer.dart';
import 'package:selleri/ui/screens/settings/about_app_screen.dart';
import 'package:selleri/ui/screens/settings/printer/printer_setting.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  String visibleSetting = '';

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveBreakpoints.of(context).largerThan(MOBILE);

    void onPressMenu(String route) {
      setState(() {
        visibleSetting = route;
      });
      if (isTablet) {
        return;
      }
      context.push(route);
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('settings'.tr()),
        elevation: 1,
        leading: Builder(builder: (context) {
          return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(Icons.menu));
        }),
        actions: const [],
      ),
      drawer: const AppDrawer(),
      body: Row(children: [
        Expanded(
          child: ListView(
            children: [
              ListTile(
                leading: const Icon(CupertinoIcons.printer),
                title: Text('printer_setting'.tr()),
                onTap: () => onPressMenu(Routes.printers),
                tileColor: visibleSetting == Routes.printers
                    ? Colors.grey.shade100
                    : Colors.white,
              ),
              ListTile(
                leading: const Icon(CupertinoIcons.cloud),
                title: Text('sync_data'.tr()),
                onTap: () => onPressMenu('sync_data'),
                tileColor: visibleSetting == 'sync_data'
                    ? Colors.grey.shade100
                    : Colors.white,
              ),
              ListTile(
                leading: const Icon(Icons.receipt_long_sharp),
                title: Text('auto_print'.tr()),
                onTap: () => onPressMenu('auto_print'),
                tileColor: visibleSetting == 'auto_print'
                    ? Colors.grey.shade100
                    : Colors.white,
              ),
              ListTile(
                leading: const Icon(CupertinoIcons.info_circle_fill),
                title: Text('about_app'.tr()),
                onTap: () => onPressMenu(Routes.about),
                tileColor: visibleSetting == Routes.about
                    ? Colors.grey.shade100
                    : Colors.white,
              ),
            ],
          ),
        ),
        isTablet
            ? Container(
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: Colors.grey.shade200,
                      width: 1,
                    ),
                  ),
                  color: Colors.grey.shade100,
                ),
                width:
                    ResponsiveBreakpoints.of(context).largerOrEqualTo(DESKTOP)
                        ? MediaQuery.of(context).size.width - 400
                        : MediaQuery.of(context).size.width * 0.5,
                child: visibleSetting == Routes.printers
                    ? const PrinterSetting()
                    : visibleSetting == Routes.about
                        ? const AboutApp()
                        : Container())
            : Container()
      ]),
    );
  }
}
