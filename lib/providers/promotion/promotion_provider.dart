import 'dart:developer';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/data/models/promotion.dart';
import 'package:selleri/data/objectbox.dart';
import 'package:selleri/data/repository/promotion_repository.dart';

part 'promotion_provider.g.dart';

@Riverpod(keepAlive: true)
class PromotionStream extends _$PromotionStream {
  @override
  Stream<List<Promotion>> build() {
    return objectBox.promotionsStream();
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
