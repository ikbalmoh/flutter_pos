import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:selleri/router/routes.dart';
import 'package:selleri/ui/components/app_drawer/app_drawer_header.dart';
import 'package:selleri/ui/components/app_drawer/app_drawer_menu.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const AppDrawerHeader(),
          AppDrawerMenu(
            icon: const Icon(Icons.storefront),
            title: 'cashier'.tr(),
            route: Routes.home,
          ),
          AppDrawerMenu(
            icon: const Icon(CupertinoIcons.list_bullet),
            title: 'transaction_history'.tr(),
            route: Routes.transactions,
          ),
          AppDrawerMenu(
            icon: const Icon(CupertinoIcons.calendar),
            title: 'shift'.tr(),
            route: Routes.shift,
          ),
          AppDrawerMenu(
            icon: const Icon(CupertinoIcons.slider_horizontal_3),
            title: 'settings'.tr(),
            route: Routes.settings,
          ),
        ],
      ),
    );
  }
}
