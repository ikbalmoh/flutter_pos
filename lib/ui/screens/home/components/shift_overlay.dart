import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/providers/shift/shift_provider.dart';
import 'package:selleri/ui/components/error_handler.dart';
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
    return ref.watch(shiftNotifierProvider).when(
          data: (data) {
            return data == null
                ? Positioned.fill(
                    child: Container(
                      color: Colors.black12,
                      child: const ShiftInactive(),
                    ),
                  )
                : Container();
          },
          error: (error, stackTrace) => Positioned.fill(
            child: Container(
              color: Colors.black12,
              child: ErrorHandler(
                error: error.toString(),
                stackTrace: stackTrace.toString(),
              ),
            ),
          ),
          loading: () => Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: LoadingIndicator(color: Colors.teal),
              ),
            ),
          ),
        );
  }
}
