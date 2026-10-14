import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/constants/colors.dart';

class AppTheme {
  static const double letterSpacing = 0.3;
  static const double letterHeight = 1.5;

  static var fontFamily = 'Urbanist';

  static final ThemeData foodLightTheme = ThemeData(
    splashColor: Colors.transparent, // Removes the splash color
    highlightColor: Colors.transparent, // Removes the highlight color
    brightness: Brightness.light,
    scaffoldBackgroundColor: whiteColor,
    primaryColor: colorPrimary,
    primaryColorDark: colorPrimary,
    hoverColor: Colors.white54,
    dividerColor: viewLineColor,
    fontFamily: fontFamily,
    fontFamilyFallback: ['NotoSans', 'Arial'],
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: whiteColor,
    ),
    appBarTheme: const AppBarTheme(
      actionsIconTheme: IconThemeData(color: Colors.black),
      iconTheme: IconThemeData(color: Colors.black),
      backgroundColor: whiteColor,
      titleTextStyle: TextStyle(color: Colors.black),
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Colors.black,
      selectionHandleColor: Colors.black,
      selectionColor: Colors.green,
    ),
    colorScheme: const ColorScheme.light(primary: Colors.white),
    cardTheme: const CardThemeData(color: Colors.white),
    cardColor: cardLightColor,
    iconTheme: const IconThemeData(color: Colors.black),
    bottomSheetTheme: const BottomSheetThemeData(backgroundColor: whiteColor),
    primaryTextTheme: TextTheme(
      titleLarge: TextStyle(
        color: textColor,
        letterSpacing: letterSpacing,
        height: letterHeight,
        fontFamily: fontFamily,
      ),
      labelSmall: TextStyle(
        fontFamily: fontFamily,
        color: textColor,
        letterSpacing: letterSpacing,
        height: letterHeight,
      ),
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontSize: 48.0,
        color: textColor,
        fontFamily: fontFamily,
      ),
      displayMedium: TextStyle(
        fontSize: 40.0,
        color: textColor,
        fontFamily: fontFamily,
      ),
      displaySmall: TextStyle(
        fontSize: 32.0,
        color: textColor,
        fontFamily: fontFamily,
      ),
      headlineMedium: TextStyle(
        fontSize: 24.0,
        fontFamily: fontFamily,
        color: textColor,
      ),
      headlineSmall: TextStyle(
        fontSize: 20.0,
        color: textColor,
        fontFamily: fontFamily,
      ),
      titleLarge: TextStyle(
        fontSize: 18.0,
        color: textColor,
        fontFamily: fontFamily,
      ),
      bodyLarge: TextStyle(
        fontSize: 16.0,
        color: textColor,
        fontFamily: fontFamily,
      ),
      bodyMedium: TextStyle(
        fontSize: 14.0,
        color: textColor,
        fontFamily: fontFamily,
      ),
      bodySmall: TextStyle(
        fontSize: 12.0,
        color: textColor,
        fontFamily: fontFamily,
      ),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    popupMenuTheme: const PopupMenuThemeData(color: whiteColor),
  ).copyWith(
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.linux: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.macOS: OpenUpwardsPageTransitionsBuilder(),
      },
    ),
  );

  static final ThemeData foodDarkTheme = ThemeData(
    splashColor: Colors.transparent, // Removes the splash color
    highlightColor: Colors.transparent, // Removes the highlight color
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkPrimary,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: darkPrimary,
    ),
    fontFamilyFallback: ['NotoSans', 'Arial'],
    appBarTheme: const AppBarTheme(
      actionsIconTheme: IconThemeData(color: whiteColor),
      titleTextStyle: TextStyle(color: Colors.white),
      backgroundColor: darkPrimary,
      iconTheme: IconThemeData(color: whiteColor),
    ),
    primaryColor: darkPrimary,
    dividerColor: const Color(0xFFDADADA).withValues(alpha: 0.3),
    primaryColorDark: darkPrimary,
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Colors.white,
      selectionColor: Colors.green,
      selectionHandleColor: Colors.white,
    ),
    hoverColor: Colors.black12,
    fontFamily: fontFamily,
    bottomSheetTheme: const BottomSheetThemeData(backgroundColor: darkPrimary),
    primaryTextTheme: TextTheme(
      titleLarge: TextStyle(
        color: Colors.white,
        letterSpacing: letterSpacing,
        fontFamily: fontFamily,
        height: letterHeight,
      ),
      labelSmall: TextStyle(
        color: Colors.white,
        fontFamily: fontFamily,
        letterSpacing: letterSpacing,
        height: letterHeight,
      ),
    ),
    cardTheme: const CardThemeData(color: darkPrimary),
    cardColor: cardDark,
    iconTheme: const IconThemeData(color: whiteColor),
    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontSize: 48.0,
        color: Colors.white,
        fontFamily: fontFamily,
      ),
      displayMedium: TextStyle(
        fontSize: 40.0,
        color: Colors.white,
        fontFamily: fontFamily,
      ),
      displaySmall: TextStyle(
        fontSize: 32.0,
        color: Colors.white,
        fontFamily: fontFamily,
      ),
      headlineMedium: TextStyle(
        fontSize: 24.0,
        color: Colors.white,
        fontFamily: fontFamily,
      ),
      headlineSmall: TextStyle(
        fontSize: 20.0,
        color: Colors.white,
        fontFamily: fontFamily,
      ),
      titleLarge: TextStyle(
        fontSize: 18.0,
        color: Colors.white,
        fontFamily: fontFamily,
        // letterSpacing: 1.5
      ),
      bodyLarge: TextStyle(
        fontSize: 16.0,
        color: Colors.white,
        fontFamily: fontFamily,
      ),
      bodyMedium: TextStyle(
        fontSize: 14.0,
        color: Colors.white,
        fontFamily: fontFamily,
      ),
      bodySmall: TextStyle(
        fontSize: 12.0,
        color: Colors.white,
        fontFamily: fontFamily,
      ),
    ),
    popupMenuTheme: const PopupMenuThemeData(color: Colors.white),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    colorScheme: const ColorScheme.dark(
      primary: darkPrimary,
      onPrimary: cardDark,
    ).copyWith(secondary: whiteColor),
  ).copyWith(
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.linux: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.macOS: OpenUpwardsPageTransitionsBuilder(),
      },
    ),
  );
}
