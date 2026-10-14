import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

Future<void> tapAndTakeScreenshot(
  IntegrationTestWidgetsFlutterBinding binding,
  WidgetTester tester,
  Finder finder, {
  required String screenshotName,
  Duration delayDuration = const Duration(seconds: 1),
}) async {
  await tester.tap(finder);
  await tester.pump();
  await binding.delayed(delayDuration);
  await tester.pump();
  await binding.takeScreenshot(screenshotName);
}

Future<void> pumpUntilFound(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 10),
}) async {
  bool timerDone = false;
  final timer = Timer(timeout, () => timerDone = true);
  while (timerDone != true) {
    await tester.pump();

    final found = tester.any(finder);
    if (found) {
      timerDone = true;
    }
  }
  timer.cancel();
}
