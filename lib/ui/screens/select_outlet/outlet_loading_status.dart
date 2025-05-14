import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/providers/outlet/outlet_provider.dart';

class OutletLoadingStatus extends ConsumerWidget {
  const OutletLoadingStatus({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(outletProvider).value;

    Widget loadingIndicator() {
      return SizedBox(
        width: 14,
        height: 14,
        child: CircularProgressIndicator(
          color: Colors.teal,
          strokeWidth: 1.5,
        ),
      );
    }

    Widget loadedIndicator() {
      return Icon(
        CupertinoIcons.check_mark_circled_solid,
        color: Colors.green,
        size: 18,
      );
    }

    Widget loadingItem({required String title, required bool isLoaded}) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(title)),
          isLoaded ? loadedIndicator() : loadingIndicator()
        ],
      );
    }

    Widget loadingSkeleton() {
      return Container(
        width: Random().nextDouble() * 250,
        height: 15,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(10),
        ),
      );
    }

    if (state is! OutletLoading) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 15,
        children: List.generate(
          5,
          (index) => loadingSkeleton(),
        ),
      );
    }

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.5,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12.5, vertical: 10),
      child: SingleChildScrollView(
        child: Column(
          spacing: 15,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            loadingItem(
                title: 'outlet_config'.tr(), isLoaded: state.config ?? false),
            loadingItem(
                title: 'categories'.tr(), isLoaded: state.categories ?? false),
            loadingItem(
                title: 'promotions'.tr(), isLoaded: state.promotions ?? false),
            ...(state.items != null && state.items!.isNotEmpty
                ? state.items!.map(
                    (e) => loadingItem(title: e.category, isLoaded: e.isLoaded),
                  )
                : List.generate(
                    5,
                    (index) => loadingSkeleton(),
                  )),
          ],
        ),
      ),
    );
  }
}
