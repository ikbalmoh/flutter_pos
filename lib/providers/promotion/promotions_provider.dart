import 'dart:developer';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/data/models/promotion.dart';
import 'package:selleri/data/objectbox.dart';
import 'package:selleri/data/repository/promotion_repository.dart';
import 'package:selleri/data/models/cart.dart' as model;
import 'package:selleri/providers/cart/cart_provider.dart';

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
}
