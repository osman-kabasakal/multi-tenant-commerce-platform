import 'package:store_user_app/core/config/local_demo.dart';
import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:store_user_app/core/services/logger/logger_service.dart';

@lazySingleton
class CrashlyticsService {
  FirebaseCrashlytics? get _crashlytics => LocalDemo.enabled ? null : FirebaseCrashlytics.instance;

  CrashlyticsService();

  /// Firebase Crashlytics'i başlatır ve yapılandırır
  Future<void> initialize() async {
    if (LocalDemo.enabled) return;
    try {
      // Debug modunda crashlytics'i devre dışı bırak
      await _crashlytics?.setCrashlyticsCollectionEnabled(!kDebugMode);

      // Flutter hatalarını yakalamak için FlutterError'u yapılandır
      FlutterError.onError = (FlutterErrorDetails details) {
        if (kDebugMode || LocalDemo.enabled) {
          // Debug modunda konsola yazdır
          FlutterError.dumpErrorToConsole(details);
        } else {
          // Release modunda Crashlytics'e gönder
          _crashlytics?.recordFlutterFatalError(details);
        }
      };

      // Uygulamanın herhangi bir yerinde yakalanmamış hataları ele al
      PlatformDispatcher.instance.onError = (error, stack) {
        if (!kDebugMode) {
          _crashlytics?.recordError(error, stack, fatal: true);
        }
        return !kDebugMode && !LocalDemo.enabled;
      };

      LoggerService.info('Crashlytics başarıyla yapılandırıldı');
    } catch (e) {
      LoggerService.error('Crashlytics başlatma hatası', e);
    }
  }

  /// Manuel olarak hata kaydeder
  Future<void> recordError(
    dynamic exception,
    StackTrace stack, {
    bool fatal = false,
    Map<String, dynamic>? customKeys,
  }) async {
    try {
      if (customKeys != null) {
        await _setCustomKeys(customKeys);
      }

      await _crashlytics?.recordError(exception, stack, fatal: fatal);
    } catch (e) {
      LoggerService.error('Crashlytics hata kaydetme başarısız oldu', e);
    }
  }

  /// Crashlytics için özel öznitelikler ayarlar
  Future<void> _setCustomKeys(Map<String, dynamic> customKeys) async {
    try {
      for (final entry in customKeys.entries) {
        final key = entry.key;
        final value = entry.value;

        if (value is String) {
          await _crashlytics?.setCustomKey(key, value);
        } else if (value is bool) {
          await _crashlytics?.setCustomKey(key, value);
        } else if (value is int) {
          await _crashlytics?.setCustomKey(key, value);
        } else if (value is double) {
          await _crashlytics?.setCustomKey(key, value);
        } else {
          await _crashlytics?.setCustomKey(key, value.toString());
        }
      }
    } catch (e) {
      LoggerService.error('Crashlytics özel anahtar ayarlama hatası', e);
    }
  }

  /// Kullanıcı kimliğini ayarlar
  Future<void> setUserId(String userId) async {
    try {
      await _crashlytics?.setUserIdentifier(userId);
    } catch (e) {
      LoggerService.error('Crashlytics kullanıcı kimliği ayarlama hatası', e);
    }
  }

  /// Bir günlük mesajı kaydeder
  Future<void> log(String message) async {
    try {
      await _crashlytics?.log(message);
    } catch (e) {
      LoggerService.error('Crashlytics log kaydetme hatası', e);
    }
  }

  /// Test etmek için zorla bir çökme tetikler - SADECE DEBUG MODUNDA KULLANIN
  Future<void> forceCrash() async {
    if (kDebugMode || LocalDemo.enabled) {
      _crashlytics?.crash();
    } else {
      LoggerService.warning('forceCrash sadece debug modunda çalışır');
    }
  }

  /// Kullanıcıyla ilgili bilgileri temizler (oturum kapatıldığında)
  Future<void> resetUser() async {
    try {
      await _crashlytics?.setUserIdentifier('');
    } catch (e) {
      LoggerService.error('Crashlytics kullanıcı sıfırlama hatası', e);
    }
  }

  /// Uygulamanın çökmesine neden olabilecek yakalanmamış hataları ele almak için bir Zone kullanarak çalıştırılacak Future
  /// Bu, uygulamanın herhangi bir yerinde yakalanmamış hataları Crashlytics'e raporlar
  static R? runZonedWithCrashlytics<R>(R Function() body) {
    if (kDebugMode || LocalDemo.enabled) {
      return body();
    }

    return runZonedGuarded<R>(() => body(), (error, stackTrace) {
      _handleZoneError(error, stackTrace);
    });
  }

  /// Zone hatalarını ele alan yardımcı metot
  static void _handleZoneError(Object error, StackTrace stackTrace) {
    if (kDebugMode || LocalDemo.enabled) {
      print('Yakalanmamış hata: $error');
      print(stackTrace);
    } else {
      FirebaseCrashlytics.instance.recordError(error, stackTrace, fatal: true);
    }
  }
}
