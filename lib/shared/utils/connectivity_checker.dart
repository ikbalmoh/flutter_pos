import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

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
        debugPrint('Connection Change: $result');
        _checkInternetConnection();
      },
    );
  }

  Future<void> _checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      hasConnection = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      debugPrint('Internet Connection: $hasConnection');
    } on SocketException {
      hasConnection = false;
      debugPrint('Internet Connection: $hasConnection');
    }
    _connectionChangeController.add(hasConnection);
    debugPrint('Emitting connection status: $hasConnection');
  }

  void dispose() {
    _connectionChangeController.close();
  }
}
