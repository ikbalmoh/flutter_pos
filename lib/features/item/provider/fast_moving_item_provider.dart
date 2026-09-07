// ignore_for_file: avoid_manual_providers_as_generated_provider_dependency
import 'package:selleri/features/item/model/item_adjustment.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/features/adjustment/api/adjustment_api.dart';
import 'package:selleri/features/outlet/provider/outlet_provider.dart';

part 'fast_moving_item_provider.g.dart';

@riverpod
Future<List<ItemAdjustment>> fastMovingItems(Ref ref) async {
  try {
    final outletState = ref.watch(outletProvider).value as OutletSelected;

    final api = ref.watch(adjustmentApiProvider);
    List<ItemAdjustment> items =
        await api.fastMovingItems(idOutlet: outletState.outlet.idOutlet);
    return items;
  } catch (e) {
    rethrow;
  }
}
