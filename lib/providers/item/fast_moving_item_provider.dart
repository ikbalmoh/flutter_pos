import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/data/models/item_adjustment.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/data/network/adjustment.dart';
import 'package:selleri/providers/outlet/outlet_provider.dart';

part 'fast_moving_item_provider.g.dart';

@riverpod
Future<List<ItemAdjustment>> fastMovingItems(Ref ref) async {
  try {
    final outletState = ref.watch(outletProvider).value as OutletSelected;

    final api = AdjustmentApi();
    List<ItemAdjustment> items =
        await api.fastMovingItems(idOutlet: outletState.outlet.idOutlet);
    return items;
  } catch (e) {
    rethrow;
  }
}
