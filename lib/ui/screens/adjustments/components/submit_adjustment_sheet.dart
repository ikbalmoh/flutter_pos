import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/providers/adjustment/adjustment_provider.dart';

class SubmitAdjustmentSheet extends ConsumerStatefulWidget {
  const SubmitAdjustmentSheet({super.key});

  @override
  ConsumerState<SubmitAdjustmentSheet> createState() =>
      _SubmitAdjustmentSheetState();
}

class _SubmitAdjustmentSheetState extends ConsumerState<SubmitAdjustmentSheet> {
  final descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  void onSubmit() {
    ref.read(adjustmentProvider.notifier).submitAdjustment(description: descriptionController.text );
  }

  @override
  Widget build(BuildContext context) {
    TextStyle? labelStyle = Theme.of(context)
        .textTheme
        .bodyMedium
        ?.copyWith(color: Colors.blueGrey.shade600);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      height: (MediaQuery.of(context).size.height *
          (MediaQuery.of(context).viewInsets.bottom > 0 ? 0.95 : 0.7)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding:
                const EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 0.5,
                  color: Colors.blueGrey.shade100,
                ),
              ),
            ),
            child: Text(
              'submit_x'.tr(args: ['adjustment'.tr()]),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                children: [
                  TextFormField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(
                          left: 0, top: 10, right: 0, bottom: 10),
                      label: Text(
                        'note'.tr(),
                        style: labelStyle,
                      ),
                      alignLabelWithHint: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Flexible(
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
                    onPressed: () => context.pop(),
                    child: Text('cancel'.tr())),
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
                      ),
                    ),
                  ),
                  onPressed: onSubmit,
                  icon: const Icon(CupertinoIcons.checkmark_alt),
                  label: Text('save'.tr()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
