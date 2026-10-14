import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import '../logger/logger_service.dart';

@singleton
class ConnectivityMonitor {
  final _connectivity = Connectivity();
  StreamSubscription? _subscription;
  final _connectionStatus =
      ValueNotifier<List<ConnectivityResult>>([ConnectivityResult.none]);

  ValueNotifier<List<ConnectivityResult>> get connectionStatus =>
      _connectionStatus;

  ConnectivityMonitor();

  Future<void> startMonitoring() async {
    // Get initial connectivity status
    _connectionStatus.value = await _connectivity.checkConnectivity();

    // Start listening for changes
    _subscription = _connectivity.onConnectivityChanged.listen((result) {
      _connectionStatus.value = result;

      // Take appropriate actions based on connectivity change
      if (result.contains(ConnectivityResult.none)) {
        LoggerService.info('Device is offline');
      } else {
        LoggerService.info('Device is online');
      }
    });
  }


  void stopMonitoring() {
    _subscription?.cancel();
    _subscription = null;
  }
}
