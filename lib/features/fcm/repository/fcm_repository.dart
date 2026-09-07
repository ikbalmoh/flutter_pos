import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:selleri/shared/constants/store_key.dart';
import 'package:selleri/features/fcm/model/fcm_subscribe.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fcm_repository.g.dart';

abstract class FcmRepositoryProtocol {
  Future<FcmSubscribe?> readFcmTopic();

  Future<void> saveFcmTopic(FcmSubscribe topic);
}

@riverpod
FcmRepository fcmRepository(Ref ref) => FcmRepository();

class FcmRepository implements FcmRepositoryProtocol {
  @override
  Future<void> saveFcmTopic(FcmSubscribe topic) async {
    const storage = FlutterSecureStorage();
    await storage.write(
        key: StoreKey.fcmSubscribe.name, value: topic.toString());
  }

  @override
  Future<FcmSubscribe?> readFcmTopic() async {
    const storage = FlutterSecureStorage();
    String? topicValue = await storage.read(key: StoreKey.fcmSubscribe.name);
    if (topicValue != null) {
      final jsonToken = json.decode(topicValue);
      return FcmSubscribe.fromJson(jsonToken);
    }
    return null;
  }
}
