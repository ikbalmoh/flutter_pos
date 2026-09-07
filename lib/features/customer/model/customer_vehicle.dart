import 'package:freezed_annotation/freezed_annotation.dart';

part 'customer_vehicle.freezed.dart';
part 'customer_vehicle.g.dart';

@freezed
abstract class CustomerVehicle with _$CustomerVehicle {
  const CustomerVehicle._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory CustomerVehicle({
    required int idVehicle,
    required String vehicleType,
    required String vehicleBrand,
    required String licensePlate,
  }) = _CustomerVehicle;

  factory CustomerVehicle.fromJson(Map<String, dynamic> json) =>
      _$CustomerVehicleFromJson(json);
}
