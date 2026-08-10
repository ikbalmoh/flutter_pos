import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:selleri/features/cart/provider/cart_provider.dart';
import 'package:selleri/features/holded/provider/holded_provider.dart';
import 'package:selleri/features/outlet/model/refund_reason.dart';
import 'package:selleri/features/outlet/provider/refund_reason_provider.dart'
    as provider;
import 'package:selleri/shared/utils/app_alert.dart';

class RemoveHoldForm extends ConsumerStatefulWidget {
  final Function() onRemoved;
  final String transactionId;
  final String transactionNo;
  final bool shouldCreateNewTransaciton;

  const RemoveHoldForm({
    required this.onRemoved,
    super.key,
    required this.transactionId,
    required this.transactionNo,
    required this.shouldCreateNewTransaciton,
  });

  @override
  ConsumerState<RemoveHoldForm> createState() => _RemoveHoldFormState();
}

class _RemoveHoldFormState extends ConsumerState<RemoveHoldForm> {
  final GlobalKey<_RemoveHoldFormState> removeWidgetKey = GlobalKey();

  RefundReason? reason;
  String notes = '';

  bool removing = false;

  @override
  void initState() {
    super.initState();
  }

  void onRemove() async {
    final context = removeWidgetKey.currentContext;

    FocusManager.instance.primaryFocus?.unfocus();

    if (reason == null) {
      return;
    }

    setState(() {
      removing = true;
    });

    try {
      final isRemoved = await ref
          .read(holdedProvider.notifier)
          .deleteHoldedTransaction(
            widget.transactionId,
            reasonId: reason?.id ?? '',
            notes: notes,
            createNewTransaciton: widget.shouldCreateNewTransaciton,
          );
      if (!isRemoved) {
        return;
      }

      AppAlert.toast('successfully_deleted'.tr(args: ['transaction'.tr()]));

      widget.onRemoved.call();

      if (context?.mounted == true) {
        context!.pop();
      }
    } on Exception catch (e) {
      log('REMOVE HOLD ERROR: ${e.toString()}');
      AppAlert.toast(e.toString());
    } finally {
      setState(() {
        removing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    final refundReasons = ref.watch(provider.refundReasonProvider).value ?? [];

    final canSubmit =
        reason != null &&
        removing == false &&
        (reason?.needNotes == false ? true : notes.trim().isNotEmpty);

    return PopScope(
      key: removeWidgetKey,
      canPop: !removing,
      child: SingleChildScrollView(
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
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'delete_transaction'.tr(),
                        style: textTheme.headlineSmall?.copyWith(
                          color: Colors.red.shade600,
                        ),
                      ),
                      Text(
                        widget.transactionNo,
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: removing ? null : () => context.pop(),
                  icon: Icon(
                    Icons.close,
                    size: 18,
                    color: removing
                        ? Colors.grey.shade400
                        : Colors.grey.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'reason'.tr(),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.grey.shade700,
                    ),
                  ),
                  TextSpan(
                    text: ' *',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Colors.red.shade600,
                    ),
                  ),
                ],
              ),
            ),
            DropdownButton<RefundReason>(
              dropdownColor: Colors.white,
              value: reason,
              hint: Text('select_x'.tr(args: ['reason'.tr()])),
              onChanged: (value) {
                log('reason: $reason');
                setState(() {
                  reason = value;
                });
              },
              items: refundReasons.map<DropdownMenuItem<RefundReason>>((
                RefundReason reason,
              ) {
                return DropdownMenuItem<RefundReason>(
                  value: reason,
                  child: Text(reason.reason),
                );
              }).toList(),
              underline: const SizedBox(),
            ),
            TextFormField(
              initialValue: ref.read(cartProvider).notes,
              onChanged: (value) {
                setState(() {
                  notes = value;
                });
              },
              decoration: InputDecoration(
                label: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'note'.tr(),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.grey.shade700,
                        ),
                      ),
                      if (reason?.needNotes == true)
                        TextSpan(
                          text: ' *',
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(color: Colors.red.shade600),
                        ),
                    ],
                  ),
                ),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: removing
                  ? [
                      TextButton.icon(
                        style: ElevatedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                        ),
                        onPressed: null,
                        icon: const SizedBox(
                          width: 15,
                          height: 15,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.grey,
                          ),
                        ),
                        label: Text('delete'.tr()),
                      ),
                    ]
                  : [
                      Flexible(
                        child: TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.teal,
                          ),
                          onPressed: () => context.pop(),
                          child: Text('cancel'.tr()),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(30),
                              ),
                            ),
                          ),
                          onPressed: canSubmit ? () => onRemove() : null,
                          child: Text('delete'.tr()),
                        ),
                      ),
                    ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
