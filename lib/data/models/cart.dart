import 'package:selleri/data/models/cart_payment.dart';
import 'package:selleri/data/models/converters/generic.dart';
import 'package:selleri/data/models/item_cart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart.freezed.dart';
part 'cart.g.dart';

@freezed
class Cart with _$Cart {
  const Cart._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Cart({
    required DateTime transactionDate,
    required String transactionNo,
    required String idOutlet,
    required String outletName,
    required String shiftId,
    required double subtotal,
    @JsonKey(fromJson: Converters.dynamicToBool)
    required bool discIsPercent,
    required double discOverall,
    required double discOverallTotal,
    required double discPromotionsTotal,
    required double total,
    required bool ppnIsInclude,
    required double ppn,
    String? taxName,
    required double ppnTotal,
    required double grandTotal,
    required double totalPayment,
    required double change,
    String? idCustomer,
    String? customerName,
    String? notes,
    String? personInCharge,
    DateTime? holdAt,
    required String createdBy,
    String? createdName,
    required List<ItemCart> items,
    required List<CartPayment> payments,
  }) = _Cart;

  factory Cart.fromJson(Map<String, dynamic> json) => _$CartFromJson(json);

  Map<String, dynamic> toTransactionPayload() => <String, dynamic>{
        "id_outlet": idOutlet,
        "shift_id": shiftId,
        "created_by": createdBy,
        "transaction_date": (transactionDate.millisecondsSinceEpoch / 1000).floor(),
        "transaction_no": transactionNo,
        "id_customer": idCustomer ?? '',
        "subtotal": subtotal,
        "disc_is_percent": discIsPercent ? 1 : 0,
        "disc_overall": discOverall,
        "disc_overall_total": discOverallTotal,
        "disc_promotions_total": 0,
        "total": total,
        "ppn_is_include": ppnIsInclude == true ? 1 : 0,
        "ppn": ppn,
        "ppn_total": ppnTotal,
        "grand_total": grandTotal,
        "rounding_value": 0,
        "notes": notes ?? '',
        "total_payment": totalPayment,
        "change": change,
        "items": List<Map<String, dynamic>>.from(
          items.map(
            (item) => item.toTransactionPayload(),
          ),
        ),
        "payments": List<Map<String, dynamic>>.from(
          payments.map(
            (payment) => payment.toJson(),
          ),
        ),
        "vouchers": [],
        "refunds": [],
        "promotions": []
      };
}
