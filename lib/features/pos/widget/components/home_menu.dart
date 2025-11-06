import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:selleri/features/cart/provider/cart_provider.dart';
import 'package:selleri/features/outlet/provider/outlet_provider.dart';
import 'package:selleri/features/settings/provider/app_settings_provider.dart';
import 'package:selleri/features/settings/provider/printer_provider.dart';
import 'package:selleri/features/shift/provider/shift_provider.dart';
import 'package:selleri/shared/router/routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/features/holded/widget/components/hold_form.dart';
import 'package:selleri/features/pos/widget/add_extra_item_form.dart';

class HomeMenu extends ConsumerWidget {
  const HomeMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final outlet = ref.watch(outletProvider).value as OutletSelected;

    final cart = ref.watch(cartProvider);

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

    ButtonStyle menuStyle = ButtonStyle(
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      padding: WidgetStateProperty.all<EdgeInsets?>(
          EdgeInsets.symmetric(horizontal: 15)),
    );

    return MenuAnchor(
      style: MenuStyle(
        backgroundColor: WidgetStateProperty.all<Color?>(Colors.white),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
        padding: WidgetStateProperty.all<EdgeInsets?>(EdgeInsets.all(5)),
        elevation: WidgetStateProperty.all<double>(15),
        shadowColor: WidgetStateProperty.all<Color>(Colors.grey.shade50),
      ),
      alignmentOffset:
          Offset(ref.watch(shiftProvider).value == null ? 0 : -160, -10),
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
            child: cart.idCustomer != null
                ? Icon(
                    cart.vehicle != null
                        ? Icons.drive_eta_rounded
                        : Icons.person,
                    color: Colors.green.shade600,
                  )
                : Icon(Icons.more_vert),
          ),
          tooltip: 'show_menu'.tr(),
          visualDensity: VisualDensity.comfortable,
        );
      },
      menuChildren: [
        ...ref.watch(shiftProvider).value == null
            ? []
            : [
                MenuItemButton(
                  onPressed: () => context.push(Routes.customers),
                  leadingIcon: Icon(
                    cart.vehicle != null
                        ? Icons.drive_eta_rounded
                        : Icons.person,
                    color: cart.idCustomer == null
                        ? Colors.blueGrey.shade500
                        : Colors.green.shade600,
                  ),
                  style: menuStyle,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(cart.customerName?.trim() ?? 'select_customer'.tr()),
                      if (cart.vehicle != null)
                        Text(
                          cart.vehicle!.licensePlate,
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                    ],
                  ),
                ),
                if (outlet.config.addOns!.contains("table"))
                  MenuItemButton(
                    onPressed: () => context.push(Routes.tables),
                    leadingIcon: Icon(
                      CupertinoIcons.square_grid_3x2,
                      color: cart.tables == null || cart.tables!.isEmpty
                          ? Colors.blueGrey.shade500
                          : Colors.green.shade600,
                    ),
                    style: menuStyle,
                    child: Text(
                      cart.tables == null || cart.tables!.isEmpty
                          ? 'select_x'.tr(args: ['table'.tr()])
                          : cart.tables!.join(','),
                    ),
                  ),
                if (outlet.config.extraItem == true)
                  MenuItemButton(
                    onPressed: showAddExtraItem,
                    leadingIcon: Icon(
                      CupertinoIcons.cart_badge_plus,
                      color: Colors.blue.shade700,
                    ),
                    style: menuStyle,
                    child: Text('extra_item'.tr()),
                  ),
                PopupMenuDivider(
                  color: Colors.blueGrey.shade50,
                ),
                MenuItemButton(
                  onPressed: onNewTransaction,
                  leadingIcon: Icon(
                    CupertinoIcons.doc,
                    color: Colors.blueGrey.shade500,
                  ),
                  style: menuStyle,
                  child: Text('new_transaction'.tr()),
                ),
                MenuItemButton(
                  onPressed: () => context.push(Routes.holded),
                  leadingIcon: Icon(
                    CupertinoIcons.folder,
                    color: Colors.blueGrey.shade500,
                  ),
                  style: menuStyle,
                  child: Text('holded_transactions'.tr()),
                ),
                MenuItemButton(
                  onPressed: () => context.push(Routes.promotions),
                  leadingIcon: Icon(
                    CupertinoIcons.tags,
                    color: Colors.amber.shade800,
                  ),
                  style: menuStyle,
                  child: Text('promotion_list'.tr()),
                ),
                MenuItemButton(
                  onPressed: () => context.push(Routes.addItem),
                  leadingIcon: Icon(
                    CupertinoIcons.plus_square_on_square,
                    color: Colors.teal.shade700,
                  ),
                  style: menuStyle,
                  child: Text('add_item'.tr()),
                ),
                PopupMenuDivider(
                  color: Colors.blueGrey.shade50,
                ),
                MenuItemButton(
                  onPressed: () =>
                      ref.read(appSettingsProvider.notifier).changeItemLayout(),
                  leadingIcon: Icon(
                      ref.watch(appSettingsProvider).itemLayoutGrid
                          ? CupertinoIcons.rectangle_grid_1x2
                          : CupertinoIcons.square_grid_2x2_fill),
                  style: menuStyle,
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
          style: menuStyle,
          child: Text(ref.watch(printerProvider).value?.name ?? 'Printer'),
        ),
      ],
    );
  }
}
