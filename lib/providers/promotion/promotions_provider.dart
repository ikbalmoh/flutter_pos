import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/data/models/item_cart.dart';
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

    if (!promo.status) {
      return false;
    }

    final now = DateTime.now().millisecondsSinceEpoch;
    final today =
        DateTimeFormater.dateToString(DateTime.now(), format: 'y-MM-dd');

    // Check days
    if (promo.days != null && promo.days!.isNotEmpty) {
      if (!promo.days!
          .contains(DateFormat('EEEE').format(DateTime.now()).toLowerCase())) {
        return false;
      }
    }
    // Check date
    if (!promo.allTime) {
      int now = DateTime.now().millisecondsSinceEpoch;
      int start = promo.startDate!.millisecondsSinceEpoch;
      DateTime endDate = DateTime(promo.endDate!.year, promo.endDate!.month,
          promo.endDate!.day + 1, 0, 0, -1);
      int end = endDate.millisecondsSinceEpoch;

      bool dateIsValid = now >= start && now <= end;

      if (!dateIsValid) {
        return false;
      }
    }

    bool isTimeEligible = promo.times == null || promo.times!.isEmpty;
    if (promo.times != null && promo.times!.isNotEmpty) {
      for (var i = 0; i < promo.times!.length; i++) {
        List<String> times = promo.times![i].split('-');
        int? start = DateTimeFormater.stringToDateTime('$today ${times[0]}:00')
            ?.millisecondsSinceEpoch;
        int? end = DateTimeFormater.stringToDateTime('$today ${times[1]}:00')
            ?.millisecondsSinceEpoch;
        if (start != null && end != null) {
          if (start <= now && now <= end) {
            isTimeEligible = true;
            break;
          }
        }
      }
    }

    if (!isTimeEligible) {
      return false;
    }

    model.Cart cart = ref.read(cartProvider);

    if (promo.assignCustomer == 2) {
      if (cart.idCustomer == null) {
        return false;
      }
    } else if (promo.assignCustomer == 3) {
      if (cart.idCustomer != null) {
        return false;
      }
    } else if (promo.assignCustomer == 4) {
      final promoGroup =
          promo.assignGroups.map((group) => group.groupId).toList();
      bool hasPromoGroup = cart.customerGroup == null
          ? false
          : cart.customerGroup!
                  .indexWhere((g) => promoGroup.contains(g.groupId)) >=
              0;
      if (!hasPromoGroup) {
        return false;
      }
    }

    // Promo by order
    if (promo.type == 2) {
      return promo.requirementMinimumOrder == null
          ? true
          : promo.requirementMinimumOrder! <= cart.subtotal;
    } else if (cart.items.isNotEmpty) {
      List<ItemCart> eligibleItems = [];
      switch (promo.requirementProductType) {
        case 1:
          eligibleItems = cart.items
              .where((item) =>
                  promo.requirementProductId.contains(item.idItem) &&
                  item.quantity >= promo.requirementQuantity!)
              .toList();
          break;

        case 2:
          eligibleItems = cart.items
              .where((item) =>
                  promo.requirementProductId.contains(item.idVariant) &&
                  item.quantity >= promo.requirementQuantity!)
              .toList();
          break;

        default:
          eligibleItems = cart.items
              .where((item) =>
                  promo.requirementProductId.contains(item.idCategory) &&
                  item.quantity >= promo.requirementQuantity!)
              .toList();
          break;
      }

      log('ELIGIBLE ITEMS FOR PROMOR 1 & 3: $eligibleItems');

      if (eligibleItems.isEmpty) {
        return false;
      }
    } else {
      return false;
    }

    return true;
  }

  List<ItemCart> eligibleItems(Promotion promo, List<ItemCart> items) {
    List<ItemCart> eligibleItems = [];

    if (promo.requirementProductType == 1) {
      // require product id
      eligibleItems = items
          .where((item) =>
              (item.idVariant != null && promo.requirementVariantId.isNotEmpty
                  ? promo.requirementVariantId
                      .contains(item.idVariant.toString())
                  : promo.requirementProductId.contains(item.idItem)) &&
              item.quantity >= promo.requirementQuantity!.toInt())
          .toList();
    } else if (promo.requirementProductType == 2) {
      // require package id
      eligibleItems = items
          .where((item) =>
              promo.requirementProductId.contains(item.idItem) &&
              item.quantity >= promo.requirementQuantity!.toInt())
          .toList();
    } else if (promo.requirementProductType == 3) {
      // require category id
      eligibleItems = items
          .where((item) =>
              promo.requirementProductId.contains(item.idCategory) &&
              item.quantity >= promo.requirementQuantity!.toInt())
          .toList();
    }
    return eligibleItems;
  }
}
