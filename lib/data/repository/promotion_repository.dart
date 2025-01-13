import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:selleri/data/models/promotion.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/data/network/promotion.dart';
import 'package:selleri/data/repository/outlet_repository.dart';

part 'promotion_repository.g.dart';

abstract class PromotionRepositoryProtocol {
  Future<List<Promotion>> fetchPromotions();
  Future<Promotion?> getPromoByCode(String code);
}

@riverpod
PromotionRepository promotionRepository(Ref ref) =>
    PromotionRepository(ref);

class PromotionRepository implements PromotionRepositoryProtocol {
  PromotionRepository(this.ref);

  final Ref ref;

  late final outletState = ref.read(outletRepositoryProvider);

  @override
  Future<List<Promotion>> fetchPromotions() async {
    try {
      final api = ref.watch(promotionApiProvider);
      final outlet = await outletState.retrieveOutlet();
      if (outlet == null) {
        return [];
      }
      final data = await api.promotions(outlet.idOutlet);
      final List<Promotion> promotions = [];
      for (var i = 0; i < List.from(data['data']).length; i++) {
        var json = data['data'][i];
        try {
          final promotion = Promotion.fromJson(json);
          promotions.add(promotion);
        } on Error catch (e, stackTrace) {
          log('LOAD PROMOTION ERROR: $json\n=> $e\n=> $stackTrace');
        }
      }
      return promotions;
    } on DioException catch (e) {
      throw e.message!;
    } on PlatformException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<Promotion?> getPromoByCode(String code) async {
    try {
      final api = ref.watch(promotionApiProvider);
      final outlet = await outletState.retrieveOutlet();
      if (outlet == null) {
        return null;
      }
      final data = await api.promotionByCode(code, outlet.idOutlet);
      if (data['data'] != null) {
        return Promotion.fromJson(data['data']);
      }
      throw Exception('Promotion Not Found!');
    } on DioException catch (e) {
      throw e.message!;
    } on Exception catch (_) {
      rethrow;
    }
  }
}
