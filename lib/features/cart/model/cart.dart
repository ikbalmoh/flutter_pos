import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:selleri/features/cart/model/cart_holded.dart';
import 'package:selleri/features/cart/model/cart_payment.dart';
import 'package:selleri/features/cart/model/cart_promotion.dart';
import 'package:selleri/features/cart/model/cart_voucher.dart';
import 'package:selleri/features/customer/model/customer_vehicle.dart';
import 'package:selleri/shared/utils/model_converter.dart';
import 'package:selleri/features/customer/model/customer_group.dart';
import 'package:selleri/features/item/model/item_cart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:selleri/shared/utils/formater.dart';

part 'cart.freezed.dart';
part 'cart.g.dart';

@freezed
class Cart with _$Cart {
  const Cart._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Cart({
    @JsonKey(
      fromJson: DateTimeFormater.stringToTimestamp,
      toJson: DateTimeFormater.unixServer,
    )
    required int transactionDate,
    required String transactionNo,
    required String idOutlet,
    String? outletName,
    String? idTransaction,
    required String shiftId,
    @JsonKey(fromJson: ModelConverter.dynamicToDouble) required double subtotal,
    @JsonKey(fromJson: ModelConverter.dynamicToBool)
    required bool discIsPercent,
    @JsonKey(fromJson: ModelConverter.dynamicToDouble)
    required double discOverall,
    @JsonKey(fromJson: ModelConverter.dynamicToDouble)
    required double discOverallTotal,
    @JsonKey(fromJson: ModelConverter.dynamicToDouble)
    required double discPromotionsTotal,
    @JsonKey(fromJson: ModelConverter.dynamicToDouble) required double total,
    @JsonKey(fromJson: ModelConverter.dynamicToBool) required bool ppnIsInclude,
    @JsonKey(fromJson: ModelConverter.dynamicToDouble) required double ppn,
    String? taxName,
    @JsonKey(fromJson: ModelConverter.dynamicToDouble) required double ppnTotal,
    @JsonKey(fromJson: ModelConverter.dynamicToDouble)
    @JsonKey(fromJson: ModelConverter.dynamicToDouble)
    required double roundingValue,
    @JsonKey(fromJson: ModelConverter.dynamicToDouble)
    required double grandTotal,
    @JsonKey(fromJson: ModelConverter.dynamicToDouble)
    required double totalPayment,
    @JsonKey(fromJson: ModelConverter.dynamicToDouble) required double change,
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
    required List<CartPromotion> promotions,
    required List<CartVoucher> vouchers,
    List<String>? tables,
    @JsonKey(fromJson: ModelConverter.dynamicToBool) required bool isApp,
    DateTime? deletedAt,
    String? deletedBy,
    String? deleteReason,
    String? promoCode,
    @JsonKey(includeFromJson: false, includeToJson: false) List<XFile>? images,
    List<CustomerGroup>? customerGroup,
    CustomerVehicle? vehicle,
  }) = _Cart;

  factory Cart.initial() => Cart(
        transactionNo: '',
        transactionDate: DateTime.now().millisecondsSinceEpoch,
        items: [],
        subtotal: 0,
        roundingValue: 0,
        total: 0,
        grandTotal: 0,
        discIsPercent: true,
        discOverall: 0,
        discOverallTotal: 0,
        discPromotionsTotal: 0,
        payments: [],
        promotions: [],
        vouchers: [],
        tables: [],
        totalPayment: 0,
        ppnIsInclude: true,
        ppn: 0,
        ppnTotal: 0,
        change: 0,
        idOutlet: '', // define on initCart
        outletName: '', // define on initCart
        shiftId: '', // define on initCart
        createdBy: '', // define on initCart
        isApp: true,
      );

  factory Cart.fromJson(Map<String, dynamic> json) => _$CartFromJson(json);

  factory Cart.fromDataHold(String dataString) {
    Map<String, dynamic> data = json.decode(dataString);
    data['transaction_date'] =
        DateTimeFormater.stringToTimestamp(data['transaction_date']);
    for (var item in data['items']) {
      List<Map<String, dynamic>> details = item['details'] != null
          ? List<Map<String, dynamic>>.from(item['details'])
          : [];
      item['identifier'] = item['id_item'];
      item['vehicle'] =
          item['vehicle'] != null ? CartHolded.fromJson(item['vehicle']) : null;
      item['is_package'] = details.isNotEmpty;
      item['details'] = details.map((detail) {
        return {
          "item_id": detail["item_id"] ?? "",
          "name": detail["name"] ?? detail["item_name"] ?? "",
          "variant_id": detail["variant_id"],
          "quantity": detail["quantity"] ?? detail["quantity_item"] ?? 0,
          "item_price": detail["item_price"] ?? 0,
        };
      }).toList();
    }
    data['promotions'] = data['promotions'] ?? [];
    data['vouchers'] = data['vouchers'] ?? [];
    return Cart.fromJson(data);
  }

  factory Cart.fromTransaction(Map<String, dynamic> json) {
    json['transcaction_id'] = json['id_transaction'];
    json['transaction_date'] =
        DateTimeFormater.stringToTimestamp(json['transaction_date']);
    for (var item in json['items']) {
      item['item_name'] = item['name'];
    }
    return Cart.fromJson(json);
  }

  Future<Map<String, dynamic>> toTransactionPayload() async {
    List<MultipartFile> dataImages = [];
    if (images != null && images!.isNotEmpty) {
      for (var i = 0; i < images!.length; i++) {
        final img = await MultipartFile.fromFile(images![i].path,
            filename: images![i].name);
        dataImages.add(img);
      }
    }
    final jsonData = <String, dynamic>{
      "id_transaction": idTransaction,
      "id_outlet": idOutlet,
      "shift_id": shiftId,
      "transaction_date": DateTimeFormater.unixServer(transactionDate),
      "transaction_no": transactionNo,
      "id_customer": idCustomer ?? '',
      "subtotal": subtotal,
      "disc_is_percent": discIsPercent ? 1 : 0,
      "disc_overall": discOverall,
      "disc_overall_total": discOverallTotal,
      "disc_promotions_total": discPromotionsTotal,
      "total": total,
      "ppn_is_include": ppnIsInclude == true ? 1 : 0,
      "ppn": ppn,
      "ppn_total": ppnTotal,
      "grand_total": grandTotal,
      "rounding_value": roundingValue,
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
      "vouchers": List<Map<String, dynamic>>.from(
        vouchers.map(
          (voucher) => {
            'code': voucher.code,
            'value': voucher.value,
            'type': voucher.voucherType
          },
        ),
      ),
      "refunds": [],
      "promotions": List<Map<String, dynamic>>.from(
        promotions.map(
          (promo) => promo.toTransactionPayload(),
        ),
      ),
      "created_by": createdBy,
      "images": dataImages,
      "person_in_charge": personInCharge,
      "tables": tables,
      "vehicle_id": vehicle?.idVehicle,
    };
    if (deletedAt != null) {
      jsonData['deleted_at'] = DateTimeFormater.dateToString(deletedAt!);
      jsonData['deleted_by'] = deletedBy;
      jsonData['delete_reason'] = deleteReason;
    }
    return jsonData;
  }

  Future<FormData> toTransactionFormData() async {
    final transactionJson = await toTransactionPayload();
    return FormData.fromMap(
      {
        "transactions": [transactionJson]
      },
      ListFormat.multiCompatible,
    );
  }

  List<CartPayment> prevPayments() =>
      payments.where((p) => p.createdAt != null).toList();

  double totalCurrentPayment() {
    List<CartPayment> currentPayment =
        payments.where((p) => p.createdAt == null).toList();

    double totalMoneyPayment = currentPayment.isNotEmpty
        ? currentPayment
            .map((payment) => payment.paymentValue)
            .reduce((payment, total) => payment + total)
        : 0;

    return totalMoneyPayment;
  }
}
