import 'package:json_annotation/json_annotation.dart';
import 'package:selleri/models/converters/generic.dart';

part 'payment_method.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class PaymentMethod {
  String id;
  String name;
  int type;
  String? description;
  
  @JsonKey(fromJson: Converters.dynamicToBool)
  bool? showCaption;
  
  String? caption;
  bool? chargeable;
  int? chargeValue;
  String? namaAkun;
  String? bankName;
  String? typeName;

  PaymentMethod({
    required this.id,
    required this.name,
    required this.type,
    this.description,
    this.showCaption,
    this.caption,
    this.chargeable,
    this.chargeValue,
    this.namaAkun,
    this.bankName,
    this.typeName,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => _$PaymentMethodFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentMethodToJson(this);
}