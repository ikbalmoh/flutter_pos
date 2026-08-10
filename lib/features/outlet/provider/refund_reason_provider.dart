import 'dart:developer';

import 'package:selleri/features/outlet/model/refund_reason.dart' as model;
import 'package:selleri/features/outlet/repository/outlet_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'refund_reason_provider.g.dart';

@Riverpod(keepAlive: true)
class RefundReason extends _$RefundReason {
  late final OutletRepository _outletRepository = ref.read(
    outletRepositoryProvider,
  );

  @override
  Future<List<model.RefundReason>> build() async {
    try {
      final reasons = await _outletRepository.refundReasons();
      log('loaded refund reasons: $reasons');
      return reasons;
    } catch (e) {
      log('fetch refund reason failed $e');
      return [];
    }
  }
}
