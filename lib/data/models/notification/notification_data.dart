import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_data.freezed.dart';
part 'notification_data.g.dart';

@freezed
class NotificationData with _$NotificationData {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory NotificationData({
    required int notificationId,
    String? link,
    String? transferNumber,
    String? purchaseNumber,
  }) = _NotificationData;

  factory NotificationData.fromJson(Map<String, dynamic> json) =>
      _$NotificationDataFromJson(json);
}
