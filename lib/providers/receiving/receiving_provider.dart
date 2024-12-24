// ignore_for_file: avoid_manual_providers_as_generated_provider_dependency
import 'package:collection/collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/data/models/receiving/purchase_info.dart' as model;
import 'package:selleri/data/models/receiving/purchase_item.dart';
import 'package:selleri/data/models/receiving/receiving_form.dart';
import 'package:selleri/data/models/receiving/receiving_item.dart';
import 'package:selleri/data/network/receiving.dart';
import 'package:selleri/providers/outlet/outlet_provider.dart';
import 'package:selleri/providers/receiving/purchase_info_provider.dart';

part 'receiving_provider.g.dart';

@riverpod
class Receiving extends _$Receiving {
  @override
  ReceivingForm build() {
    final outlet = ref.watch(outletProvider).value as OutletSelected;
    return ReceivingForm.initial().copyWith(outletId: outlet.outlet.idOutlet);
  }

  void setInfo(model.PurchaseInfo info, {required int type}) {
    state = state.copyWith(
      type: type,
      refNumber: info.refNumber,
      refFrom: info.refFrom,
      externalReference: '',
      description: '',
      items: [],
    );
  }

  int itemQtyReceived(String idItem) {
    int? receiveQty =
        state.items.firstWhereOrNull((i) => i.itemId == idItem)?.qtyReceive;
    return receiveQty ?? 0;
  }

  void receiveItem(PurchaseItem item, {required int qtyReceive}) {
    int existItemIndex = state.items.indexWhere((i) => i.itemId == item.itemId);
    if (existItemIndex >= 0) {
      final receiveItem = state.items[existItemIndex].copyWith(
        qtyReceive: qtyReceive,
      );
      state = state.copyWith(
        items: [
          ...state.items.sublist(0, existItemIndex),
          receiveItem,
          ...state.items.sublist(existItemIndex + 1),
        ],
      );
    } else {
      final receiveItem = ReceivingItem.fromPurchaseItem(item).copyWith(
        qtyReceive: qtyReceive,
      );
      state = state.copyWith(
        items: [...state.items, receiveItem],
      );
    }
    ref
        .read(purchaseInfoProvider.notifier)
        .receiveItem(item.itemId, qtyReceive);
  }

  void removeItem(String idItem) {
    state = state.copyWith(
      items: state.items.where((i) => i.itemId != idItem).toList(),
    );
    ref.read(purchaseInfoProvider.notifier).receiveItem(idItem, 0);
  }

  void setDate(DateTime date) {
    state = state.copyWith(receiveDate: date);
  }

  Future<String> submit({required String description}) async {
    try {
      ReceivingForm form = state.copyWith(description: description);
      final api = ref.watch(receivingApiProvider);
      String message = await api.submit(form);
      ref.read(purchaseInfoProvider.notifier).reset();
      return message;
    } catch (e) {
      rethrow;
    }
  }

  void reset() {
    final outlet = ref.watch(outletProvider).value as OutletSelected;
    state = ReceivingForm.initial().copyWith(outletId: outlet.outlet.idOutlet);
    ref.read(purchaseInfoProvider.notifier).resetReceiveItem();
  }
}
