import 'dart:convert';

import 'package:selleri/data/models/cart_payment.dart';
import 'package:selleri/data/models/converters/generic.dart';
import 'package:selleri/data/models/item_cart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:selleri/utils/formater.dart';

part 'cart.freezed.dart';
part 'cart.g.dart';

@freezed
class Cart with _$Cart {
  const Cart._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Cart({
    @JsonKey(fromJson: DateTimeFormater.stringToTimestamp)
    required int transactionDate,
    required String transactionNo,
    required String idOutlet,
    String? outletName,
    String? transcactionId,
    required String shiftId,
    required double subtotal,
    @JsonKey(fromJson: Converters.dynamicToBool) required bool discIsPercent,
    required double discOverall,
    required double discOverallTotal,
    required double discPromotionsTotal,
    required double total,
    @JsonKey(fromJson: Converters.dynamicToBool) required bool ppnIsInclude,
    required double ppn,
    String? taxName,
    @JsonKey(fromJson: Converters.dynamicToDouble) required double ppnTotal,
    required double grandTotal,
    required double totalPayment,
    required double change,
    String? idCustomer,
    String? customerName,
    String? notes,
    String? description,
    String? personInCharge,
    DateTime? holdAt,
    required String createdBy,
    String? createdName,
    required List<ItemCart> items,
    required List<CartPayment> payments,
    @JsonKey(fromJson: Converters.dynamicToBool) required bool isApp,
  }) = _Cart;

  factory Cart.fromJson(Map<String, dynamic> json) => _$CartFromJson(json);

  factory Cart.fromDataHold(String dataString) {
    Map<String, dynamic> data = json.decode(dataString);
    data['transaction_date'] =
        DateTimeFormater.stringToTimestamp(data['transaction_date']);
    for (var item in data['items']) {
      item['identifier'] = item['id_item'];
    }
    return Cart.fromJson(data);
  }

  factory Cart.fromTransaction(Map<String, dynamic> json) {
    json['transaction_date'] =
        DateTimeFormater.stringToTimestamp(json['transaction_date']);
    for (var item in json['items']) {
      item['item_name'] = item['name'];
    }
    return Cart.fromJson(json);
  }

  Map<String, dynamic> toTransactionPayload() => <String, dynamic>{
        "id_outlet": idOutlet,
        "shift_id": shiftId,
        "created_by": createdBy,
        "transaction_date": transactionDate,
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
