import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:selleri/ui/components/pic/pin_input.dart';
import 'package:selleri/providers/outlet/outlet_provider.dart';
import 'package:selleri/data/models/outlet_config.dart';

class PinInputHelper {
  static Future<bool> verifyPin({
    required BuildContext context,
    String title = 'Enter PIN',
    int minLength = 4,
    int maxLength = 6,
  }) async {
    final container = ProviderContainer();
    final outletState = await container.read(outletProvider.future);
    if (outletState is OutletNotSelected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No outlet selected')),
      );
      return false;
    }

    final userHasPinList =
        (outletState as OutletSelected).config.userHasPin ?? [];

    if (userHasPinList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No users with PIN found')),
      );
      return false;
    }

    // Step 1: Select PIC
    final selectedUser = await showModalBottomSheet<UserHasPin>(
      context: context,
      isDismissible: false,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.5,
          maxChildSize: 0.8,
          expand: false,
          builder: (context, scrollController) {
            return Padding(
              padding: EdgeInsets.only(
                left: 15,
                right: 15,
                bottom: MediaQuery.of(context).viewInsets.bottom + 15,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                        top: 8, left: 0, right: 0, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'select_pic'.tr(),
                          style: Theme.of(context).textTheme.bodyLarge,
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
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: userHasPinList.length,
                      itemBuilder: (context, index) {
                        final user = userHasPinList[index];
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 0,
                          ),
                          title: Text(user.userName),
                          subtitle: user.rolesName != null
                              ? Text(user.rolesName!.join(', '))
                              : null,
                          onTap: () => Navigator.of(context).pop(user),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
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
        barrierDismissible: kDebugMode,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('${title} - ${selectedUser.userName}'),
            content: SizedBox(
              width: double.maxFinite,
              child: PinInput(
                onSubmit: (pin) {
                  Navigator.of(context).pop(pin);
                },
                minLength: minLength,
                maxLength: maxLength,
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
  }
}
