import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/providers/cart/cart_provider.dart';
import 'package:selleri/providers/shift/shift_provider.dart';
import 'package:selleri/ui/components/shift/open_shift.dart';
import 'package:selleri/ui/components/shift/shift_inactive.dart';
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
                color: Colors.black12,
                child: const ShiftInactive(),
              ),
            )
          : Container(),
      AsyncError() => Container(),
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
