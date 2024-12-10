import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/providers/adjustment/adjustment_provider.dart';
import 'package:selleri/ui/screens/adjustments/components/adjustment_list_history.dart';
import 'package:selleri/utils/app_alert.dart';

class SubmitAdjustmentSheet extends ConsumerStatefulWidget {
  const SubmitAdjustmentSheet({super.key});

  @override
  ConsumerState<SubmitAdjustmentSheet> createState() =>
      _SubmitAdjustmentSheetState();
}

class _SubmitAdjustmentSheetState extends ConsumerState<SubmitAdjustmentSheet> {
  final descriptionController = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  void showHistory() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.white,
      showDragHandle: true,
      builder: (context) => DraggableScrollableSheet(
        builder: (_, controller) => AdjustmentListHistory(
          controller: controller,
        ),
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
      ),
    );
  }

  void onSubmit(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    try {
      String message = await ref
          .read(adjustmentProvider.notifier)
          .submitAdjustment(description: descriptionController.text);
      setState(() {
        isLoading = false;
      });
      if (context.mounted) {
        while (context.canPop()) {
          context.pop();
        }
        AppAlert.toast(message);
        showHistory();
      }
    } on Exception catch (e) {
      setState(() {
        isLoading = false;
      });
      AppAlert.toast(e.toString());
    }
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
          (MediaQuery.of(context).viewInsets.bottom > 0 ? 0.7 : 0.4)),
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
            child: TextFormField(
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
                      disabledForegroundColor: Colors.grey,
                      // side: const BorderSide(color: Colors.blue),
                      disabledBackgroundColor: Colors.grey.shade100,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                    ),
                    onPressed: isLoading ? null : () => context.pop(),
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
                  onPressed: isLoading ? null : () => onSubmit(context),
                  icon: isLoading
                      ? const SizedBox(
                          height: 12,
                          width: 12,
                          child: CircularProgressIndicator(
                            strokeWidth: 1,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(CupertinoIcons.checkmark_alt),
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
