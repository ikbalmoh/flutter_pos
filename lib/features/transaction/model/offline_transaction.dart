import 'package:objectbox/objectbox.dart';

@Entity()
class OfflineTransaction {
  int id;
  String transactionNo;
  String shiftId;
  String transaction;

  OfflineTransaction({
    this.id = 0,
    required this.transactionNo,
    required this.shiftId,
    required this.transaction,
  });
}
