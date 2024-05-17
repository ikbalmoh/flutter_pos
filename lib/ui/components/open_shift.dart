import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:selleri/providers/shift/shift_provider.dart';

class OpenShift extends ConsumerStatefulWidget {
  const OpenShift({super.key});

  @override
  ConsumerState<OpenShift> createState() => _OpenShiftState();
}

class _OpenShiftState extends ConsumerState<OpenShift> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    TextStyle? labelStyle = Theme.of(context)
        .textTheme
        .bodyMedium
        ?.copyWith(color: Colors.blueGrey.shade600);

    return AlertDialog(
      title: Text('open_shift'.tr()),
      content: TextFormField(
        controller: _controller,
        textAlign: TextAlign.right,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(left: 0, bottom: 15, right: 0),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          label: Text(
            'starting_cash'.tr(),
            style: labelStyle,
          ),
          prefix: Text(
            'starting_cash'.tr(),
            style: labelStyle,
          ),
          alignLabelWithHint: true,
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 0.5,
              color: Colors.blueGrey.shade100,
            ),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              width: 0.5,
              color: Colors.teal,
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            context.pop();
          },
          style: TextButton.styleFrom(foregroundColor: Colors.grey),
          child: Text('cancel'.tr()),
        ),
        TextButton(
            onPressed: () {
              ref.read(shiftNotifierProvider.notifier).openShift(
                    double.parse(_controller.text),
                  );
              context.pop();
            },
            child: Text('start_shift'.tr())),
      ],
    );
  }
}
