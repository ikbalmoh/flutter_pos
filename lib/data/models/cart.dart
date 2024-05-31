import 'package:selleri/data/models/cart_payment.dart';
import 'package:selleri/data/models/item_cart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart.freezed.dart';
part 'cart.g.dart';

@freezed
class Cart with _$Cart {
  @JsonSerializable(fieldRename: FieldRename.snake)
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
    required double totalPayment,
    double? change,
    String? idCustomer,
    String? customerName,
    String? notes,
    String? personInCharge,
    DateTime? holdAt,
    String? createdBy,
    String? createdName,
    required List<ItemCart> items,
    required List<CartPayment> payments,
  }) = _Cart;

  factory Cart.fromJson(Map<String, dynamic> json) => _$CartFromJson(json);

}
