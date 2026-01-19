import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

class InternetConnectivityChecker {
  InternetConnectivityChecker() {
    _initialize();
  }

  final Connectivity _connectivity = Connectivity();
  bool hasConnection = false;
  final StreamController<bool> _connectionChangeController =
      StreamController<bool>.broadcast();

  Stream<bool> get connectionChange => _connectionChangeController.stream;

  void _initialize() {
    _connectivity.onConnectivityChanged.listen(
      (List<ConnectivityResult> result) {
        log('Connection Change: $result');
        _checkInternetConnection();
      },
    );
    // Initial check
    _checkInternetConnection();
  }

  Future<void> _checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com').timeout(const Duration(seconds: 5));
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        hasConnection = true;
      } else {
        hasConnection = false;
      }
    } catch (_) {
      hasConnection = false;
    }
    _connectionChangeController.add(hasConnection);
    log('Emitting connection status: $hasConnection');
  }

  void dispose() {
    _connectionChangeController.close();
  }
}
