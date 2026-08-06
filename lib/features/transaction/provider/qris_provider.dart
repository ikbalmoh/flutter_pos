import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/features/outlet/provider/outlet_provider.dart';
import 'package:selleri/features/transaction/api/qris_api.dart';
import 'package:selleri/features/transaction/model/qris_state.dart';

part 'qris_provider.g.dart';

@riverpod
class Qris extends _$Qris {
  Timer? _statusTimer;

  @override
  Future<QrisState> build(String transactionNo, num amount) async {
    ref.onDispose(() => _statusTimer?.cancel());

    final api = ref.read(qrisApiProvider);
    final outlet = ref.read(outletProvider).value as OutletSelected;
    final merchantId = outlet.config.merchantId ?? '';
    final qrContent = await api.requestQris(
      transactionNo: transactionNo,
      amount: amount,
      merchantId: merchantId,
    );

    _startPolling(transactionNo: transactionNo, merchantId: merchantId);

    return QrisState(qrContent: qrContent);
  }

  void _startPolling({
    required String transactionNo,
    required String merchantId,
  }) {
    _statusTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      final String successCode = 'SUCCESS';
      final qrisApi = ref.read(qrisApiProvider);
      try {
        final statusCode = await qrisApi.checkStatus(
          transactionNo: transactionNo,
          merchantId: merchantId,
        );
        if (statusCode == successCode) {
          _statusTimer?.cancel();
          state = AsyncData(state.requireValue.copyWith(isPaid: true));
        }
      } catch (_) {}
    });
  }
}
