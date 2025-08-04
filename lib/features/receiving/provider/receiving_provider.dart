// ignore_for_file: avoid_manual_providers_as_generated_provider_dependency
import 'package:collection/collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/features/receiving/model/purchase_info.dart' as model;
import 'package:selleri/features/receiving/model/purchase_item.dart';
import 'package:selleri/features/receiving/model/receiving_form.dart';
import 'package:selleri/features/receiving/model/receiving_item.dart';
import 'package:selleri/features/receiving/api/receiving_api.dart';
import 'package:selleri/features/notification/provider/notification_provider.dart';
import 'package:selleri/features/outlet/provider/outlet_provider.dart';
import 'package:selleri/features/receiving/provider/purchase_info_provider.dart';

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

  double itemQtyReceived(String idItem, {int? variantId}) {
    double? receiveQty = state.items
        .firstWhereOrNull((i) => i.itemId == idItem && i.variantId == variantId)
        ?.qtyReceive;
    return receiveQty ?? 0;
  }

  void receiveItem(PurchaseItem item, {required double qtyReceive}) {
    int existItemIndex = state.items.indexWhere(
        (i) => i.itemId == item.itemId && i.variantId == item.variantId);
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
      final receiveItem =
          ReceivingItem.fromPurchaseItem(item).copyWith(qtyReceive: qtyReceive);
      state = state.copyWith(
        items: [...state.items, receiveItem],
      );
    }
  }

  void removeItem(String idItem, {int? variantId}) {
    state = state.copyWith(
      items: state.items
          .where((i) => !(i.itemId == idItem && i.variantId == variantId))
          .toList(),
    );
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
      await ref.read(notificationProvider.notifier).loadNotifications();
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
