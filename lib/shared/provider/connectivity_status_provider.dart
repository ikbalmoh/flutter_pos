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

  @override
  ConnectivityState build() {
    _connectivityService = InternetConnectivityChecker();
    
    final subscription = _connectivityService!.connectionChange.listen((isConnected) {
      log('ConnectivityState changed: $isConnected');
      state = isConnected
          ? ConnectivityState.connected
          : ConnectivityState.disconnected;
    });

    ref.onDispose(() {
      subscription.cancel();
      _connectivityService?.dispose();
    });

    return ConnectivityState.connected;
  }
}
