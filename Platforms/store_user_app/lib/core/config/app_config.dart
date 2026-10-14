class AppConfig {
  final String apiBaseUrl;
  final bool enableLogging;
  final String environment;
  final String storeLogo;
  final String appTitle;
  final String appPackageName;

  static late AppConfig _instance;

  final Duration cacheExpirationDuration;

  AppConfig._({
    required this.apiBaseUrl,
    required this.enableLogging,
    required this.environment,
    required this.cacheExpirationDuration,
    required this.storeLogo,
    required this.appTitle,
    required this.appPackageName,
  });

  static AppConfig get instance => _instance;

  static void init({
    required String apiBaseUrl,
    required bool enableLogging,
    required String environment,
    required Duration cacheExpirationDuration,
    required String storeLogo,
    required String appTitle,
    required String appPackageName,
  }) {
    _instance = AppConfig._(
      cacheExpirationDuration: cacheExpirationDuration,
      apiBaseUrl: apiBaseUrl,
      enableLogging: enableLogging,
      environment: environment,
      storeLogo: storeLogo,
      appTitle: appTitle,
      appPackageName: appPackageName,
    );
  }

  static bool get isProduction => instance.environment == 'production';
  static bool get isDevelopment => instance.environment == 'development';
}
