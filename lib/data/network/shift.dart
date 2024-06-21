import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:selleri/config/api_url.dart';
import 'package:selleri/data/constants/store_key.dart';
import 'package:selleri/data/models/shift.dart';
import 'package:selleri/data/models/shift_info.dart';
import 'package:selleri/utils/fetch.dart';
import 'package:selleri/utils/formater.dart';

const storage = FlutterSecureStorage();

class ShiftApi {
  final api = fetch();

  Future<Shift?> startShift(Shift shift) async {
    Map<String, dynamic> data = {
      "id": shift.id,
      "outlet_id": shift.outletId,
      "device_id": shift.deviceId,
      "start_shift": DateTimeFormater.dateToString(shift.startShift),
      "open_amount": shift.openAmount,
      "created_by": shift.createdBy
    };
    final res = await api.post('${ApiUrl.shifts}/store', data: [data]);
    List success = res.data['data']['success'];
    if (success.isNotEmpty) {
      return Shift.fromJson(success[0]);
    }
    return null;
  }

  Future<void> currentShift() async {
    String? deviceId = await storage.read(key: StoreKey.device.toString());
    api.get('/info/urrent-shift/$deviceId');
  }

  Future<ShiftInfo?> shiftInfo(String shiftId) async {
    final res = await api.get('${ApiUrl.shifts}/$shiftId');
    return ShiftInfo.fromJson(res.data['data']);
  }
}
