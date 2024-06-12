import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/providers/cart/cart_provider.dart';
import 'package:selleri/ui/components/hold/hold_form.dart';

class HoldButton extends ConsumerWidget {
  const HoldButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void onHold() {
      showModalBottomSheet(
          context: context,
          backgroundColor: Colors.white,
          isDismissible: false,
          enableDrag: false,
          isScrollControlled: true,
          builder: (context) {
            return const HoldForm();
          });
    }

    return IconButton(
      tooltip: 'hold_current_transaction'.tr(),
      onPressed: onHold,
      icon: ref.watch(cartNotiferProvider).holdAt == null
          ? const Icon(CupertinoIcons.doc_fill)
          : Badge(
              backgroundColor: Colors.green,
              alignment: Alignment.bottomRight,
              label: const Icon(
                CupertinoIcons.checkmark_alt,
                color: Colors.white,
                size: 10,
              ),
              child: Icon(
                CupertinoIcons.doc_fill,
                color: Colors.grey.shade700,
              ),
            ),
    );
  }
}
