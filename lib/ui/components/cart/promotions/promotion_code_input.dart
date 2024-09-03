import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/data/models/promotion.dart';
import 'package:selleri/providers/promotion/promotions_provider.dart';
import 'dart:developer';

import 'package:selleri/ui/components/cart/promotions/cart_promotion_item.dart';

class PromotionCodeInput extends ConsumerStatefulWidget {
  const PromotionCodeInput({required this.onSelect, this.active, super.key});

  final Function(Promotion) onSelect;
  final bool? active;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PromotionCodeInputState();
}

class _PromotionCodeInputState extends ConsumerState<PromotionCodeInput> {
  final formKey = GlobalKey<FormState>();
  final controller = TextEditingController();

  bool isLoading = false;
  String? validation;
  Promotion? promotion;

  bool isPromotionEligible(Promotion? promo) {
    return ref.read(promotionsProvider.notifier).isPromotionEligible(promo);
  }

  void onSubmit(String code) async {
    setState(() {
      validation = null;
      isLoading = false;
      promotion = null;
    });
    if (controller.text.isEmpty) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    try {
      Promotion? promo = await ref
          .read(promotionsProvider.notifier)
          .getPromotionByCode(controller.text);
      setState(() {
        isLoading = false;
        promotion = promo;
      });
      if (isPromotionEligible(promo)) {
        widget.onSelect(promo!);
      }
    } on Exception catch (e) {
      log('PROMO CODE ERROR: $e');
      setState(() {
        validation = e.toString().replaceAll('Exception:', '');
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Colors.grey.shade200,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Form(
            key: formKey,
            child: Stack(
              children: [
                TextFormField(
                  controller: controller,
                  onFieldSubmitted: onSubmit,
                  validator: (value) => validation,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    label: Text(
                      'add_promotion_code'.tr(),
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.blueGrey.shade600),
                    ),
                    alignLabelWithHint: true,
                    filled: true,
                    fillColor: isLoading ? Colors.grey.shade100 : Colors.white,
                    contentPadding: const EdgeInsets.all(10),
                    focusColor: Colors.teal,
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: promotion == null
                          ? Colors.grey.shade200
                          : Colors.green.shade500,
                      width: 1,
                    )),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Colors.teal,
                      width: 1,
                    )),
                    focusedErrorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Colors.red,
                      width: 1,
                    )),
                    errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Colors.red,
                      width: 1,
                    )),
                  ),
                ),
                Positioned(
                  right: 15,
                  top: 12,
                  child: isLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 1,
                            color: Colors.grey,
                          ),
                        )
                      : promotion != null
                          ? const Icon(
                              CupertinoIcons.checkmark_circle_fill,
                              color: Colors.green,
                            )
                          : Container(),
                )
              ],
            ),
          ),
          promotion != null
              ? Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: CartPromotionItem(
                    promo: promotion!,
                    onSelect: widget.onSelect,
                    active: widget.active == true,
                    disabled: !isPromotionEligible(promotion),
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
