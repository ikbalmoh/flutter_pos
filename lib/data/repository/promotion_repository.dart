import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:selleri/data/models/promotion.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/data/models/voucher.dart';
import 'package:selleri/data/network/promotion.dart';
import 'package:selleri/providers/outlet/outlet_provider.dart';

part 'promotion_repository.g.dart';

abstract class PromotionRepositoryProtocol {
  Future<List<Promotion>> fetchPromotions();
  Future<Promotion?> getPromoByCode(String code);
  Future<Voucher?> getVoucher(String code);
}

@riverpod
PromotionRepository promotionRepository(Ref ref) => PromotionRepository(ref);

class PromotionRepository implements PromotionRepositoryProtocol {
  PromotionRepository(this.ref);

  final Ref ref;
  late final outletState = ref.watch(outletProvider).value;

  @override
  Future<List<Promotion>> fetchPromotions() async {
    try {
      final api = ref.watch(promotionApiProvider);
      if (outletState is! OutletSelected) {
        return [];
      }
      final outlet = (outletState as OutletSelected).outlet;
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
      if (outletState is! OutletSelected) {
        return null;
      }
      final outlet = (outletState as OutletSelected).outlet;
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

  @override
  Future<Voucher> getVoucher(String code) async {
    try {
      final api = ref.watch(promotionApiProvider);

      if (outletState is! OutletSelected) {
        throw Exception('Outlet Not Active!');
      }
      final outlet = (outletState as OutletSelected).outlet;

      final data = await api.getVoucher(code, outlet.idOutlet);
      if (data['data'] != null) {
        return Voucher.fromJson(data['data']);
      }
      throw Exception('Voucher Not Found!');
    } on DioException catch (e) {
      throw e.message!;
    } on Exception catch (_) {
      rethrow;
    }
  }
}
