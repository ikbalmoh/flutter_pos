import 'package:freezed_annotation/freezed_annotation.dart';
import 'notification_data.dart';

part 'notification.freezed.dart';
part 'notification.g.dart';

@freezed
abstract class Notification with _$Notification {
  const Notification._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Notification({
    required int id,
    required String title,
    required String body,
    bool? isReaded,
    NotificationData? data,
  }) = _Notification;

  factory Notification.fromJson(Map<String, dynamic> json) =>
      _$NotificationFromJson(json);
}
