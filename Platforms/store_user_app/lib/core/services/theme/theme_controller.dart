import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:store_user_app/core/cache/cache_manager.dart';
import 'package:store_user_app/core/data/events/entity_updated_event.dart';
import 'package:store_user_app/core/data/events/event_bus.dart';

@LazySingleton()
class ThemeController {
  bool isDarkMode;
  final CacheManager remoteCache;
  final EventBus eventBus;
  static const String cacheKey = 'isDarkMode';
  ThemeController(this.remoteCache, this.eventBus, {required this.isDarkMode}) {
    updateSystemUiOverlayStyle();
    PlatformDispatcher.instance.onPlatformBrightnessChanged = () {
      var brightness = PlatformDispatcher.instance.platformBrightness;
      isDarkMode = false;
      if (isDarkMode != (brightness == Brightness.dark)) {
        // isDarkMode = brightness == Brightness.dark;
        setTheme(isDarkMode);
      }
    };
  }

  @factoryMethod
  static Future<ThemeController> loadTheme(
    CacheManager cacheBase,
    EventBus eventBus,
  ) async {
    var value = await cacheBase.getAsync<bool>(cacheKey, () async => null);
    if (value != null) {
      //dark mode disabled
      return ThemeController(cacheBase, eventBus, isDarkMode: false);
    }
    var brightness = PlatformDispatcher.instance.platformBrightness;
    var isDarkMode = brightness == Brightness.dark;
    return ThemeController(cacheBase, eventBus, isDarkMode: false);
  }

  void toggleTheme() {
    // _isDarkMode = !_isDarkMode;
  }

  Future setTheme(bool? isDark) async {
    var cachedValue = await remoteCache.getAsync<bool>(
      cacheKey,
      () async => null,
    );
    var oldValue =
        cachedValue == null
            ? ThemeMode.system
            : cachedValue
            ? ThemeMode.dark
            : ThemeMode.light;
    if (isDark == null) {
      await remoteCache.removeAsync(cacheKey);
      eventBus.publish(
        EntityUpdatedEvent(entity: ThemeMode.light, oldEntity: oldValue),
      );
      return;
    }
    await remoteCache.setAsync<bool>(cacheKey, () async => isDark);
    eventBus.publish(
      EntityUpdatedEvent(entity: ThemeMode.light, oldEntity: oldValue),
    );
  }

  void updateSystemUiOverlayStyle() {
    SystemUiOverlayStyle systemUiOverlayStyle =
        isDarkMode
            ? SystemUiOverlayStyle.dark.copyWith(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.light,
              statusBarBrightness: Brightness.dark,
            )
            : SystemUiOverlayStyle.light.copyWith(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness: Brightness.light,
            );

    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }

  void dispose() {}
}
