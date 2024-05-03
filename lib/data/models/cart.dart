import 'package:selleri/data/models/item_cart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart.freezed.dart';

@freezed
class Cart with _$Cart {
  const factory Cart({
    required DateTime transactionDate,
    String? transactionNo,
    String? idOutlet,
    String? outletName,
    required double subtotal,
    required bool discIsPercent,
    required double discOverall,
    required double discOverallTotal,
    required double discPromotionsTotal,
    required double total,
    bool? ppnIsInclude,
    double? ppn,
    String? taxName,
    double? ppnTotal,
    required double grandTotal,
    double? totalPayment,
    double? change,
    String? idCustomer,
    String? customerName,
    String? notes,
    String? personInCharge,
    DateTime? holdAt,
    String? createdBy,
    String? createdName,
    required List<ItemCart> items,
    List? payments,
  }) = _Cart;
}
