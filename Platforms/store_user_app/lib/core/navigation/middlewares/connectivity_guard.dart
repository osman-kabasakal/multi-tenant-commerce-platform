import 'package:auto_route/auto_route.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:store_user_app/core/services/Security/connectivity_monitor.dart';

class ConnectivityGuard extends AutoRouteGuard {
  final ConnectivityMonitor _connectivityService;

  ConnectivityGuard(this._connectivityService);

  @override
  Future<void> onNavigation(NavigationResolver resolver, StackRouter router) async {

    if (!_connectivityService.connectionStatus.value
        .contains(ConnectivityResult.none)) {
      // we continue navigation
      resolver.next(true);
    } else {
      resolver.next(false);
    }
  }
}