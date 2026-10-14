import 'package:flutter/foundation.dart';

/// Cloud integrations remain enabled unless the developer explicitly selects the debug demo.
abstract final class LocalDemo {
  static const enabled = bool.fromEnvironment('LOCAL_DEMO');
  static void validate() {
    if (enabled && !kDebugMode) {
      throw StateError('LOCAL_DEMO is only available in debug builds.');
    }
  }
}
