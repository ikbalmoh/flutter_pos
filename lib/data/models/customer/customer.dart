import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:selleri/data/models/customer/customer_group.dart';
import 'package:selleri/data/models/customer/customer_vehicle.dart';

part 'customer.freezed.dart';
part 'customer.g.dart';

@freezed
class Customer with _$Customer {
  const Customer._();

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
    String? createdAt,
    String? updatedAt,
    int? cardId,
    String? cardIdNumber,
    bool? isMember,
    String? expiredDate,
    String? groupNames,
    List<CustomerGroup>? groups,
    List<CustomerVehicle>? vehicles,
  }) = _Customer;

  factory Customer.initial() => const Customer(
        idCustomer: '',
        code: '',
        customerName: '',
        barcode: '',
        dob: null,
        email: '',
        npwp: '',
        phoneNumber: '',
        address: '',
        city: '',
        province: '',
        postalCode: '',
        createdBy: null,
        updatedBy: null,
        createdAt: null,
        updatedAt: null,
        cardId: 0,
        cardIdNumber: '',
        isMember: false,
        expiredDate: null,
      );

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);

  Map<String, dynamic> toPayload() {
    final json = <String, dynamic>{
      'id_customer': idCustomer,
      'code': code,
      'customer_name': customerName,
      'barcode': barcode,
      'dob': dob,
      'email': email,
      'npwp': npwp,
      'phone_number': phoneNumber,
      'address': address,
      'city': city,
      'province': province,
      'postal_code': postalCode,
      'card_id': cardId,
      'card_id_number': cardIdNumber,
      'is_member': isMember,
      'expired_date': expiredDate,
      'group_names': groupNames,
      'groups': groups?.map((e) => e.groupId).toList(),
      'vehicles': vehicles?.map((e) => e.toJson()).toList(),
    };
    return json;
  }
}
