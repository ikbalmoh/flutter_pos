import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/shared/utils/connectivity_checker.dart';

part 'connectivity_status_provider.g.dart';

enum ConnectivityState {
  disconnected,
  connected,
}

@riverpod
class ConnectivityStatus extends _$ConnectivityStatus {
  final InternetConnectivityChecker _connectivityService =
      InternetConnectivityChecker();

  @override
  ConnectivityState build() {
    watchConnection();
    return ConnectivityState.connected;
  }

  watchConnection() {
    _connectivityService.connectionChange.listen((isConnected) {
      state = isConnected
          ? ConnectivityState.connected
          : ConnectivityState.disconnected;
    });
  }
}
