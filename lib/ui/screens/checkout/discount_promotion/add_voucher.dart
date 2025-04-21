import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:selleri/providers/cart/cart_provider.dart';
import 'package:selleri/providers/promotion/voucher_provider.dart';
import 'package:selleri/ui/components/promotions/voucher_card.dart';

class AddVoucher extends ConsumerStatefulWidget {
  final double subtotal;

  const AddVoucher(this.subtotal, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddVoucherState();
}

class _AddVoucherState extends ConsumerState<AddVoucher> {
  TextEditingController codeController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  void onSearchCode() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    final String code = codeController.text;
    await ref.read(voucherProvider.notifier).getVoucher(code);
    focusNode.unfocus();
  }

  void onSubmit() async {
    ref
        .read(cartProvider.notifier)
        .applyVoucher(ref.read(voucherProvider).value!);
    if (mounted) {
      context.pop();
    }
  }

  void clearError() {
    ref.read(voucherProvider.notifier).clearError();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle? labelStyle = Theme.of(context)
        .textTheme
        .bodyMedium
        ?.copyWith(color: Colors.blueGrey.shade600);

    final voucherState = ref.watch(voucherProvider);
    final error = voucherState.error?.toString();

    return Padding(
      padding: EdgeInsets.only(
        top: 10,
        left: 15,
        right: 15,
        bottom: MediaQuery.of(context).viewInsets.bottom + 5,
      ),
      child: Form(
        autovalidateMode: AutovalidateMode.always,
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding:
                  const EdgeInsets.only(top: 0, left: 5, right: 0, bottom: 5),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 0.5,
                    color: Colors.blueGrey.shade100,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'add'.tr(args: ['voucher'.tr()]),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(
                      Icons.close,
                      size: 15,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              focusNode: focusNode,
              autofocus: true,
              onChanged: (_) => clearError(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'enter_x'
                      .tr(args: ['voucher_code'.tr().toLowerCase()]);
                } else if (voucherState.hasError) {
                  return error;
                }
                return null;
              },
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.only(left: 0, bottom: 10, right: 0),
                label: Text(
                  'voucher_code'.tr(),
                  style: labelStyle,
                ),
                alignLabelWithHint: false,
                suffix: voucherState.isLoading
                    ? TextButton.icon(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.teal.shade50,
                          visualDensity: VisualDensity.compact,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: null,
                        icon: const SizedBox(
                          width: 15,
                          height: 15,
                          child: CircularProgressIndicator(
                            strokeWidth: 1,
                            color: Colors.grey,
                          ),
                        ),
                        label: Text('loading_x'.tr(args: ['voucher'.tr()])),
                      )
                    : TextButton.icon(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.teal.shade50,
                          visualDensity: VisualDensity.compact,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: onSearchCode,
                        icon: const Icon(CupertinoIcons.search),
                        label: Text('check'.tr()),
                      ),
              ),
              controller: codeController,
            ),
            const SizedBox(
              height: 20,
            ),
            if (voucherState.value != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: VoucherCard(
                  voucher: voucherState.value!,
                  onTap: onSubmit,
                  disabled: !voucherState.value!.policy &&
                      ref.watch(cartProvider).promotions.isNotEmpty,
                  disabledReason: 'cannot_use_with_promotion'.tr(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
