import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_data.freezed.dart';
part 'notification_data.g.dart';

@freezed
abstract class NotificationData with _$NotificationData {
  const NotificationData._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory NotificationData({
    int? notificationId,
    String? link,
    String? transferNumber,
    String? clickAction,
    String? purchaseNumber,
  }) = _NotificationData;

  factory NotificationData.fromJson(Map<String, dynamic> json) =>
      _$NotificationDataFromJson(json);
}
