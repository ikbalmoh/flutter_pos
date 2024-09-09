import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:selleri/data/models/customer_group.dart';

part 'customer.freezed.dart';
part 'customer.g.dart';

@freezed
class Customer with _$Customer {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Customer({
    required String idCustomer,
    required String code,
    required String customerName,
    String? barcode,
    String? dob,
    String? email,
    String? npwp,
    String? phoneNumber,
    String? address,
    String? city,
    String? province,
    String? postalCode,
    String? createdBy,
    String? updatedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? cardId,
    String? cardIdNumber,
    bool? isMember,
    DateTime? expiredDate,
    String? groupNames,
    List<CustomerGroup>? groups,
  }) = _Customer;

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);
}
