import 'dart:io';

import 'package:flutter/foundation.dart';

import 'app_config.dart';

class EnvironmentConfig {
  static void initializeConfig(String environment) {
    final appPackageName =
        Platform.isAndroid
            ? const String.fromEnvironment('PACKAGE_NAME_ANDROID')
            : const String.fromEnvironment('PACKAGE_NAME_IOS');
    switch (environment) {
      case 'development':
        AppConfig.init(
          cacheExpirationDuration: const Duration(hours: 3),
          apiBaseUrl: const String.fromEnvironment('STORE_URL'),
          enableLogging: true,
          environment: environment,
          storeLogo: const String.fromEnvironment('STORE_LOGO'),
          appTitle: const String.fromEnvironment('APP_TITLE'),
          appPackageName: appPackageName,
        );
        break;

      case 'production':
        AppConfig.init(
          cacheExpirationDuration: const Duration(hours: 3),
          apiBaseUrl: const String.fromEnvironment('STORE_URL'),
          enableLogging: false,
          environment: environment,
          storeLogo: const String.fromEnvironment('STORE_LOGO'),
          appTitle: const String.fromEnvironment('APP_TITLE'),
          appPackageName: appPackageName,
        );
        break;

      default:
        throw Exception('Unknown environment: $environment');
    }
  }

  static Future<void> setupEnv() async {
    // Burada build/run argümanlarından veya başka bir kaynaktan
    // environment bilgisi alınabilir
    final environment = kDebugMode ? 'development' : 'production';
    initializeConfig(environment);
  }
}
