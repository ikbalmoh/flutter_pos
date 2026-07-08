import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:selleri/shared/utils/app_alert.dart';

class Prompt extends ConsumerStatefulWidget {
  final Function(String?)? onConfirm;
  final String title;
  final String confirmLabel;
  final bool? danger;
  final bool shouldPop;
  final String note;

  const Prompt({
    this.onConfirm,
    this.title = '',
    this.confirmLabel = '',
    this.danger,
    this.shouldPop = true,
    this.note = '',
    super.key,
  });

  @override
  ConsumerState<Prompt> createState() => _HoldFormState();
}

class _HoldFormState extends ConsumerState<Prompt> {
  final GlobalKey<_HoldFormState> holdWidgetKey = GlobalKey();

  String description = '';

  @override
  void initState() {
    setState(() {
      description = widget.note;
    });
    super.initState();
  }

  void onOk() async {
    final context = holdWidgetKey.currentContext;

    FocusManager.instance.primaryFocus?.unfocus();

    try {
      if (widget.onConfirm != null) {
        widget.onConfirm!(description);
      }
      if (context != null && context.mounted) {
        if (context.canPop()) {
          context.pop();
        }
      }
    } on Exception catch (e) {
      AppAlert.toast(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return PopScope(
      key: holdWidgetKey,
      canPop: true,
      child: Padding(
        padding: EdgeInsets.only(
          top: 20,
          left: 15,
          right: 15,
          bottom: MediaQuery.of(context).viewInsets.bottom + 15,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: textTheme.headlineSmall,
                ),
                IconButton(
                    onPressed: () => context.pop(),
                    icon: Icon(
                      Icons.close,
                      color: Colors.grey.shade700,
                    ))
              ],
            ),
            const SizedBox(height: 10),
            TextFormField(
              initialValue: widget.note,
              autofocus: true,
              onChanged: (value) {
                setState(() {
                  description = value;
                });
              },
              decoration: InputDecoration(
                label: Text('note'.tr()),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.blue,
                    ),
                    onPressed: () => context.pop(),
                    child: Text('cancel'.tr()),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(30),
                        ),
                      ),
                    ),
                    onPressed: () => onOk(),
                    child: Text('save'.tr()),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
