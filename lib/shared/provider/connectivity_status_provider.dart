import 'dart:developer';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/shared/utils/connectivity_checker.dart';

part 'connectivity_status_provider.g.dart';

enum ConnectivityState {
  disconnected,
  connected,
}

@Riverpod(keepAlive: true)
class ConnectivityStatus extends _$ConnectivityStatus {
  InternetConnectivityChecker? _connectivityService;

  static ConnectivityState current = ConnectivityState.connected;

  @override
  ConnectivityState build() {
    _connectivityService = InternetConnectivityChecker();
    
    final subscription = _connectivityService!.connectionChange.listen((isConnected) {
      log('ConnectivityState changed: $isConnected');
      final newState = isConnected
          ? ConnectivityState.connected
          : ConnectivityState.disconnected;
      state = newState;
      current = newState;
    });

    ref.onDispose(() {
      subscription.cancel();
      _connectivityService?.dispose();
    });

    return ConnectivityState.connected;
  }
}
