import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/services/Security/connectivity_monitor.dart';

class ConnectivityAwareWidget extends StatelessWidget {
  final Widget child;

  const ConnectivityAwareWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<ConnectivityResult>>(
      valueListenable: getIt<ConnectivityMonitor>().connectionStatus,
      builder: (context, connectivity, _) {
        if (connectivity.contains(ConnectivityResult.none)) {
          // Show offline indicator
          return Stack(
            children: [
              child,
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Material(
                  color: Colors.red,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      'İnternet bağlantısı yok',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          );
        }
        return child;
      },
    );
  }
}