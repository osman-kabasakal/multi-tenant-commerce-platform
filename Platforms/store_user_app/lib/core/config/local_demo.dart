import 'package:flutter/foundation.dart';

/// Cloud integrations remain enabled unless the developer explicitly selects the debug demo.
abstract final class LocalDemo {
  static const enabled = bool.fromEnvironment('LOCAL_DEMO');
  static const tenantHost = String.fromEnvironment('LOCAL_TENANT_HOST');
  static void validate() {
    if (tenantHost.isNotEmpty &&
        (!enabled ||
            !RegExp(
              r'^[a-z][a-z0-9-]{1,38}[a-z0-9]\.localhost(?::18090)?$',
            ).hasMatch(tenantHost))) {
      throw StateError('LOCAL_TENANT_HOST requires a valid local demo tenant.');
    }
    if (enabled && !kDebugMode) {
      throw StateError('LOCAL_DEMO is only available in debug builds.');
    }
  }
}
