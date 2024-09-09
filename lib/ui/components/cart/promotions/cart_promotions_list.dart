import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:selleri/data/models/cart.dart' as cart_model;
import 'package:selleri/data/models/promotion.dart';
import 'package:selleri/providers/cart/cart_provider.dart';
import 'package:selleri/providers/promotion/promotions_provider.dart';
import 'package:selleri/ui/components/cart/promotions/cart_promotion_item.dart';
import 'package:selleri/ui/components/cart/promotions/promotion_code_input.dart';
import 'package:selleri/utils/formater.dart';

class CartPromotionsList extends ConsumerStatefulWidget {
  const CartPromotionsList({super.key});

  @override
  ConsumerState<CartPromotionsList> createState() => _CartPromotionsListState();
}

class _CartPromotionsListState extends ConsumerState<CartPromotionsList> {
  List<Promotion> selected = [];

  final now = DateTime.now().millisecondsSinceEpoch;
  final today =
      DateTimeFormater.dateToString(DateTime.now(), format: 'y-MM-dd');

  @override
  void initState() {
    List<String> ids = ref
        .read(cartProvider)
        .promotions
        .map((promo) => promo.promotionId)
        .toList();

    setState(() {
      selected = ref
          .read(promotionsProvider)
          .where((promo) => ids.contains(promo.idPromotion))
          .toList();
    });
    super.initState();
  }

  void onSelect(Promotion promo) {
    final int idx = selected.indexWhere((p) => p.id == promo.id);
    if (idx >= 0) {
      setState(() {
        selected = selected..removeAt(idx);
      });
    } else {
      setState(() {
        selected = selected..add(promo);
      });
    }
  }

  void onSelectPromoByCode(Promotion promo) {
    final int idx = selected.indexWhere((p) => p.id == promo.id);
    if (idx >= 0) {
      setState(() {
        selected = [];
      });
    } else {
      setState(() {
        selected = [promo];
      });
    }
  }

  bool hasCannotCombinedPromo(int exceptId) {
    return selected.indexWhere((p) => !p.policy && p.id != exceptId) >= 0;
  }

  @override
  Widget build(BuildContext context) {
    List<Promotion> promotions = ref.watch(promotionsProvider);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      height: MediaQuery.of(context).size.height *
          (MediaQuery.of(context).viewInsets.bottom > 0 ? 0.95 : 0.65),
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
              promotions.isEmpty
                  ? 'no_valid_promotions'.tr()
                  : '${promotions.length} ${'promotions_available'.tr()}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  PromotionCodeInput(
                    onSelect: onSelectPromoByCode,
                    active:
                        selected.where((p) => p.needCode == true).isNotEmpty,
                  ),
                  promotions.isNotEmpty
                      ? ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 7.5),
                          shrinkWrap: true,
                          itemBuilder: (context, idx) {
                            Promotion promo = promotions[idx];
                            bool isActive =
                                selected.map((p) => p.id).contains(promo.id);
                            bool isEligible = ref
                                .read(promotionsProvider.notifier)
                                .isPromotionEligible(promo);
                            bool isDisabled = !isEligible ||
                                promo.needCode ||
                                (selected
                                        .where((p) => p.id != promo.id)
                                        .isNotEmpty &&
                                    !promo.policy) ||
                                hasCannotCombinedPromo(promo.id);
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 7.5),
                              child: CartPromotionItem(
                                promo: promo,
                                onSelect: onSelect,
                                active: isActive,
                                disabled: isDisabled,
                              ),
                            );
                          },
                          itemCount: promotions.length,
                        )
                      : Container(
                          margin: const EdgeInsets.only(top: 100),
                          child: Text(
                            'no_valid_promotions'.tr(),
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(color: Colors.grey.shade500),
                          ),
                        )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
            child: Row(
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey.shade700,
                  ),
                  onPressed: () => context.pop(),
                  child: Text(
                    'cancel'.tr(),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                    ),
                    onPressed: () => context.pop(selected),
                    child: Text('apply'.tr()),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
