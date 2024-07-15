import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:selleri/data/models/outlet.dart';
import 'package:selleri/providers/outlet/outlet_provider.dart';
import 'package:selleri/ui/components/error_handler.dart';
import 'package:selleri/ui/widgets/loading_widget.dart';

class SelectOutletPrompt extends ConsumerWidget {
  const SelectOutletPrompt({required this.outlet, super.key});

  final Outlet outlet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextTheme textTheme = Theme.of(context).textTheme;

    void onDismiss() {
      ref.read(outletNotifierProvider.notifier).clearOutlet();
      context.pop();
    }

    void onSubmit() {
      ref.read(outletNotifierProvider.notifier).selectOutlet(
            outlet,
            onSelected: (config) => context.setLocale(
              config.locale == 'en'
                  ? const Locale('en', 'US')
                  : const Locale('id', 'ID'),
            ),
          );
    }

    final outletState = ref.watch(outletNotifierProvider).value;

    return AlertDialog(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20)
          .copyWith(bottom: 10),
      actions: outletState is! OutletLoading
          ? [
              TextButton(
                style: TextButton.styleFrom(foregroundColor: Colors.grey),
                onPressed: onDismiss,
                child: Text('cancel'.tr()),
              ),
              TextButton(
                onPressed: onSubmit,
                child: Text(outletState is OutletFailure
                    ? 'retry'.tr()
                    : 'select'.tr()),
              )
            ]
          : [],
      backgroundColor: Colors.white,
      title: Text(
        outlet.outletName,
        style: textTheme.headlineSmall,
      ),
      content: outletState is OutletNotSelected
          ? Text('select_outlet_confirm'.tr())
          : outletState is OutletFailure
              ? ErrorHandler(
                  error: outletState.message,
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    const LoadingIndicator(color: Colors.teal),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      outletState is OutletLoading
                          ? outletState.message
                          : 'preparing_outlet'.tr(),
                      style:
                          textTheme.bodyMedium?.copyWith(color: Colors.black45),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
    );
  }
}
