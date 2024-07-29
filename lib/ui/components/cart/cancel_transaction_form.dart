// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:selleri/data/models/cart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/providers/transaction/transactions_provider.dart';
import 'package:selleri/ui/components/generic/loading_placeholder.dart';
import 'package:selleri/utils/app_alert.dart';

class CancelTransactionForm extends ConsumerStatefulWidget {
  const CancelTransactionForm({super.key, required this.cart});

  final Cart cart;

  @override
  ConsumerState<CancelTransactionForm> createState() =>
      _CancelTransactionFormState();
}

class _CancelTransactionFormState extends ConsumerState<CancelTransactionForm> {
  String deleteReason = '';
  bool checked = false;

  bool isLoading = false;

  void onSubmit() async {
    try {
      setState(() {
        isLoading = true;
      });
      final transaction = await ref
          .read(transactionsNotifierProvider.notifier)
          .cancelTransaction(widget.cart, deleteReason: deleteReason);
      AppAlert.snackbar(context, 'transaction_canceled'.tr());
      context.pop(transaction);
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle? labelStyle = Theme.of(context)
        .textTheme
        .bodyMedium
        ?.copyWith(color: Colors.blueGrey.shade600);

    return PopScope(
      canPop: !isLoading,
      child: isLoading
          ? const LoadingPlaceholder()
          : Padding(
              padding: EdgeInsets.only(
                left: 15,
                right: 15,
                bottom: MediaQuery.of(context).viewInsets.bottom + 15,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                        top: 8, left: 0, right: 0, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'cancel_transaction'.tr(),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        IconButton(
                          onPressed: () => context.pop(),
                          iconSize: 18,
                          icon: Icon(
                            Icons.close,
                            color: Colors.grey.shade700,
                          ),
                        )
                      ],
                    ),
                  ),
                  TextFormField(
                    maxLines: null,
                    initialValue: deleteReason,
                    onChanged: (value) {
                      setState(() {
                        deleteReason = value;
                      });
                    },
                    keyboardType: TextInputType.multiline,
                    autofocus: true,
                    decoration: InputDecoration(
                      label: Text(
                        'cancelation_reason'.tr(),
                        style: labelStyle,
                      ),
                      hintText: 'add'.tr(args: ['cancelation_reason'.tr()]),
                      alignLabelWithHint: true,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Checkbox(
                        visualDensity:
                            const VisualDensity(horizontal: -4, vertical: -4),
                        value: checked,
                        onChanged: (value) {
                          setState(() {
                            checked = value ?? false;
                          });
                        },
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text('cancel_transaction_confirmation'.tr())
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(30),
                        ),
                      ),
                    ),
                    onPressed:
                        deleteReason.isNotEmpty && checked ? onSubmit : null,
                    child: Text('submit'.tr()),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
    );
  }
}
