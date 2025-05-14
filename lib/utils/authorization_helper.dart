import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:selleri/ui/components/pic/pin_input.dart';
import 'package:selleri/providers/outlet/outlet_provider.dart';
import 'package:selleri/data/models/outlet_config.dart';
import 'package:selleri/ui/components/verificator_picker.dart';
import 'package:selleri/utils/app_alert.dart';

class AuthorizationHelper {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Future<bool> authorize(String module) async {
    final context = navigatorKey.currentContext;
    if (context == null) {
      throw ('Navigation context not available');
    }

    try {
      final container = ProviderContainer();
      final outletState = await container.read(outletProvider.future);
      if (outletState is OutletNotSelected) {
        throw ('No outlet selected');
      }

      final OutletConfig outletConfig = (outletState as OutletSelected).config;

      final userHasPinList = outletConfig.userHasPin ?? [];

      if (userHasPinList.isEmpty) {
        return true;
      }

      final List<PinSetting> pinSettings = outletConfig.pinSettings ?? [];
      if (pinSettings.isEmpty) {
        throw ('PIN setting not available');
      }

      final PinSetting? modulePinSetting =
          pinSettings.firstWhereOrNull((setting) => setting.name == module);
      if (modulePinSetting == null) {
        throw ('No PIN setting for module $module');
      }
      if (modulePinSetting.locked == false) {
        log('${modulePinSetting.name} no locked');
        return true;
      }

      // Step 1: Select PIC
      final selectedUser = await showModalBottomSheet<UserHasPin>(
        context: context,
        isDismissible: false,
        builder: (BuildContext context) {
          return DraggableScrollableSheet(
            initialChildSize: 0.7,
            minChildSize: 0.5,
            maxChildSize: 0.8,
            expand: false,
            builder: (context, scrollController) {
              return VerificatorPicker(
                  scrollController: scrollController,
                  description:
                      modulePinSetting.description ?? modulePinSetting.name);
            },
          );
        },
      );

      if (selectedUser == null) {
        return false;
      }

      // Step 2: Enter PIN
      bool isVerified = false;
      String? errorText;

      while (!isVerified) {
        final pin = await showDialog<String>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              titlePadding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              title: Container(
                padding: const EdgeInsets.only(
                    top: 15, left: 17.5, right: 15, bottom: 10),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 0.5,
                      color: Colors.blueGrey.shade100,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'enter_x'.tr(args: ['PIN']),
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        Text(
                          selectedUser.userName,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () => context.pop(),
                      iconSize: 18,
                      icon: Icon(
                        Icons.close,
                        color: Colors.grey.shade700,
                      ),
                    )
                  ],
                ),
              ),
              content: SizedBox(
                width: 350,
                child: PinInput(
                  onSubmit: (pin) {
                    Navigator.of(context).pop(pin);
                  },
                  pinLength: selectedUser.userPin.length,
                  errorText: errorText,
                ),
              ),
            );
          },
        );

        if (pin == null) {
          // Dialog was dismissed
          return false;
        }

        if (pin == selectedUser.userPin) {
          isVerified = true;
        } else {
          errorText = 'Invalid PIN';
        }
      }

      return true;
    } catch (e) {
      AppAlert.snackbar(e.toString(), alertType: AlertType.error);
      return false;
    }
  }
}
