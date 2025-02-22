import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:selleri/providers/cart/cart_provider.dart';
import 'package:selleri/providers/outlet/outlet_provider.dart';
import 'package:selleri/providers/settings/app_settings_provider.dart';
import 'package:selleri/providers/settings/printer_provider.dart';
import 'package:selleri/providers/shift/shift_provider.dart';
import 'package:selleri/router/routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/ui/components/hold/hold_form.dart';
import 'package:selleri/ui/screens/item/add_extra_item_form.dart';

class HomeMenu extends ConsumerWidget {
  const HomeMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final outlet = ref.watch(outletProvider).value as OutletSelected;

    void onNewTransaction() {
      if (ref.read(cartProvider).items.isNotEmpty) {
        showModalBottomSheet(
          context: context,
          isDismissible: false,
          enableDrag: false,
          isScrollControlled: true,
          builder: (context) {
            return HoldForm(
              onHolded: () {
                context.pop();
                ref.read(cartProvider.notifier).initCart();
              },
            );
          },
        );
      } else {
        ref.read(cartProvider.notifier).initCart();
      }
    }

    void showAddExtraItem() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => const AddExtraItemForm(),
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
            backgroundColor: ref.watch(printerProvider).value != null
                ? Colors.transparent
                : Colors.red.shade600,
            child: const Icon(Icons.more_vert),
          ),
          tooltip: 'show_menu'.tr(),
        );
      },
      menuChildren: [
        ...ref.watch(shiftProvider).value == null
            ? []
            : [
                MenuItemButton(
                  onPressed: () => context.push(Routes.customers),
                  leadingIcon: Icon(
                    CupertinoIcons.rectangle_stack_person_crop,
                    color: ref.watch(cartProvider).idCustomer == null
                        ? Colors.blueGrey.shade500
                        : Colors.green.shade600,
                  ),
                  child: Text(ref.watch(cartProvider).customerName ??
                      'select_customer'.tr()),
                ),
                MenuItemButton(
                  onPressed: () => context.push(Routes.holded),
                  leadingIcon: Icon(
                    CupertinoIcons.folder,
                    color: Colors.blueGrey.shade500,
                  ),
                  child: Text('holded_transactions'.tr()),
                ),
                MenuItemButton(
                  onPressed: onNewTransaction,
                  leadingIcon: Icon(
                    CupertinoIcons.doc,
                    color: Colors.blueGrey.shade500,
                  ),
                  child: Text('new_transaction'.tr()),
                ),
                const PopupMenuDivider(),
                MenuItemButton(
                  onPressed: () => context.push(Routes.promotions),
                  leadingIcon: Icon(
                    CupertinoIcons.tags,
                    color: Colors.amber.shade800,
                  ),
                  child: Text('promotion_list'.tr()),
                ),
                outlet.config.extraItem == true
                    ? MenuItemButton(
                        onPressed: showAddExtraItem,
                        leadingIcon: Icon(
                          CupertinoIcons.cart_badge_plus,
                          color: Colors.blue.shade700,
                        ),
                        child: Text('extra_item'.tr()),
                      )
                    : Container(),
                MenuItemButton(
                  onPressed: () => context.push(Routes.addItem),
                  leadingIcon: Icon(
                    CupertinoIcons.plus_square_on_square,
                    color: Colors.teal.shade700,
                  ),
                  child: Text('add_item'.tr()),
                ),
                const PopupMenuDivider(),
                MenuItemButton(
                  onPressed: () =>
                      ref.read(appSettingsProvider.notifier).changeItemLayout(),
                  leadingIcon: Icon(
                      ref.watch(appSettingsProvider).itemLayoutGrid
                          ? CupertinoIcons.rectangle_grid_1x2
                          : CupertinoIcons.square_grid_2x2_fill),
                  child: Text(
                    ref.watch(appSettingsProvider).itemLayoutGrid
                        ? 'list_view'.tr()
                        : 'grid_view'.tr(),
                  ),
                ),
              ],
        MenuItemButton(
          onPressed: () => context.push(Routes.printers),
          leadingIcon: Badge(
            smallSize: 8,
            backgroundColor: ref.watch(printerProvider).value != null
                ? Colors.green.shade500
                : Colors.red.shade600,
            child: Icon(
              CupertinoIcons.printer,
              color: Colors.blueGrey.shade400,
            ),
          ),
          child: Text(ref.watch(printerProvider).value?.name ?? 'Printer'),
        ),
      ],
    );
  }
}
