import 'core/config/tenant_firebase_identity.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:store_user_app/core/config/local_demo.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_api_availability/google_api_availability.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/config/app_config.dart';
import 'package:store_user_app/core/config/theme/theme.dart';
import 'package:store_user_app/core/constants/app_constants.dart';
import 'package:store_user_app/core/data/events/event_bus.dart';
import 'package:store_user_app/core/navigation/app_paths.dart';
import 'package:store_user_app/core/navigation/app_router.dart';
import 'package:store_user_app/core/services/Security/connectivity_monitor.dart';
import 'package:store_user_app/core/services/analytics/analytics_service.dart';
import 'package:store_user_app/core/services/auth/app_tokens_refresh_event.dart';
import 'package:store_user_app/core/services/auth/auth_service.dart';
import 'package:store_user_app/core/services/crashlytics/crashlytics_service.dart';
import 'package:store_user_app/core/services/deeplink/deeplink_service.dart';
import 'package:store_user_app/core/services/fcm_service.dart';
import 'package:store_user_app/core/services/theme/theme_controller.dart';
import 'package:store_user_app/core/utils/provider/app_provider_observer.dart';
import 'package:store_user_app/domain/usecases/notification/notification_checker_service.dart';
/*********DO NOT DELETE THIS LINE ***********/

import 'core/config/environment_config.dart';
import 'core/data/events/entity_event.dart';
import 'core/di/injection_container.dart';
import 'core/services/Security/device_security_service.dart';
import 'core/services/logger/logger_service.dart';
import 'presentation/widgets/layout/view/cannectivity_aware_widget.dart';

Future<void> main() async {
  var firebaseIdentityVerified = false;
  // Catch any errors during initialization to prevent crash dumps exposing sensitive data
  await runZonedGuarded(
        () async {
      WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
      FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

      // Firebase Core'u başlat (Analytics ve Crashlytics için gerekli)
      LocalDemo.validate();
      if (!LocalDemo.enabled) {
        final firebase = await Firebase.initializeApp();
        const tenantId = String.fromEnvironment('TENANT_ID');
        if (tenantId.isNotEmpty) {
          final android = Platform.isAndroid;
          final package = await PackageInfo.fromPlatform();
          TenantFirebaseIdentity(
            tenantId: tenantId,
            packageName: android
                ? const String.fromEnvironment('PACKAGE_NAME_ANDROID')
                : const String.fromEnvironment('PACKAGE_NAME_IOS'),
            projectId: const String.fromEnvironment('FIREBASE_PROJECT_ID'),
            projectNumber: const String.fromEnvironment('FIREBASE_PROJECT_NUMBER'),
            appId: android
                ? const String.fromEnvironment('FIREBASE_ANDROID_APP_ID')
                : const String.fromEnvironment('FIREBASE_IOS_APP_ID'),
          ).verify(
            nativePackageName: package.packageName,
            nativeProjectId: firebase.options.projectId,
            nativeProjectNumber: firebase.options.messagingSenderId,
            nativeAppId: firebase.options.appId,
            platform: android ? 'android' : 'ios',
          );
        }
      }

      firebaseIdentityVerified = !LocalDemo.enabled && Firebase.apps.isNotEmpty;

      // Security checks before proceeding with app initialization
      if (!LocalDemo.enabled && !await DeviceSecurityService.isDeviceSecure()) {
        await _showSecurityAlert();
        return;
      }

      // Setup secure environment variables
      await EnvironmentConfig.setupEnv();

      // Initialize encrypted storage
      // await _initializeSecureStorage();

      // Configure dependencies with proper lifecycle management
      await _initializeDependencies();

      // Preload essential data with proper error handling
      await _preloadEssentialData();

      if (!LocalDemo.enabled && Platform.isAndroid) {
        if (kDebugMode) {
          await (await getIt.getAsync<FCMService>()).initialize();
        } else {
          var googleApiCheck = await GoogleApiAvailability.instance
              .checkGooglePlayServicesAvailability(false);

          if (googleApiCheck == GooglePlayServicesAvailability.success ||
              googleApiCheck ==
                  GooglePlayServicesAvailability.serviceUpdating ||
              googleApiCheck ==
                  GooglePlayServicesAvailability.serviceVersionUpdateRequired) {
            await (await getIt.getAsync<FCMService>()).initialize();
          }
        }
      } else if (!LocalDemo.enabled) {
        await (await getIt.getAsync<FCMService>()).initialize();
      }

      runApp(
        ProviderScope(
          key: myAppKey,
          observers: kReleaseMode ? [] : [AppProviderObserver()],
          child: const MyApp(),
        ),
      );
    },
        (error, stackTrace) {
      // Send error to monitoring service without sensitive data
      LoggerService.error('App initialization error', error, stackTrace);
      // Hata bilgisini Crashlytics'e gönder
      if (!kDebugMode && firebaseIdentityVerified) {
        FirebaseCrashlytics.instance.recordError(
          error,
          stackTrace,
          fatal: true,
        );
      }
      FlutterNativeSplash.remove();
      // Show generic error message to user
      _showGenericErrorDialog();
    },
  );
}
//
// Future<void> _initializeSecureStorage() async {
//   // Initialize Hive with encryption
//   await Hive.initFlutter();
//
//   // Generate or retrieve encryption key securely
//   final encryptionKey = await _getOrCreateEncryptionKey();
//
//   // Register encrypted adapters
//   HiveAesCipher cipher = HiveAesCipher(encryptionKey);
//   await Hive.openBox<dynamic>('secureCache', encryptionCipher: cipher);
// }
//
// Future<Uint8List> _getOrCreateEncryptionKey() async {
//   var  existingKey = await FlutterKeychain.get(key: 'encryptionKey');
//
//   if (existingKey == null) {
//     // Generate a secure random key
//     final key = Uint8List(32);
//     final secureRandom = Random.secure();
//     for (var i = 0; i < key.length; i++) {
//       key[i] = secureRandom.nextInt(256);
//     }
//
//     // Store securely
//     await secureStorage.write(
//       key: 'encryptionKey',
//       value: base64Encode(key),
//     );
//
//     return key;
//   }
//
//   return base64Decode(existingKey);
// }

Future<void> _initializeDependencies() async {
  await Hive.initFlutter();

  // Reset only in development mode, not in production
  if (kDebugMode) {
    await getIt.reset();
  }

  await configureDependencies();

  // Verify certificate fingerprints for API communication
  // await _setupCertificatePinning();
}
//
// Future<void> _setupCertificatePinning() async {
//   final Dio dio = await getIt.getAsync<Dio>();
//
//   // Add certificate pinning interceptor
//   dio.interceptors.add(CertificatePinningInterceptor(
//     allowedSHAFingerprints: [
//       // Add your API server certificate fingerprints here
//       // Example: 'sha256/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA='
//     ],
//   ));
// }

Future<void> _preloadEssentialData() async {
  // Attempt to get auth token only once with proper timeout and retry strategy
  final connectivity = await Connectivity().checkConnectivity();
  if (!connectivity.contains(ConnectivityResult.none)) {
    try {
      await getIt<AuthService>().getAccessToken().timeout(
        const Duration(seconds: 5),
        onTimeout: () => null,
      );
    } catch (e) {
      // Proceed with app initialization even if token retrieval fails
      LoggerService.warning('Failed to retrieve auth token: $e');
    }
  }
}

void _showGenericErrorDialog() {
  // Show a generic error message that doesn't expose sensitive information
}

Future<void> _showSecurityAlert() async {
  // Show an alert that the device has security issues
}

class MyApp extends StatefulHookConsumerWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  final _eventBus = getIt<EventBus>();
  late final ThemeController _themeController;
  final ValueNotifier<AuthTokens?> _authTokens = ValueNotifier(null);
  ThemeMode _themeMode = ThemeMode.system;
  StreamSubscription? _subscription;
  late final ConnectivityMonitor _connectivityMonitor;
  FirebaseAnalytics? get _analytics => LocalDemo.enabled ? null : FirebaseAnalytics.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Initialize app state asynchronously
      _initializeAppState();
    });
  }

  Future<void> _initializeAppState() async {
    try {
      // Monitor app lifecycle changes
      _connectivityMonitor = getIt<ConnectivityMonitor>();
      _connectivityMonitor.startMonitoring();

      _themeController = await getIt.getAsync<ThemeController>();
      _updateThemeMode(
        _themeController.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      );

      // Load auth tokens
      final tokens =
      await (await getIt.getAsync<AuthService>()).getAccessToken();

      // Analytics için kullanıcı ID ayarla (eğer giriş yapılmışsa)
      if (tokens != null && tokens.email != null) {
        await getIt<AnalyticsService>().setUserId(tokens.email!);
      }

      // Subscribe to relevant events with proper error handling
      _subscription = _eventBus.stream.listen(
        _handleEvents,
        onError: (error) => LoggerService.error('Event stream error', error),
      );

      await getIt.isReady<NotificationCheckerService>();
      _authTokens.value = tokens;

      // Başlangıç ekranını kaydet
      await _analytics?.logAppOpen();
      await _analytics?.logScreenView(screenName: 'Splash');

      FlutterNativeSplash.remove();

      if (mounted) setState(() {});
    } catch (e, stackTrace) {
      LoggerService.error('App state initialization error', e, stackTrace);
      // Hatayı Crashlytics'e rapor et
      if (!kDebugMode && !LocalDemo.enabled && Firebase.apps.isNotEmpty) {
        FirebaseCrashlytics.instance.recordError(e, stackTrace, fatal: false);
      }
      // Handle initialization error gracefully
      _showInitializationError();
    }
  }

  void _handleEvents(EntityEvent event) {
    if (!mounted) return;

    if (event.entity is ThemeMode) {
      _updateThemeMode(event.entity);
    } else if (event is AuthTokensRefreshEvent) {
      // Update auth tokens only if meaningful change occurred
      if (event.oldTokens?.email != event.entity.email ||
          event.oldTokens?.guestId != event.entity.guestId) {
        _authTokens.value = event.entity;
        unawaited(_refreshNotificationRegistration());

        // Kullanıcı giriş-çıkış durumunu Analytics'e bildir
        if (event.entity.email != null && event.oldTokens?.email == null) {
          // Kullanıcı giriş yaptı
          getIt<AnalyticsService>().logLogin();
          getIt<AnalyticsService>().setUserId(event.entity.email!);
          getIt<CrashlyticsService>().setUserId(event.entity.email!);
        } else if (event.entity.email == null &&
            event.oldTokens?.email != null) {
          // Kullanıcı çıkış yaptı
          getIt<AnalyticsService>().resetUser();
          getIt<CrashlyticsService>().resetUser();
        }
      }
    }
  }

  void _updateThemeMode(ThemeMode mode) {
    setState(() => _themeMode = mode);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
      // Check token validity when app comes to foreground
        unawaited(_refreshForegroundState());
        break;
      case AppLifecycleState.paused:
      // Secure sensitive data when app goes to background
        _secureAppData();
        break;
      default:
        break;
    }
  }

  Future<void> _refreshForegroundState() async {
    await _refreshAuthTokenIfNeeded();
    await _refreshNotificationRegistration();
  }

  Future<void> _refreshNotificationRegistration() async {
    if (LocalDemo.enabled) return;
    try {
      await (await getIt.getAsync<FCMService>()).initialize();
    } catch (_) {
      LoggerService.warning('Notification registration will be retried');
    }
  }

  Future<void> _refreshAuthTokenIfNeeded() async {
    try {
      final tokens = _authTokens.value;
      if (tokens != null && tokens.shouldRefresh) {
        await getIt<AuthService>().refreshToken();
      }
    } catch (e) {
      // Handle silently, will retry on next API call
    }
  }

  void _secureAppData() {
    // Implement any additional security measures when app goes to background
  }

  void _showInitializationError() {
    // Show generic initialization error to user
  }

  Widget _buildBackButtonHandler(BuildContext context, Widget? child) {
    // Import our custom back button handler
    // We'll add this when the app is initialized so it doesn't interfere with splash screen
    if (_authTokens.value == null) {
      return child ?? const SizedBox.shrink();
    }

    // Use the AppBackButtonHandler
    return child ?? const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    // Show loading indicator until auth state is determined
    if (_authTokens.value == null) {
      return MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return Container(
      color: context.theme.appBarTheme.backgroundColor,
      child: MaterialApp.router(
        key: const ValueKey('MaterialApp'),
        title: AppConfig.instance.appTitle,
        routerConfig: getIt.get<AppRouter>().config(
          navigatorObservers:
              () => [
            if (!LocalDemo.enabled) FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
          ],
          deepLinkBuilder: (uri) async {
            var deeplinkService = await getIt.getAsync<DeeplinkService>();
            RemoteMessage? initialMessage =
            LocalDemo.enabled ? null : await (await getIt.getAsync<FCMService>()).getInitialMessage();

            // Uygulamaya bildirimden açıldıysa, bildirim verilerine göre yönlendirme yap
            if (initialMessage != null) {
              var data = initialMessage.data;
              if (data.isNotEmpty) {
                // Local path direkt olarak varsa kullan
                if (data['local_path'] != null) {
                  return DeepLink.path(data['local_path']);
                }

                // Action link varsa işle
                var actionLink = data['action_link'];
                if (actionLink != null) {
                  var uri = Uri.tryParse(actionLink);
                  if (uri != null) {
                    return DeepLink.path(
                      (await deeplinkService.handleIncomingLink(uri)) ??
                          AppPaths.homeIndex(),
                    );
                  }
                }

                // Android click_action varsa işle
                if (initialMessage.notification?.android?.clickAction != null) {
                  var uri = Uri.tryParse(
                    initialMessage.notification!.android!.clickAction!,
                  );
                  if (uri != null) {
                    return DeepLink.path(
                      (await deeplinkService.handleIncomingLink(uri)) ??
                          AppPaths.homeIndex(),
                    );
                  }
                }
              }
            }

            // Arkaplan bildirimlerinden gelmiş yerel bildirimler için kontrolü yap
            var initialNotification =
            await FlutterLocalNotificationsPlugin()
                .getNotificationAppLaunchDetails();

            if (initialNotification != null &&
                initialNotification
                    .notificationResponse
                    ?.notificationResponseType !=
                    null &&
                initialNotification.didNotificationLaunchApp &&
                initialNotification.notificationResponse?.payload != null) {
              try {
                var payload = jsonDecode(
                  initialNotification.notificationResponse!.payload!,
                );

                // Local path varsa kullan
                if (payload['local_path'] != null) {
                  return DeepLink.path(
                    payload['local_path'],
                    includePrefixMatches: true,
                  );
                }

                // Action link varsa işle
                if (payload['action_link'] != null) {
                  var uri = Uri.tryParse(payload['action_link']);
                  if (uri != null) {
                    return DeepLink.path(
                      (await deeplinkService.handleIncomingLink(uri)) ??
                          AppPaths.homeIndex(),
                      includePrefixMatches: true,
                    );
                  }
                }
              } catch (e) {
                print('Error handling initial notification: $e');
              }
            }
            return DeepLink.path(
              (await deeplinkService.handleIncomingLink(uri.uri)) ??
                  AppPaths.welcome(),
            );
          },
        ),
        themeMode: _themeMode,
        darkTheme: AppTheme.foodDarkTheme,
        theme: AppTheme.foodLightTheme,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('tr', 'TR'), // Türkçe
          Locale('en', 'US'), // İngilizce
        ],
        locale: const Locale('tr', 'TR'), // Varsayılan olarak Türkçe
        builder: (context, child) {
          // Add global error handling UI layer and back button handler
          return Container(
            color: context.theme.appBarTheme.backgroundColor,
            child: SafeArea(
              child: ConnectivityAwareWidget(
                child: _buildBackButtonHandler(context, child),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _authTokens.dispose();
    _connectivityMonitor.stopMonitoring();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
