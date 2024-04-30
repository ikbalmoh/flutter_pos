import 'package:selleri/data/models/item_cart.dart';

class Cart {
  DateTime transactionDate;
  String transactionNo;
  String idOutlet;
  String outletName;
  double? subtotal;
  bool? discIsPercent;
  double? discOverall;
  double? discOverallTotal;
  double? discPromotionsTotal;
  double? total;
  bool? ppnIsInclude;
  double? ppn;
  String? taxName;
  double? ppnTotal;
  double? grandTotal;
  double? totalPayment;
  double? change;
  String? idCustomer;
  String? customerName;
  String? notes;
  String? personInCharge;
  DateTime? holdAt;
  String? createdBy;
  String? createdName;
  List<ItemCart> items;
  List? payments;

  Cart({
    required this.transactionDate,
    required this.transactionNo,
    required this.idOutlet,
    required this.outletName,
    this.subtotal,
    this.discIsPercent,
    this.discOverall,
    this.discOverallTotal,
    this.discPromotionsTotal,
    this.total,
    this.ppnIsInclude,
    this.ppn,
    this.taxName,
    this.ppnTotal,
    this.grandTotal,
    this.totalPayment,
    this.change,
    this.idCustomer,
    this.customerName,
    this.notes,
    this.personInCharge,
    this.holdAt,
    this.createdBy,
    this.createdName,
    required this.items,
    this.payments,
  });

  @override
  String toString() {
    return '{transactionNo: $transactionNo, transactionDate: $transactionDate, createdName: $createdName}';
  }
}
