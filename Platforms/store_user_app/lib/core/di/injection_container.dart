import 'package:get_it/get_it.dart';
import 'package:store_user_app/core/config/local_demo.dart';
import 'package:injectable/injectable.dart';
import 'package:store_user_app/core/services/analytics/analytics_service.dart';
import 'package:store_user_app/core/services/auth/auth_service.dart';
import 'package:store_user_app/core/services/crashlytics/crashlytics_service.dart';
import 'package:store_user_app/core/services/fcm_service.dart';
import 'package:store_user_app/domain/events/entity_events/auth_tokens_refresh_event_handler.dart';
import 'package:store_user_app/domain/events/entity_events/checkout_step_response_event_handler.dart';

import '../services/cache/cache_freshness_service.dart';
import 'injection_container.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init', // default
  preferRelativeImports: true, // default
  asExtension: false, // default
)
Future<void> configureDependencies() async {
  init(getIt);

  // Manuel kayıtlar
  if (!getIt.isRegistered<AnalyticsService>()) {
    getIt.registerLazySingleton(() => AnalyticsService());
  }

  if (!getIt.isRegistered<CrashlyticsService>()) {
    getIt.registerLazySingleton(() => CrashlyticsService());
  }

  // Servislerin hazır olmasını bekle
  await getIt.isReady<AuthService>();
  await getIt.isReady<CacheFreshnessService>();
  getIt<CacheFreshnessService>().checkCacheFreshness();
  getIt.get<AuthTokensRefreshEventHandler>();
  getIt.get<CheckoutStepResponseEventHandler>();

  // Firebase servislerini başlat
  if (!LocalDemo.enabled) await getIt.isReady<FCMService>();
  await getIt.get<AnalyticsService>().initialize();
  await getIt.get<CrashlyticsService>().initialize();
}
