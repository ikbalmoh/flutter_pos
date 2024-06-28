import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:selleri/providers/auth/auth_provider.dart';
import 'package:selleri/providers/cart/cart_provider.dart';
import 'package:selleri/providers/settings/printer_provider.dart';
import 'package:selleri/router/routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/utils/app_alert.dart';

class HomeMenu extends ConsumerWidget {
  const HomeMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void onSignOut() {
      AppAlert.confirm(
        context,
        title: 'logout_confirmation'.tr(),
        onConfirm: () => ref.read(authNotifierProvider.notifier).logout(),
        confirmLabel: 'logout'.tr(),
      );
    }

    return MenuAnchor(
      style: MenuStyle(backgroundColor:
          WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
        return Colors.white;
      })),
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
          icon: Badge(
            smallSize: 8,
            backgroundColor: ref.watch(printerNotifierProvider).value != null
                ? Colors.transparent
                : Colors.red.shade600,
            child: const Icon(Icons.more_vert),
          ),
          tooltip: 'show_menu'.tr(),
        );
      },
      menuChildren: [
        MenuItemButton(
          onPressed: () => context.push(Routes.customers),
          leadingIcon: Icon(
            CupertinoIcons.rectangle_stack_person_crop,
            color: ref.watch(cartNotiferProvider).idCustomer == null
                ? Colors.blueGrey.shade500
                : Colors.green.shade600,
          ),
          child: Text(ref.watch(cartNotiferProvider).customerName ??
              'select_customer'.tr()),
        ),
        MenuItemButton(
          onPressed: () => ref.read(cartNotiferProvider.notifier).initCart(),
          leadingIcon: Icon(
            CupertinoIcons.doc,
            color: Colors.blueGrey.shade500,
          ),
          child: Text('new_transaction'.tr()),
        ),
        const PopupMenuDivider(),
        MenuItemButton(
          onPressed: () => context.push(Routes.printers),
          leadingIcon: Badge(
            smallSize: 8,
            backgroundColor: ref.watch(printerNotifierProvider).value != null
                ? Colors.green.shade500
                : Colors.red.shade600,
            child: Icon(
              CupertinoIcons.printer,
              color: Colors.blueGrey.shade400,
            ),
          ),
          child:
              Text(ref.watch(printerNotifierProvider).value?.name ?? 'Printer'),
        ),
        MenuItemButton(
          onPressed: onSignOut,
          leadingIcon: const Icon(
            CupertinoIcons.square_arrow_left,
            color: Colors.red,
          ),
          child: Text('logout'.tr()),
        ),
      ],
    );
  }
}
