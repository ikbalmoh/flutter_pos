class Shift {
  String id;
  String codeShift;
  String outletId;
  String deviceId;
  DateTime startShift;
  DateTime closeShift;
  double openAmount;
  double? closeAmount;
  double? diffAmount;
  double? refundAmount;
  String createdBy;
  String? updatedBy;
  DateTime createdAt;
  DateTime? updatedAt;
  String outletName;
  String deviceName;
  String createdName;
  String? updatedName;
  String? closedBy;
  double? income;
  double? expense;
  double? cashSales;
  double? debitSalesAmount;
  List<dynamic> debitSales;
  double? creditSalesAmount;
  List<dynamic> creditSales;
  int customSalesAmount;
  List<dynamic> customSales;
  int expectedEnd;
  int expectedCash;
  String sold;
  List<SoldItem> soldItems;
  List<dynamic> refundItems;
  List<dynamic> attachments;

  Shift({
    required this.id,
    required this.codeShift,
    required this.outletId,
    required this.deviceId,
    required this.startShift,
    required this.closeShift,
    required this.openAmount,
    required this.closeAmount,
    required this.diffAmount,
    required this.refundAmount,
    required this.createdBy,
    required this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.outletName,
    required this.deviceName,
    required this.createdName,
    required this.updatedName,
    required this.closedBy,
    required this.income,
    required this.expense,
    required this.cashSales,
    required this.debitSalesAmount,
    required this.debitSales,
    required this.creditSalesAmount,
    required this.creditSales,
    required this.customSalesAmount,
    required this.customSales,
    required this.expectedEnd,
    required this.expectedCash,
    required this.sold,
    required this.soldItems,
    required this.refundItems,
    required this.attachments,
  });

}

class SoldItem {
  String idItem;
  String name;
  int sold;

  SoldItem({
    required this.idItem,
    required this.name,
    required this.sold,
  });

}
