class ItemCart {
  final String idItem;
  final String itemName;
  final bool isPackage;
  final bool isManualPrice;
  double price;
  bool manualDiscount;
  int quantity;
  double discount;
  bool discountIsPercent;
  double discountTotal;
  String note;
  DateTime addedAt;
  double total;

  ItemCart({
    required this.idItem,
    required this.itemName,
    required this.price,
    required this.isPackage,
    required this.manualDiscount,
    required this.isManualPrice,
    required this.quantity,
    required this.discount,
    required this.discountIsPercent,
    required this.discountTotal,
    required this.note,
    required this.addedAt,
    required this.total,
  });
}
