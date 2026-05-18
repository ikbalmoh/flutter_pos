import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/features/transaction/api/qris_api.dart';
import 'package:selleri/features/transaction/model/qris_state.dart';

part 'qris_provider.g.dart';

@riverpod
class Qris extends _$Qris {
  Timer? _statusTimer;

  @override
  Future<QrisState> build(String transactionNo, String amount) async {
    ref.onDispose(() => _statusTimer?.cancel());

    final api = ref.read(qrisApiProvider);
    final qrContent = await api.requestQris(
      transactionNo: transactionNo,
      amount: amount,
    );

    _startPolling(transactionNo);

    return QrisState(qrContent: qrContent);
  }

  void _startPolling(String transactionNo) {
    _statusTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      try {
        final paid = await ref
            .read(qrisApiProvider)
            .checkStatus(transactionNo: transactionNo);
        if (paid) {
          _statusTimer?.cancel();
          state = AsyncData(state.requireValue.copyWith(isPaid: true));
        }
      } catch (_) {}
    });
  }
}
