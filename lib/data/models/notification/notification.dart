import 'package:freezed_annotation/freezed_annotation.dart';
import 'notification_data.dart';

part 'notification.freezed.dart';
part 'notification.g.dart';

@freezed
class Notification with _$Notification {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Notification({
    required int id,
    required String title,
    required String body,
    NotificationData? data,
  }) = _Notification;

  factory Notification.fromJson(Map<String, dynamic> json) =>
      _$NotificationFromJson(json);
}
