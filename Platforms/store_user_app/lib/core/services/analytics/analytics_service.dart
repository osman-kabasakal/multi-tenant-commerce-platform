import 'package:store_user_app/core/config/local_demo.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:store_user_app/core/services/logger/logger_service.dart';

@lazySingleton
class AnalyticsService {
  FirebaseAnalytics? get _analytics => LocalDemo.enabled ? null : FirebaseAnalytics.instance;

  AnalyticsService();

  /// Firebase Analytics'i başlatır
  Future<void> initialize() async {
    try {
      await _analytics?.setAnalyticsCollectionEnabled(!kDebugMode);
    } catch (e) {
      LoggerService.error('Analytics başlatma hatası', e);
    }
  }

  /// Belirli bir etkinliği kaydeder
  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    try {
      await _analytics?.logEvent(name: name, parameters: parameters);
      if (kDebugMode || LocalDemo.enabled) {
        print('Analytics Event: $name, Parameters: $parameters');
      }
    } catch (e) {
      LoggerService.error('Event kaydetme hatası', e);
    }
  }

  /// Ekran görüntülemelerini kaydeder
  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    try {
      await _analytics?.logScreenView(
        screenName: screenName,
        screenClass: screenClass,
      );
    } catch (e) {
      LoggerService.error('Screen view kaydetme hatası', e);
    }
  }

  /// Arama eylemlerini kaydeder
  Future<void> logSearch({required String searchTerm}) async {
    try {
      await _analytics?.logSearch(searchTerm: searchTerm);
    } catch (e) {
      LoggerService.error('Search event kaydetme hatası', e);
    }
  }

  /// Alışveriş sepetine ürün ekleme işlemlerini kaydeder
  Future<void> logAddToCart({
    required String itemId,
    required String itemName,
    required String itemCategory,
    required int quantity,
    required double price,
  }) async {
    try {
      await _analytics?.logAddToCart(
        items: [
          AnalyticsEventItem(
            itemId: itemId,
            itemName: itemName,
            itemCategory: itemCategory,
            quantity: quantity,
            price: price,
          ),
        ],
      );
    } catch (e) {
      LoggerService.error('Add to cart event kaydetme hatası', e);
    }
  }

  /// Satın alma işlemlerini kaydeder
  Future<void> logPurchase({
    required String transactionId,
    required double value,
    required String currency,
    required List<AnalyticsEventItem> items,
  }) async {
    try {
      await _analytics?.logPurchase(
        transactionId: transactionId,
        currency: currency,
        value: value,
        items: items,
      );
    } catch (e) {
      LoggerService.error('Purchase event kaydetme hatası', e);
    }
  }

  /// Kullanıcı oturum açma işlemlerini kaydeder
  Future<void> logLogin({String? loginMethod}) async {
    try {
      await _analytics?.logLogin(loginMethod: loginMethod ?? 'email');
    } catch (e) {
      LoggerService.error('Login event kaydetme hatası', e);
    }
  }

  /// Kullanıcı kaydı işlemlerini kaydeder
  Future<void> logSignUp({String? signUpMethod}) async {
    try {
      await _analytics?.logSignUp(signUpMethod: signUpMethod ?? 'email');
    } catch (e) {
      LoggerService.error('Sign up event kaydetme hatası', e);
    }
  }

  /// Uygulama içi hatalar ve istisnalar için özel olay
  Future<void> logError({
    required String errorCode,
    required String errorMessage,
    StackTrace? stackTrace,
  }) async {
    try {
      await _analytics?.logEvent(
        name: 'app_error',
        parameters: {
          'error_code': errorCode,
          'error_message': errorMessage,
          'stack_trace': stackTrace?.toString() ?? 'No stack trace',
        },
      );
    } catch (e) {
      LoggerService.error('Error event kaydetme hatası', e);
    }
  }

  /// Kullanıcı ID'sini ayarlar (oturum açıldığında)
  Future<void> setUserId(String userId) async {
    try {
      await _analytics?.setUserId(id: userId);
    } catch (e) {
      LoggerService.error('User ID ayarlama hatası', e);
    }
  }

  /// Kullanıcı özelliklerini ayarlar
  Future<void> setUserProperty({
    required String name,
    required String value,
  }) async {
    try {
      await _analytics?.setUserProperty(name: name, value: value);
    } catch (e) {
      LoggerService.error('User property ayarlama hatası', e);
    }
  }

  /// Mevcut kullanıcı kimliğini ve özelliklerini temizler (oturum kapatıldığında)
  Future<void> resetUser() async {
    try {
      await _analytics?.setUserId(id: null);
    } catch (e) {
      LoggerService.error('User reset hatası', e);
    }
  }
}
