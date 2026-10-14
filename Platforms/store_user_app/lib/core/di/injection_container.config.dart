// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cookie_jar/cookie_jar.dart' as _i557;
import 'package:dio/dio.dart' as _i361;
import 'package:dio_cookie_manager/dio_cookie_manager.dart' as _i6;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../domain/cache/cache_manager_impl.dart' as _i339;
import '../../domain/cache/custom_cache_manager.dart' as _i1003;
import '../../domain/cache/hive_remote_cache.dart' as _i410;
import '../../domain/entities/models/orders/order_details_model/order_details_model.dart'
    as _i464;
import '../../domain/events/entity_events/auth_tokens_refresh_event_handler.dart'
    as _i1012;
import '../../domain/events/entity_events/checkout_step_response_event_handler.dart'
    as _i381;
import '../../domain/events/entity_events/merchandise_return_event_handler.dart'
    as _i648;
import '../../domain/events/theme/theme_mode_event.dart' as _i859;
import '../../domain/remote_data_sources/account/account_data_source.dart'
    as _i372;
import '../../domain/remote_data_sources/action_cart/action_cart_data_source.dart'
    as _i133;
import '../../domain/remote_data_sources/blog/blog_data_source.dart' as _i970;
import '../../domain/remote_data_sources/catalog/catalog_data_source.dart'
    as _i692;
import '../../domain/remote_data_sources/checkout/checkout_data_source.dart'
    as _i792;
import '../../domain/remote_data_sources/common/common_data_source.dart'
    as _i675;
import '../../domain/remote_data_sources/component/component_data_source.dart'
    as _i288;
import '../../domain/remote_data_sources/contact/contact_data_source.dart'
    as _i532;
import '../../domain/remote_data_sources/country/country_data_source.dart'
    as _i809;
import '../../domain/remote_data_sources/course/course_data_source.dart'
    as _i193;
import '../../domain/remote_data_sources/download/download_data_source.dart'
    as _i287;
import '../../domain/remote_data_sources/home/home_data_source.dart' as _i632;
import '../../domain/remote_data_sources/knowledgebase/knowledgebase_data_source.dart'
    as _i942;
import '../../domain/remote_data_sources/merchandise_return/merchandise_return_data_source.dart'
    as _i325;
import '../../domain/remote_data_sources/news/news_data_source.dart' as _i301;
import '../../domain/remote_data_sources/newsletter/newsletter_data_source.dart'
    as _i976;
import '../../domain/remote_data_sources/order/order_data_source.dart' as _i89;
import '../../domain/remote_data_sources/out_of_stock_subscription/out_of_stock_subscription_data_source.dart'
    as _i430;
import '../../domain/remote_data_sources/page/page_data_source.dart' as _i203;
import '../../domain/remote_data_sources/product/product_data_source.dart'
    as _i520;
import '../../domain/remote_data_sources/shopping_cart/shopping_cart_data_source.dart'
    as _i290;
import '../../domain/remote_data_sources/shopping_cart/shopping_cart_info_data_source.dart'
    as _i911;
import '../../domain/remote_data_sources/vendor/vendor_data_source.dart'
    as _i181;
import '../../domain/remote_data_sources/wishlist/wishlist_data_source.dart'
    as _i207;
import '../../domain/repositories/account/account_repository.dart' as _i1000;
import '../../domain/repositories/action_cart/action_cart_repository.dart'
    as _i743;
import '../../domain/repositories/blog/blog_repository.dart' as _i677;
import '../../domain/repositories/catalog/catalog_repository.dart' as _i449;
import '../../domain/repositories/checkout/checkout_repository.dart' as _i998;
import '../../domain/repositories/common/common_repository.dart' as _i1022;
import '../../domain/repositories/component/component_repository.dart' as _i76;
import '../../domain/repositories/contact/contact_repository.dart' as _i653;
import '../../domain/repositories/country/country_repository.dart' as _i525;
import '../../domain/repositories/course/course_repository.dart' as _i1043;
import '../../domain/repositories/download/download_repository.dart' as _i787;
import '../../domain/repositories/home/home_repository.dart' as _i22;
import '../../domain/repositories/knowledgebase/knowledgebase_repository.dart'
    as _i512;
import '../../domain/repositories/merchandise_return/merchandise_return_repository.dart'
    as _i959;
import '../../domain/repositories/news/news_repository.dart' as _i85;
import '../../domain/repositories/newsletter/newsletter_repository.dart'
    as _i643;
import '../../domain/repositories/notification/notification_repository.dart'
    as _i87;
import '../../domain/repositories/notification/notification_storage_repository.dart'
    as _i619;
import '../../domain/repositories/order/order_repository.dart' as _i750;
import '../../domain/repositories/out_of_stock_subscription/out_of_stock_subscription_repository.dart'
    as _i117;
import '../../domain/repositories/page/page_repository.dart' as _i387;
import '../../domain/repositories/product/product_repository.dart' as _i774;
import '../../domain/repositories/shopping_cart/shopping_cart_info_repository.dart'
    as _i1014;
import '../../domain/repositories/shopping_cart/shopping_cart_repository.dart'
    as _i722;
import '../../domain/repositories/vendor/vendor_repository.dart' as _i840;
import '../../domain/repositories/wishlist/wishlist_repository.dart' as _i261;
import '../../domain/usecases/notification/notification_checker_service.dart'
    as _i545;
import '../../presentation/screens/home/event_listeners/auth_tokens_refresh_event_listener.dart'
    as _i801;
import '../../presentation/screens/orders/event_listeners/order_listener.dart'
    as _i790;
import '../cache/cache_manager.dart' as _i326;
import '../cache/remote_cache.dart' as _i139;
import '../cross_cutting_concerns/aspects/caching_aspect.dart' as _i881;
import '../cross_cutting_concerns/aspects/error_handling_aspect.dart' as _i807;
import '../cross_cutting_concerns/aspects/logging_aspect.dart' as _i777;
import '../cross_cutting_concerns/aspects/performance_aspect.dart' as _i755;
import '../cross_cutting_concerns/aspects/zoned_caching_aspect.dart' as _i610;
import '../cross_cutting_concerns/decorators/repository_decorator.dart'
    as _i107;
import '../data/events/cache_invalidation_notifier.dart' as _i172;
import '../data/events/entity_created_event.dart' as _i285;
import '../data/events/entity_event_listener.dart' as _i69;
import '../data/events/entity_updated_event.dart' as _i51;
import '../data/events/event_bus.dart' as _i694;
import '../data/events/event_logger.dart' as _i564;
import '../navigation/app_router.dart' as _i630;
import '../network/dio/interceptors/antiforgery_cookie_interceptor.dart'
    as _i804;
import '../network/dio/interceptors/auth_interceptor.dart' as _i211;
import '../network/dio/interceptors/cachekey_tracker_interceptor.dart'
    as _i1057;
import '../services/analytics/analytics_service.dart' as _i554;
import '../services/auth/app_tokens_refresh_event.dart' as _i923;
import '../services/auth/auth_service.dart' as _i305;
import '../services/background_task_queue/background_task_queue.dart' as _i991;
import '../services/cache/cache_freshness_service.dart' as _i1059;
import '../services/correlation/correlation_service.dart' as _i19;
import '../services/crashlytics/crashlytics_service.dart' as _i254;
import '../services/deeplink/deeplink_service.dart' as _i228;
import '../services/fcm_service.dart' as _i928;
import '../services/file_service/dio_file_service.dart' as _i1028;
import '../services/Security/connectivity_monitor.dart' as _i569;
import '../services/storage/cookie_secure_storage.dart' as _i747;
import '../services/theme/theme_controller.dart' as _i201;
import 'modules/dio_module.dart' as _i983;
import 'modules/service_module.dart' as _i681;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt init(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(getIt, environment, environmentFilter);
  final dioModule = _$DioModule();
  final serviceModule = _$ServiceModule();
  gh.singleton<_i558.FlutterSecureStorage>(
    () => dioModule.provideFlutterSecureStorage(),
  );
  gh.singletonAsync<_i1057.CacheKeyTrackerInterceptor>(
    () => dioModule.provideCacheKeyTrackerInterceptor(),
  );
  gh.singleton<_i694.EventBus>(
    () => _i694.EventBus(),
    dispose: (i) => i.dispose(),
  );
  gh.singleton<_i569.ConnectivityMonitor>(() => _i569.ConnectivityMonitor());
  gh.singletonAsync<_i19.CorrelationService>(
    () => _i19.CorrelationService.create(),
    dispose: (i) => i.dispose(),
  );
  gh.singleton<_i991.BackgroundTaskQueue>(
    () => _i991.BackgroundTaskQueue.factorySingleton(),
    dispose: (i) => i.dispose(),
  );
  gh.lazySingleton<_i807.ErrorHandlingAspect>(
    () => _i807.ErrorHandlingAspect(),
  );
  gh.lazySingleton<_i777.LoggingAspect>(() => _i777.LoggingAspect());
  gh.lazySingleton<_i755.PerformanceAspect>(() => _i755.PerformanceAspect());
  gh.lazySingleton<_i254.CrashlyticsService>(() => _i254.CrashlyticsService());
  gh.lazySingleton<_i554.AnalyticsService>(() => _i554.AnalyticsService());
  gh.lazySingletonAsync<_i619.NotificationStorageRepository>(
    () => _i619.NotificationStorageRepository.create(),
  );
  gh.factory<
    _i69.EntityEventListener<_i285.EntityCreatedEvent<_i464.OrderDetailsModel>>
  >(() => _i790.OrderCreatedListener());
  gh.factory<_i69.EntityEventListener<_i923.AuthTokensRefreshEvent>>(
    () => _i801.AuthTokensRefreshEventListener(),
  );
  gh.factory<
    _i69.EntityEventListener<_i51.EntityUpdatedEvent<_i464.OrderDetailsModel>>
  >(() => _i790.OrderUpdatedListener());
  gh.singletonAsync<_i139.RemoteCache>(
    () => _i410.HiveRemoteCache.getInstance(),
  );
  gh.singleton<_i747.CookieSecureStoreage>(
    () =>
        dioModule.provideCookieSecureStoreage(gh<_i558.FlutterSecureStorage>()),
  );
  gh.singleton<_i1012.AuthTokensRefreshEventHandler>(
    () => _i1012.AuthTokensRefreshEventHandler(gh<_i694.EventBus>()),
    dispose: (i) => i.dispose(),
  );
  gh.singleton<_i648.MerchandiseReturnEventHandler>(
    () => _i648.MerchandiseReturnEventHandler(gh<_i694.EventBus>()),
  );
  gh.singleton<_i381.CheckoutStepResponseEventHandler>(
    () => _i381.CheckoutStepResponseEventHandler(gh<_i694.EventBus>()),
    dispose: (i) => i.dispose(),
  );
  gh.singleton<_i859.ThemeModeEvent>(
    () => _i859.ThemeModeEvent(gh<_i694.EventBus>()),
    dispose: (i) => i.singletonDispose(),
  );
  gh.singletonAsync<_i326.CacheManager>(
    () async => _i339.CacheManagerImpl.create(
      await gh.getAsync<_i139.RemoteCache>(),
      gh<_i694.EventBus>(),
    ),
    dependsOn: [_i139.RemoteCache],
    dispose: (i) => i.dispose(),
  );
  gh.singleton<_i564.EventLogger>(
    () => _i564.EventLogger(gh<_i694.EventBus>()),
  );
  gh.singleton<_i172.CacheInvalidationNotifier>(
    () => _i172.CacheInvalidationNotifier(gh<_i694.EventBus>()),
    dispose: (i) => i.dispose(),
  );
  gh.singletonWithDependencies<_i630.AppRouter>(
    () => _i630.AppRouter(),
    dependsOn: [_i139.RemoteCache],
  );
  gh.singleton<_i557.PersistCookieJar>(
    () => dioModule.providePersistCookieJar(gh<_i747.CookieSecureStoreage>()),
  );
  gh.lazySingletonAsync<_i201.ThemeController>(
    () async => _i201.ThemeController.loadTheme(
      await gh.getAsync<_i326.CacheManager>(),
      gh<_i694.EventBus>(),
    ),
  );
  gh.lazySingletonAsync<_i610.ZonedCachingAspect>(
    () async => _i610.ZonedCachingAspect.factorySingleton(
      await gh.getAsync<_i326.CacheManager>(),
    ),
  );
  gh.lazySingletonAsync<_i881.CachingAspect>(
    () async => _i881.CachingAspect(await gh.getAsync<_i326.CacheManager>()),
  );
  gh.singleton<_i6.CookieManager>(
    () => dioModule.provideCookieManager(gh<_i557.PersistCookieJar>()),
  );
  gh.singleton<_i804.AntiforgeryCookieInterceptor>(
    () => dioModule.provideAntiforgeryCookieInterceptor(
      gh<_i557.PersistCookieJar>(),
    ),
  );
  gh.lazySingletonAsync<_i107.RepositoryDecorator>(
    () async => _i107.RepositoryDecorator(
      await gh.getAsync<_i19.CorrelationService>(),
      gh<_i777.LoggingAspect>(),
      await gh.getAsync<_i610.ZonedCachingAspect>(),
      gh<_i807.ErrorHandlingAspect>(),
      gh<_i755.PerformanceAspect>(),
      gh<_i569.ConnectivityMonitor>(),
      gh<_i694.EventBus>(),
    ),
  );
  gh.singletonAsync<_i305.AuthService>(
    () => dioModule.provideAuthService(
      gh<_i558.FlutterSecureStorage>(),
      gh<_i694.EventBus>(),
      gh<_i6.CookieManager>(),
    ),
  );
  gh.singletonAsync<_i211.AuthInterceptor>(
    () async => dioModule.provideAuthInterceptor(
      await gh.getAsync<_i305.AuthService>(),
    ),
  );
  gh.singletonAsync<_i361.Dio>(
    () async => dioModule.provideDio(
      gh<_i6.CookieManager>(),
      await gh.getAsync<_i211.AuthInterceptor>(),
      await gh.getAsync<_i1057.CacheKeyTrackerInterceptor>(),
      gh<_i804.AntiforgeryCookieInterceptor>(),
    ),
  );
  gh.singletonAsync<_i983.FileServiceDio>(
    () async => dioModule.provideSignalRDio(
      gh<_i6.CookieManager>(),
      await gh.getAsync<_i211.AuthInterceptor>(),
      await gh.getAsync<_i1057.CacheKeyTrackerInterceptor>(),
      gh<_i804.AntiforgeryCookieInterceptor>(),
    ),
  );
  gh.singletonAsync<_i1059.CacheFreshnessService>(
    () async => _i1059.CacheFreshnessService.create(
      await gh.getAsync<_i326.CacheManager>(),
      await gh.getAsync<_i361.Dio>(),
      await gh.getAsync<_i1057.CacheKeyTrackerInterceptor>(),
      gh<_i569.ConnectivityMonitor>(),
      gh<_i694.EventBus>(),
    ),
    dependsOn: [_i326.CacheManager, _i361.Dio],
    dispose: (i) => i.dispose(),
  );
  gh.lazySingletonAsync<_i1028.DioFileService>(
    () async => serviceModule.provideDioFileService(
      await gh.getAsync<_i983.FileServiceDio>(),
    ),
  );
  gh.lazySingletonAsync<_i89.OrderDataSource>(
    () async => _i89.OrderDataSource(await gh.getAsync<_i361.Dio>()),
  );
  gh.lazySingletonAsync<_i632.HomeDataSource>(
    () async => _i632.HomeDataSource(await gh.getAsync<_i361.Dio>()),
  );
  gh.lazySingletonAsync<_i203.PageDataSource>(
    () async => _i203.PageDataSource(await gh.getAsync<_i361.Dio>()),
  );
  gh.lazySingletonAsync<_i532.ContactDataSource>(
    () async => _i532.ContactDataSource(await gh.getAsync<_i361.Dio>()),
  );
  gh.lazySingletonAsync<_i193.CourseDataSource>(
    () async => _i193.CourseDataSource(await gh.getAsync<_i361.Dio>()),
  );
  gh.lazySingletonAsync<_i430.OutOfStockSubscriptionDataSource>(
    () async =>
        _i430.OutOfStockSubscriptionDataSource(await gh.getAsync<_i361.Dio>()),
  );
  gh.lazySingletonAsync<_i692.CatalogDataSource>(
    () async => _i692.CatalogDataSource(await gh.getAsync<_i361.Dio>()),
  );
  gh.lazySingletonAsync<_i133.ActionCartDataSource>(
    () async => _i133.ActionCartDataSource(await gh.getAsync<_i361.Dio>()),
  );
  gh.lazySingletonAsync<_i288.ComponentDataSource>(
    () async => _i288.ComponentDataSource(await gh.getAsync<_i361.Dio>()),
  );
  gh.lazySingletonAsync<_i520.ProductDataSource>(
    () async => _i520.ProductDataSource(await gh.getAsync<_i361.Dio>()),
  );
  gh.lazySingletonAsync<_i792.CheckoutDataSource>(
    () async => _i792.CheckoutDataSource(await gh.getAsync<_i361.Dio>()),
  );
  gh.lazySingletonAsync<_i970.BlogDataSource>(
    () async => _i970.BlogDataSource(await gh.getAsync<_i361.Dio>()),
  );
  gh.lazySingletonAsync<_i325.MerchandiseReturnDataSource>(
    () async =>
        _i325.MerchandiseReturnDataSource(await gh.getAsync<_i361.Dio>()),
  );
  gh.lazySingletonAsync<_i942.KnowledgebaseDataSource>(
    () async => _i942.KnowledgebaseDataSource(await gh.getAsync<_i361.Dio>()),
  );
  gh.lazySingletonAsync<_i675.CommonDataSource>(
    () async => _i675.CommonDataSource(await gh.getAsync<_i361.Dio>()),
  );
  gh.lazySingletonAsync<_i301.NewsDataSource>(
    () async => _i301.NewsDataSource(await gh.getAsync<_i361.Dio>()),
  );
  gh.lazySingletonAsync<_i287.DownloadDataSource>(
    () async => _i287.DownloadDataSource(await gh.getAsync<_i361.Dio>()),
  );
  gh.lazySingletonAsync<_i976.NewsletterDataSource>(
    () async => _i976.NewsletterDataSource(await gh.getAsync<_i361.Dio>()),
  );
  gh.lazySingletonAsync<_i372.AccountDataSource>(
    () async => _i372.AccountDataSource(await gh.getAsync<_i361.Dio>()),
  );
  gh.lazySingletonAsync<_i911.ShoppingCartInfoDataSource>(
    () async =>
        _i911.ShoppingCartInfoDataSource(await gh.getAsync<_i361.Dio>()),
  );
  gh.lazySingletonAsync<_i290.ShoppingCartDataSource>(
    () async => _i290.ShoppingCartDataSource(await gh.getAsync<_i361.Dio>()),
  );
  gh.lazySingletonAsync<_i809.CountryDataSource>(
    () async => _i809.CountryDataSource(await gh.getAsync<_i361.Dio>()),
  );
  gh.lazySingletonAsync<_i181.VendorDataSource>(
    () async => _i181.VendorDataSource(await gh.getAsync<_i361.Dio>()),
  );
  gh.lazySingletonAsync<_i207.WishlistDataSource>(
    () async => _i207.WishlistDataSource(await gh.getAsync<_i361.Dio>()),
  );
  gh.lazySingletonAsync<_i774.ProductRepository>(
    () async => _i774.ProductRepository(
      await gh.getAsync<_i520.ProductDataSource>(),
      await gh.getAsync<_i107.RepositoryDecorator>(),
      gh<_i694.EventBus>(),
    ),
  );
  gh.lazySingletonAsync<_i787.DownloadRepository>(
    () async => _i787.DownloadRepository(
      await gh.getAsync<_i287.DownloadDataSource>(),
      await gh.getAsync<_i107.RepositoryDecorator>(),
      gh<_i694.EventBus>(),
    ),
  );
  gh.lazySingletonAsync<_i722.ShoppingCartRepository>(
    () async => _i722.ShoppingCartRepository(
      await gh.getAsync<_i290.ShoppingCartDataSource>(),
      await gh.getAsync<_i107.RepositoryDecorator>(),
      gh<_i694.EventBus>(),
    ),
  );
  gh.lazySingletonAsync<_i512.KnowledgebaseRepository>(
    () async => _i512.KnowledgebaseRepository(
      await gh.getAsync<_i942.KnowledgebaseDataSource>(),
      await gh.getAsync<_i107.RepositoryDecorator>(),
      gh<_i694.EventBus>(),
    ),
  );
  gh.lazySingletonAsync<_i743.ActionCartRepository>(
    () async => _i743.ActionCartRepository(
      await gh.getAsync<_i133.ActionCartDataSource>(),
      await gh.getAsync<_i107.RepositoryDecorator>(),
      gh<_i694.EventBus>(),
    ),
  );
  gh.lazySingletonAsync<_i840.VendorRepository>(
    () async => _i840.VendorRepository(
      await gh.getAsync<_i181.VendorDataSource>(),
      await gh.getAsync<_i107.RepositoryDecorator>(),
      gh<_i694.EventBus>(),
    ),
  );
  gh.lazySingletonAsync<_i1003.CustomCacheManager>(
    () async => serviceModule.provideCustomCacheManager(
      await gh.getAsync<_i1028.DioFileService>(),
    ),
  );
  gh.lazySingletonAsync<_i76.ComponentRepository>(
    () async => _i76.ComponentRepository(
      await gh.getAsync<_i288.ComponentDataSource>(),
      await gh.getAsync<_i107.RepositoryDecorator>(),
      gh<_i694.EventBus>(),
    ),
  );
  gh.lazySingletonAsync<_i750.OrderRepository>(
    () async => _i750.OrderRepository(
      await gh.getAsync<_i89.OrderDataSource>(),
      await gh.getAsync<_i107.RepositoryDecorator>(),
      gh<_i694.EventBus>(),
    ),
  );
  gh.lazySingletonAsync<_i1043.CourseRepository>(
    () async => _i1043.CourseRepository(
      await gh.getAsync<_i193.CourseDataSource>(),
      await gh.getAsync<_i107.RepositoryDecorator>(),
      gh<_i694.EventBus>(),
    ),
  );
  gh.lazySingletonAsync<_i1000.AccountRepository>(
    () async => _i1000.AccountRepository(
      await gh.getAsync<_i372.AccountDataSource>(),
      await gh.getAsync<_i107.RepositoryDecorator>(),
      gh<_i694.EventBus>(),
    ),
  );
  gh.lazySingletonAsync<_i1014.ShoppingCartInfoRepository>(
    () async => _i1014.ShoppingCartInfoRepository(
      await gh.getAsync<_i911.ShoppingCartInfoDataSource>(),
      await gh.getAsync<_i107.RepositoryDecorator>(),
      gh<_i694.EventBus>(),
    ),
  );
  gh.lazySingletonAsync<_i653.ContactRepository>(
    () async => _i653.ContactRepository(
      await gh.getAsync<_i532.ContactDataSource>(),
      await gh.getAsync<_i107.RepositoryDecorator>(),
      gh<_i694.EventBus>(),
    ),
  );
  gh.singletonAsync<_i228.DeeplinkService>(
    () async => _i228.DeeplinkService.create(
      await gh.getAsync<_i305.AuthService>(),
      await gh.getAsync<_i361.Dio>(),
    ),
    dispose: (i) => i.dispose(),
  );
  gh.lazySingletonAsync<_i525.CountryRepository>(
    () async => _i525.CountryRepository(
      await gh.getAsync<_i809.CountryDataSource>(),
      await gh.getAsync<_i107.RepositoryDecorator>(),
      gh<_i694.EventBus>(),
    ),
  );
  gh.lazySingletonAsync<_i85.NewsRepository>(
    () async => _i85.NewsRepository(
      await gh.getAsync<_i301.NewsDataSource>(),
      await gh.getAsync<_i107.RepositoryDecorator>(),
      gh<_i694.EventBus>(),
    ),
  );
  gh.lazySingletonAsync<_i643.NewsletterRepository>(
    () async => _i643.NewsletterRepository(
      await gh.getAsync<_i976.NewsletterDataSource>(),
      await gh.getAsync<_i107.RepositoryDecorator>(),
      gh<_i694.EventBus>(),
    ),
  );
  gh.lazySingletonAsync<_i959.MerchandiseReturnRepository>(
    () async => _i959.MerchandiseReturnRepository(
      await gh.getAsync<_i325.MerchandiseReturnDataSource>(),
      await gh.getAsync<_i107.RepositoryDecorator>(),
      gh<_i694.EventBus>(),
    ),
  );
  gh.lazySingletonAsync<_i677.BlogRepository>(
    () async => _i677.BlogRepository(
      await gh.getAsync<_i970.BlogDataSource>(),
      await gh.getAsync<_i107.RepositoryDecorator>(),
      gh<_i694.EventBus>(),
    ),
  );
  gh.factoryAsync<_i87.NotificationRepository>(
    () async => _i87.NotificationRepository.create(
      await gh.getAsync<_i361.Dio>(),
      await gh.getAsync<_i881.CachingAspect>(),
      await gh.getAsync<_i107.RepositoryDecorator>(),
      gh<_i694.EventBus>(),
    ),
  );
  gh.lazySingletonAsync<_i387.PageRepository>(
    () async => _i387.PageRepository(
      await gh.getAsync<_i203.PageDataSource>(),
      await gh.getAsync<_i107.RepositoryDecorator>(),
      gh<_i694.EventBus>(),
    ),
  );
  gh.lazySingletonAsync<_i1022.CommonRepository>(
    () async => _i1022.CommonRepository(
      await gh.getAsync<_i675.CommonDataSource>(),
      await gh.getAsync<_i107.RepositoryDecorator>(),
      gh<_i694.EventBus>(),
    ),
  );
  gh.lazySingletonAsync<_i261.WishlistRepository>(
    () async => _i261.WishlistRepository(
      await gh.getAsync<_i207.WishlistDataSource>(),
      await gh.getAsync<_i107.RepositoryDecorator>(),
      gh<_i694.EventBus>(),
    ),
  );
  gh.lazySingletonAsync<_i928.FCMService>(
    () async => _i928.FCMService(
      await gh.getAsync<_i76.ComponentRepository>(),
      gh<_i558.FlutterSecureStorage>(),
      await gh.getAsync<_i361.Dio>(),
      await gh.getAsync<_i1059.CacheFreshnessService>(),
    ),
  );
  gh.lazySingletonAsync<_i998.CheckoutRepository>(
    () async => _i998.CheckoutRepository(
      await gh.getAsync<_i792.CheckoutDataSource>(),
      await gh.getAsync<_i107.RepositoryDecorator>(),
      gh<_i694.EventBus>(),
    ),
  );
  gh.lazySingletonAsync<_i545.NotificationCheckerService>(
    () async => _i545.NotificationCheckerService(
      await gh.getAsync<_i87.NotificationRepository>(),
      await gh.getAsync<_i619.NotificationStorageRepository>(),
      gh<_i991.BackgroundTaskQueue>(),
    ),
    dispose: (i) => i.dispose(),
  );
  gh.lazySingletonAsync<_i117.OutOfStockSubscriptionRepository>(
    () async => _i117.OutOfStockSubscriptionRepository(
      await gh.getAsync<_i430.OutOfStockSubscriptionDataSource>(),
      await gh.getAsync<_i107.RepositoryDecorator>(),
      gh<_i694.EventBus>(),
    ),
  );
  gh.lazySingletonAsync<_i22.HomeRepository>(
    () async => _i22.HomeRepository(
      await gh.getAsync<_i632.HomeDataSource>(),
      await gh.getAsync<_i107.RepositoryDecorator>(),
      gh<_i694.EventBus>(),
    ),
  );
  gh.lazySingletonAsync<_i449.CatalogRepository>(
    () async => _i449.CatalogRepository(
      await gh.getAsync<_i692.CatalogDataSource>(),
      await gh.getAsync<_i107.RepositoryDecorator>(),
      gh<_i694.EventBus>(),
    ),
  );
  return getIt;
}

class _$DioModule extends _i983.DioModule {}

class _$ServiceModule extends _i681.ServiceModule {}
