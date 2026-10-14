import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:store_user_app/core/data/events/common_event.dart';
import 'package:store_user_app/core/data/events/entity_event_handler.dart';

@Singleton()
class ThemeModeEvent extends EntityEventHandler<ThemeMode> {
  ThemeModeEvent(super.eventBus);

  @override
  Future<void> onEntityEvent(CommonEvent<ThemeMode> event) async {
    var darkMode = event.entity == ThemeMode.dark;
    if (event.entity == ThemeMode.system) {
      darkMode =
          PlatformDispatcher.instance.platformBrightness == Brightness.dark;
    }

    updateSystemUiOverlayStyle(darkMode);
  }

  void updateSystemUiOverlayStyle(bool darkMode) {
    SystemUiOverlayStyle systemUiOverlayStyle = darkMode
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

  @disposeMethod
  void singletonDispose() {
    super.dispose();
  }
}
