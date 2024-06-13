import 'package:easy_localization/easy_localization.dart';
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
        },
      );
    }

    return Flexible(
      fit: FlexFit.loose,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          foregroundColor: Colors.blue,
          side: const BorderSide(color: Colors.blue),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
        ),
        onPressed: onHold,
        child: Text(
          ref.watch(cartNotiferProvider).holdAt == null
              ? 'hold'.tr().toUpperCase()
              : 'update'.tr().toUpperCase(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
