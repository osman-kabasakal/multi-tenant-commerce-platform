import 'package:store_user_app/core/config/local_demo.dart';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:store_user_app/core/data/events/event_bus.dart';
import 'package:store_user_app/core/network/dio/interceptors/antiforgery_cookie_interceptor.dart';
import 'package:store_user_app/core/network/dio/interceptors/auth_interceptor.dart';
import 'package:store_user_app/core/network/dio/interceptors/challenge_redirect_interceptor.dart';
import 'package:store_user_app/core/network/dio/interceptors/error_interceptor.dart';
import 'package:store_user_app/core/network/dio/interceptors/logging_interceptor.dart';
import 'package:store_user_app/core/network/dio/interceptors/queued_intercaptor.dart'
    as app_queued_interceptor;

import '../../network/dio/dio_queue_manager/dio_queue_manager.dart';
import '../../network/dio/interceptors/cachekey_tracker_interceptor.dart';
import '../../services/auth/auth_service.dart';
import '../../services/storage/cookie_secure_storage.dart';
import '../../config/app_config.dart';

@module
abstract class DioModule {
  @singleton
  CookieManager provideCookieManager(PersistCookieJar cookieJar) {
    return CookieManager(cookieJar);
  }

  @singleton
  CookieSecureStoreage provideCookieSecureStoreage(
    FlutterSecureStorage secureStorage,
  ) {
    return CookieSecureStoreage(secureStorage: secureStorage);
  }

  @singleton
  FlutterSecureStorage provideFlutterSecureStorage() {
    return const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
      iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
    );
  }

  @singleton
  Future<AuthService> provideAuthService(
    FlutterSecureStorage secureStoreage,
    EventBus eventBus,
    CookieManager cookieManager,
  ) async {
    final dio = _getBaseDio();
    dio.interceptors.addAll([
      cookieManager,
      ErrorInterceptor(),
      if (AppConfig.instance.enableLogging) LoggingInterceptor(),
    ]);
    var service = AuthService(secureStoreage, dio, eventBus);
    await service.init();
    return service;
  }

  @singleton
  AuthInterceptor provideAuthInterceptor(AuthService authService) {
    return AuthInterceptor(authService);
  }

  @singleton
  Future<CacheKeyTrackerInterceptor> provideCacheKeyTrackerInterceptor() async {
    return await CacheKeyTrackerInterceptor.create();
  }

  @singleton
  AntiforgeryCookieInterceptor provideAntiforgeryCookieInterceptor(
    PersistCookieJar cookieJar,
  ) {
    return AntiforgeryCookieInterceptor(cookieJar);
  }

  @singleton
  PersistCookieJar providePersistCookieJar(
    CookieSecureStoreage cookieSecureStoreage,
  ) {
    return PersistCookieJar(
      ignoreExpires: false,
      deleteHostCookiesWhenLoadFailed: false,
      storage: cookieSecureStoreage,
    );
  }

  @singleton
  Dio provideDio(
    CookieManager cookieManager,
    AuthInterceptor authInterceptor,
    CacheKeyTrackerInterceptor cacheKeyTrackerInterceptor,
    AntiforgeryCookieInterceptor antiforgeryCookieInterceptor,
  ) {
    final dio = _getBaseDio();
    dio.interceptors.addAll([
      cacheKeyTrackerInterceptor,
      // app_queued_interceptor.QueuedInterceptor(
      // DioQueueManager(
      //   _getBaseDio()
      //     ..interceptors.addAll([
      //     ]),
      // ),
      // ),
      cookieManager, // CookieManager must come before AntiforgeryCookieInterceptor
      antiforgeryCookieInterceptor, // AntiforgeryCookieInterceptor will override Cookie headers
      ChallengeRedirectInterceptor(),
      authInterceptor,
      ErrorInterceptor(),
      if (AppConfig.instance.enableLogging) LoggingInterceptor(),
    ]);
    return dio;
  }

  @singleton
  FileServiceDio provideSignalRDio(
    CookieManager cookieManager,
    AuthInterceptor authInterceptor,
    CacheKeyTrackerInterceptor cacheKeyTrackerInterceptor,
    AntiforgeryCookieInterceptor antiforgeryCookieInterceptor,
  ) {
    final dio = _getBaseDio();
    dio.interceptors.addAll([
      cookieManager, // CookieManager must come before AntiforgeryCookieInterceptor
      antiforgeryCookieInterceptor, // AntiforgeryCookieInterceptor will override Cookie headers
      authInterceptor,
      ErrorInterceptor(),
      if (AppConfig.instance.enableLogging) LoggingInterceptor(),
    ]);
    return FileServiceDio(dio);
  }

  Dio _getBaseDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.instance.apiBaseUrl,
        receiveDataWhenStatusError: true,
        followRedirects: false,
        connectTimeout: const Duration(minutes: 30),
        receiveTimeout: const Duration(minutes: 30),
        sendTimeout: const Duration(minutes: 30),
        contentType: ContentType.json.toString(),
        headers: {
          'X-Response-View': 'Json',
          'Accept': 'application/json',
          if (LocalDemo.enabled && LocalDemo.tenantHost.isNotEmpty)
            'Host': LocalDemo.tenantHost,
        },
        responseType: ResponseType.json,
        validateStatus: (status) {
          return status == 200 || // OK
              status == 201 || // Created
              status == 301 || // Moved Permanently
              status == 302 || // Found (Temporary Redirect)
              status == 303 || // See Other
              status == 307 || // Temporary Redirect
              status ==
                  308 // Permanent Redirect
                  ||
              status == 401;
        },
      ),
    );

    return dio;
  }
}

class SignalRDioClient {
  final Dio client;

  SignalRDioClient(this.client);
}

class FileServiceDio {
  final Dio client;

  FileServiceDio(this.client);
}
