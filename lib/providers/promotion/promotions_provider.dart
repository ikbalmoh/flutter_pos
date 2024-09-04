import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/data/models/promotion.dart';
import 'package:selleri/data/objectbox.dart';
import 'package:selleri/data/repository/promotion_repository.dart';
import 'package:selleri/data/models/cart.dart' as model;
import 'package:selleri/providers/cart/cart_provider.dart';
import 'package:selleri/utils/formater.dart';

part 'promotions_provider.g.dart';

@Riverpod(keepAlive: true)
class Promotions extends _$Promotions {
  @override
  List<Promotion> build() {
    model.Cart cart = ref.watch(cartProvider);
    return objectBox.transactionPromotions(cart: cart);
  }

  Future<List<Promotion>> loadPromotions() async {
    log('Load Promotions');
    final PromotionRepository promotionRepository =
        ref.read(promotionRepositoryProvider);

    final promotions = await promotionRepository.fetchPromotions();
    objectBox.putPromotions(promotions);
    return promotions;
  }

  Future<Promotion?> getPromotionByOrder(
      {double? requirementMinimumOrder}) async {
    log('GET PROMOTION BY ORDER');
    List<Promotion> result = await objectBox
        .promotionsStream(
          type: 2,
          active: true,
          requirementMinimumOrder: requirementMinimumOrder,
          needCode: false,
        )
        .first;
    return result.isNotEmpty ? result.first : null;
  }

  Future<Promotion?> getPromotionByCode(String code) async {
    try {
      log('GET PROMOTION BY CODE: $code');
      final PromotionRepository promotionRepository =
          ref.read(promotionRepositoryProvider);
      Promotion? promo = await promotionRepository.getPromoByCode(code);
      return promo;
    } catch (_) {
      rethrow;
    }
  }

  bool isPromotionEligible(Promotion? promo) {
    if (promo == null) {
      return false;
    }
    // Disabled A get B
    if (promo.type == 1) {
      return false;
    }
    // Check days
    if (promo.days != null && promo.days!.isNotEmpty) {
      if (!promo.days!
          .contains(DateFormat('EEEE').format(DateTime.now()).toLowerCase())) {
        return false;
      }
    }
    // Check date
    if (promo.allTime) {
      int timestamp = DateTime.now().millisecondsSinceEpoch;
      bool starDatePassed = promo.startDate != null
          ? DateTimeFormater.stringToTimestamp(promo.startDate!) <= timestamp
          : true;
      bool endDatePassed = promo.endDate != null
          ? DateTimeFormater.stringToTimestamp(promo.endDate!) >= timestamp
          : true;
      if (!starDatePassed || !endDatePassed) {
        return false;
      }
    }

    model.Cart cart = ref.read(cartProvider);

    if (promo.assignCustomer == 2) {
      return cart.idCustomer != null;
    } else if (promo.assignCustomer == 3) {
      return cart.idCustomer == null;
    } else if (promo.assignCustomer == 4) {
      final promoGroup =
          promo.assignGroups.map((group) => group.groupId).toList();
      return cart.customerGroup != null
          ? cart.customerGroup!
                  .indexWhere((g) => promoGroup.contains(g.groupId)) >=
              0
          : false;
    }

    List<String> itemIds = cart.items.map((item) => item.idItem).toList();
    List<String> categoryIds =
        cart.items.map((item) => item.idCategory!).toList();
    List<String> variantIds = cart.items
        .where((item) => item.idVariant != null)
        .map((item) => item.idVariant!.toString())
        .toList();

    // Promo by order
    if (promo.type == 2) {
      return promo.requirementMinimumOrder == null
          ? true
          : promo.requirementMinimumOrder! <= cart.subtotal;
    } else if (promo.type == 3) {
      if (cart.items.isNotEmpty) {
        switch (promo.requirementProductType) {
          case 1:
            return promo.requirementProductId
                    .indexWhere((id) => itemIds.contains(id)) >=
                0;

          case 2:
            return promo.requirementProductId
                    .indexWhere((id) => variantIds.contains(id)) >=
                0;

          default:
            return promo.requirementProductId
                    .indexWhere((id) => categoryIds.contains(id)) >=
                0;
        }
      }
      return false;
    }

    return true;
  }
}
