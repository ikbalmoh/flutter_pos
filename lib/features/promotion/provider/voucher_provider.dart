import 'dart:developer';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/features/promotion/model/voucher.dart' as model;
import 'package:selleri/features/promotion/repository/promotion_repository.dart';

part 'voucher_provider.g.dart';

@riverpod
class Voucher extends _$Voucher {
  @override
  FutureOr<model.Voucher?> build() {
    return null;
  }

  Future<void> getVoucher(String code) async {
    try {
      state = AsyncValue.loading();
      log('GET VOUCHER: $code');
      final PromotionRepository promotionRepository =
          ref.read(promotionRepositoryProvider);
      model.Voucher voucher = await promotionRepository.getVoucher(code);
      state = AsyncValue.data(voucher);
    } catch (e, stackTrace) {
      log('GET VOUVHER ERROR $e');
      state = AsyncValue.error(e, stackTrace);
    }
  }

  void clearError() {
    if (state.hasError) {
      state = const AsyncValue.data(null);
    }
  }
}
