// ignore_for_file: avoid_manual_providers_as_generated_provider_dependency
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/data/models/receiving/purchase_info.dart' as model;
import 'package:selleri/data/network/receiving.dart';
import 'package:selleri/providers/outlet/outlet_provider.dart';
import 'package:selleri/providers/receiving/receiving_provider.dart';

part 'purchase_info_provider.g.dart';

@riverpod
class PurchaseInfo extends _$PurchaseInfo {
  @override
  FutureOr<model.PurchaseInfo> build() async {
    return const model.PurchaseInfo(
      refNumber: '',
      refFrom: '',
      items: [],
    );
  }

  Future<void> loadInfo({required String search, required int type}) async {
    state = const AsyncLoading();
    try {
      final outletState = ref.watch(outletProvider).value as OutletSelected;

      final api = ref.watch(receivingApiProvider);
      model.PurchaseInfo info = await api.purchaseInfo(search,
          idOutlet: outletState.outlet.idOutlet, type: type);

      state = AsyncData(info);

      ref.read(receivingProvider.notifier).setInfo(info, type: type);
    } on DioException catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  void receiveItem(String itemId, {required int qtyReceive, int? variantId}) {
    final item = state.value!.items
        .firstWhere((i) => i.itemId == itemId && i.variantId == variantId);
    final newItem = item.copyWith(qtyReceive: qtyReceive);
    final newItems = state.value!.items.map((i) {
      if (i.itemId == itemId && i.variantId == variantId) {
        return newItem;
      }
      return i;
    }).toList();
    state = AsyncData(state.value!.copyWith(items: newItems));
  }

  void resetReceiveItem() {
    final newItems = state.value!.items.map((i) {
      return i.copyWith(qtyReceive: 0);
    }).toList();
    state = AsyncData(state.value!.copyWith(items: newItems));
  }

  void reset() {
    state = const AsyncData(model.PurchaseInfo(
      refNumber: '',
      refFrom: '',
      items: [],
    ));
    ref.read(receivingProvider.notifier).reset();
  }
}
