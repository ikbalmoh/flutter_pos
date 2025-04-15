import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:selleri/data/constants/store_key.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'notification_repository.g.dart';

abstract class NotificationRepositoryProtocol {
  Future<bool> isReaded(int id);

  Future<void> markAsReaded(int id);
}

@riverpod
NotificationRepository notificationRepository(Ref ref) =>
    NotificationRepository();

class NotificationRepository implements NotificationRepositoryProtocol {
  @override
  Future<bool> isReaded(int id) async {
    const storage = FlutterSecureStorage();
    String? readedString = await storage.read(key: StoreKey.notification.name);
    if (readedString == null) {
      return false;
    }
    List<dynamic> readed = jsonDecode(readedString);
    return readed.contains(id.toString());
  }

  @override
  Future<void> markAsReaded(int id) async {
    const storage = FlutterSecureStorage();
    String? readedString = await storage.read(key: StoreKey.notification.name);
    List<dynamic> readed = readedString == null ? [] : jsonDecode(readedString);
    readed.add(id.toString());
    await storage.write(
        key: StoreKey.notification.name, value: jsonEncode(readed));
  }
}
