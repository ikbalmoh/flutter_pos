import 'package:freezed_annotation/freezed_annotation.dart';

part 'fcm_subscribe.freezed.dart';
part 'fcm_subscribe.g.dart';

@freezed
abstract class FcmSubscribe with _$FcmSubscribe {
  const FcmSubscribe._();

  const factory FcmSubscribe({
    required String companyTopic,
    required String outletTopic,
    required String token,
  }) = _FcmSubscribe;

  factory FcmSubscribe.fromJson(Map<String, dynamic> json) =>
      _$FcmSubscribeFromJson(json);
}
