import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:selleri/ui/components/shift/open_shift.dart';

class OpenShiftButton extends StatelessWidget {
  const OpenShiftButton({super.key});

  @override
  Widget build(BuildContext context) {
    void showOpenShift() {
      showDialog(
          context: context,
          builder: (context) {
            return const OpenShift();
          });
    }

    return TextButton.icon(
      style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
      onPressed: showOpenShift,
      label: Text('open_shift'.tr()),
      icon: const Icon(CupertinoIcons.list_bullet_below_rectangle, color: Colors.white,),
    );
  }
}
