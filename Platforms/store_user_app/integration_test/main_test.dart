import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:store_user_app/core/constants/strings.dart';
import 'package:store_user_app/presentation/screens/onboarding/view/walk_through_screen.dart';
import 'package:store_user_app/main.dart' as app;

import 'helpers.dart';

void main() async {
  const deviceName = String.fromEnvironment('DEVICE_NAME');
  print('Device name: $deviceName');

  const localeName = String.fromEnvironment('LOCALE');
  print('Locale name: $localeName');
  final localSplit = localeName.split('_');
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    return Future(() async {
      WidgetsApp.debugAllowBannerOverride = false; // Hide the debug banner
      if (Platform.isAndroid) {
        await binding.convertFlutterSurfaceToImage();
      }
    });
  });

  group("onboarding screen end-to-end test", () {
    testWidgets(
      'should navigate through onboarding screens and take screenshots',
      (tester) async {
        var platform = Platform.isAndroid ? "android" : "ios";
        await binding.setLocale(localSplit[0], localSplit[1]);

        // Launch the app
        app.main();
        await tester.pumpAndSettle();

        // Wait for the WalkThroughScreen to appear
        await pumpUntilFound(
          tester,
          find.byType(WalkThroughScreen),
          timeout: const Duration(seconds: 10),
        );
        await binding.delayed(const Duration(seconds: 2));
        await tester.pumpAndSettle();

        // First screen - "Siparişini Ver"
        expect(find.text('Siparişini Ver'), findsOneWidget);
        await binding.takeScreenshot(
          '$platform/$deviceName/$localeName/onboarding-screen-1',
        );

        // Tap the "next" button on first screen
        final nextButton = find.widgetWithText(ElevatedButton, next);
        expect(nextButton, findsOneWidget);
        await tester.tap(nextButton);
        await tester.pumpAndSettle();
        await binding.delayed(const Duration(seconds: 2));

        // Second screen - "Kolayca Öde"
        expect(find.text('Kolayca Öde'), findsOneWidget);
        await binding.takeScreenshot(
          '$platform/$deviceName/$localeName/onboarding-screen-2',
        );

        // Tap the "next" button on second screen
        await tester.tap(find.widgetWithText(ElevatedButton, next));
        await tester.pumpAndSettle();
        await binding.delayed(const Duration(seconds: 2));

        // Third screen - "Hemen Kapında"
        expect(find.text('Hemen Kapında'), findsOneWidget);
        await binding.takeScreenshot(
          '$platform/$deviceName/$localeName/onboarding-screen-3',
        );

        // Tap the "getStarted" button on third screen
        final getStartedButton = find.widgetWithText(
          ElevatedButton,
          getStarted,
        );
        expect(getStartedButton, findsOneWidget);
        await tester.tap(getStartedButton);
        await tester.pumpAndSettle();
        await binding.delayed(const Duration(seconds: 3));

        // Verify we've left the onboarding screens
        expect(find.byType(WalkThroughScreen), findsNothing);

        // Take screenshot of welcome screen (after completing onboarding)
        await binding.takeScreenshot(
          '$platform/$deviceName/$localeName/welcome-screen',
        );
      },
    );
  });
}
