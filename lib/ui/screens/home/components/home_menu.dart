import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:selleri/providers/auth/auth_provider.dart';
import 'package:selleri/providers/cart/cart_provider.dart';
import 'package:selleri/router/routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/ui/screens/settings/printer/printer_setting.dart';
import 'package:selleri/utils/app_alert.dart';

class HomeMenu extends ConsumerWidget {
  const HomeMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void onSignOut() {
      AppAlert.confirm(
        context,
        title: 'logout'.tr(),
        subtitle: 'logout_confirmation'.tr(),
        onConfirm: () => ref.read(authNotifierProvider.notifier).logout(),
        confirmLabel: 'logout'.tr(),
      );
    }

    return MenuAnchor(
      builder:
          (BuildContext context, MenuController controller, Widget? child) {
        return IconButton(
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          icon: const Icon(Icons.more_vert),
          tooltip: 'show_menu'.tr(),
        );
      },
      menuChildren: [
        MenuItemButton(
          onPressed: () => context.push(Routes.customers),
          leadingIcon: Icon(
            Icons.account_box,
            color: ref.watch(cartNotiferProvider).idCustomer == null
                ? Colors.grey.shade800
                : Colors.green.shade600,
          ),
          child: Text(ref.watch(cartNotiferProvider).customerName ??
              'select_customer'.tr()),
        ),
        MenuItemButton(
          onPressed: () {
            showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (context) => const PrinterSetting(),
            );
          },
          leadingIcon: Icon(
            Icons.print,
            color: Colors.grey.shade800,
          ),
          child: const Text('Printer'),
        ),
        MenuItemButton(
          onPressed: onSignOut,
          leadingIcon: const Icon(
            Icons.logout,
            color: Colors.red,
          ),
          child: Text('logout'.tr()),
        ),
      ],
    );
  }
}
