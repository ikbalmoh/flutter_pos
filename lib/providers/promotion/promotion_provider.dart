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

  Future<void> loadPromotions() async {
    log('Load Promotions');
    final PromotionRepository promotionRepository =
        ref.read(promotionRepositoryProvider);

    final promotions = await promotionRepository.fetchPromotions();
    objectBox.putPromotions(promotions);
  }
}
