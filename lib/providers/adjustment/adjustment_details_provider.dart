// ignore_for_file: avoid_manual_providers_as_generated_provider_dependency
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/data/models/item_adjustment.dart';
import 'package:selleri/data/network/adjustment.dart';

part 'adjustment_details_provider.g.dart';

@riverpod
class AdjustmentDetailItems extends _$AdjustmentDetailItems {
  @override
  FutureOr<List<ItemAdjustment>> build({
    required String id,
    bool? isCopy,
  }) async {
    return items(id: id);
  }

  FutureOr<List<ItemAdjustment>> items({
    required String id,
    bool? isCopy,
  }) async {
    try {
      final api = ref.watch(adjustmentApiProvider);
      List<ItemAdjustment> items =
          await api.adjustmentDetailItems(id: id, isCopy: isCopy);
      return items;
    } catch (e) {
      rethrow;
    }
  }
}
