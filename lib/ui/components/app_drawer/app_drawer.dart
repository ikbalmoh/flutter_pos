import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:selleri/providers/outlet/outlet_provider.dart';
import 'package:selleri/router/routes.dart';
import 'package:selleri/ui/components/app_drawer/app_drawer_header.dart';
import 'package:selleri/ui/components/app_drawer/app_drawer_menu.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final outlet = ref.watch(outletProvider).value as OutletSelected;
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
          outlet.config.addOns!.contains("app-adjustment")
              ? AppDrawerMenu(
                  icon: const Icon(
                      CupertinoIcons.slider_horizontal_below_rectangle),
                  title: 'stock_adjustments'.tr(),
                  route: Routes.adjustments,
                )
              : Container(),
          outlet.config.addOns!.contains("item-receiving")
              ? AppDrawerMenu(
                  icon: const Icon(CupertinoIcons.tray),
                  title: 'receiving'.tr(),
                  route: Routes.receiving,
                  pathParameters: const {"type": '1', "code": " "},
                )
              : Container(),
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
