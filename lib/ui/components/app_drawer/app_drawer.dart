import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/router/routes.dart';
import 'package:selleri/ui/components/app_drawer/app_drawer_header.dart';
import 'package:selleri/ui/components/app_drawer/app_drawer_menu.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const AppDrawerHeader(),
          AppDrawerMenu(
            icon: const Icon(Icons.store),
            title: 'cashier'.tr(),
            route: Routes.home,
          ),
          AppDrawerMenu(
            icon: const Icon(Icons.list_rounded),
            title: 'transaction_history'.tr(),
            route: Routes.transactions,
          ),
        ],
      ),
    );
  }
}
