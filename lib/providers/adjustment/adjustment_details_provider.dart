import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/data/models/item_adjustment.dart';
import 'package:selleri/data/network/adjustment.dart';

part 'adjustment_details_provider.g.dart';

@riverpod
class AdjustmentDetailItems extends _$AdjustmentDetailItems {
  @override
  FutureOr<List<ItemAdjustment>> build(String id) async {
    try {
      final api = AdjustmentApi();
      List<ItemAdjustment> items = await api.adjustmentDetailItems(id: id);
      return items;
    } catch (e) {
      rethrow;
    }
  }
}
