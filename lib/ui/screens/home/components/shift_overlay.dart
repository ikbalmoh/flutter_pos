import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/providers/cart/cart_provider.dart';
import 'package:selleri/providers/shift/shift_provider.dart';
import 'package:selleri/ui/components/open_shift.dart';
import 'package:selleri/ui/widgets/loading_widget.dart';

class ShiftOverlay extends ConsumerWidget {
  const ShiftOverlay({super.key});

  void showOpenShift(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return const OpenShift();
        });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(shiftNotifierProvider, (previous, next) {
      next.whenData((value) {
        // Open shift
        if (value == null) {
          showOpenShift(context);
        } else {
          ref.read(cartNotiferProvider.notifier).initCart();
        }
      });
    });

    return switch (ref.watch(shiftNotifierProvider)) {
      AsyncData(:final value) => value == null
          ? Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.3),
                child: Center(
                  child: SizedBox(
                    width: 150,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.playlist_add_sharp),
                      label: Text('open_shift'.tr()),
                      onPressed: () => showOpenShift(context),
                    ),
                  ),
                ),
              ),
            )
          : Container(),
      AsyncError(:final error) => Positioned.fill(
          child: Container(
            color: Colors.black.withOpacity(0.3),
            child: Center(
              child: Text(
                error.toString(),
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      _ => Positioned.fill(
          child: Container(
            color: Colors.black.withOpacity(0.3),
            child: const Center(
              child: LoadingIndicator(color: Colors.teal),
            ),
          ),
        )
    };
  }
}
