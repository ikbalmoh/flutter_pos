import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/data/constants/store_key.dart';
import 'package:selleri/data/models/shift.dart';
import 'package:selleri/data/repository/shift_repository.dart';
import 'package:selleri/providers/auth/auth_provider.dart';
import 'package:selleri/providers/outlet/outlet_provider.dart';
import 'package:selleri/utils/formater.dart';
import 'package:uuid/uuid.dart';
import 'dart:developer';

part 'shift_provider.g.dart';

var uuid = const Uuid();

@Riverpod(keepAlive: true)
class ShiftNotifier extends _$ShiftNotifier {
  late final ShiftRepository _shiftRepository =
      ref.read(shiftRepositoryProvider);

  @override
  FutureOr<Shift?> build() async {
    final shift = await _shiftRepository.retrieveShift();
    return shift;
  }

  Future<void> openShift(double openAmount) async {
    state = const AsyncLoading();
    final outletState =
        await ref.read(outletNotifierProvider.future) as OutletSelected;
    final authState =
        await ref.read(authNotifierProvider.future) as Authenticated;

    final userAccount = authState.user.user;

    const storage = FlutterSecureStorage();
    final deviceId = await storage.read(key: StoreKey.device.toString());

    final outlet = outletState.outlet;

    final shift = Shift(
      id: uuid.v4(),
      outletId: outlet.idOutlet,
      outletName: outlet.outletName,
      deviceId: deviceId!,
      createdAt: DateTime.now(),
      createdBy: userAccount.idUser,
      createdName: userAccount.name,
      updatedBy: userAccount.idUser,
      updatedName: userAccount.name,
      startShift: DateTime.now(),
      openAmount: openAmount,
    );
    try {
      final storedShift = await _shiftRepository.saveShift(shift);
      state = AsyncData(storedShift);
    } on DioException catch (e) {
      String message = e.response?.data['msg'] ?? e.message;
      log('OPEN SHIFT FAILED: $message');
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> closeShift({
    required double closeAmount,
    required double diffAmount,
    required double refundAmount,
    List<XFile>? attachments,
  }) async {
    final String idUser =
        (ref.read(authNotifierProvider).value as Authenticated)
            .user
            .user
            .idUser;
    try {
      Map<String, dynamic> payload = {
        "close_shift": DateTimeFormater.dateToString(DateTime.now()),
        "close_amount": closeAmount,
        "diff_amount": diffAmount,
        "refund_amount": refundAmount,
        "attachments": attachments,
        "updated_by": idUser,
        "_method": "PUT"
      };
      await _shiftRepository.close(state.value!.id, payload);
      state = const AsyncData(null);
    } catch (e) {
      throw Exception(e);
    }
  }
}
