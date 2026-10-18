// SPDX-License-Identifier: GPL-3.0-only
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:store_user_app/core/config/theme/theme.dart';

void main() {
  for (final theme in [AppTheme.foodLightTheme, AppTheme.foodDarkTheme]) {
    testWidgets(
      'Existing theme ${theme.brightness.name} supports a scaled form',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(320, 640));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        var saved = false;
        await tester.pumpWidget(
          MaterialApp(
            theme: theme,
            builder:
                (context, child) => MediaQuery(
                  data: MediaQuery.of(
                    context,
                  ).copyWith(textScaler: const TextScaler.linear(1.5)),
                  child: child!,
                ),
            home: Scaffold(
              appBar: AppBar(title: const Text('Hesabım')),
              body: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const TextField(
                    decoration: InputDecoration(labelText: 'E-posta'),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => saved = true,
                    child: const Text('Kaydet'),
                  ),
                ],
              ),
            ),
          ),
        );
        await tester.enterText(find.byType(TextField), 'demo@example.test');
        await tester.tap(find.text('Kaydet'));
        await tester.pump();
        expect(saved, isTrue);
        expect(tester.takeException(), isNull);
        final context = tester.element(find.byType(TextField));
        expect(Theme.of(context).brightness, theme.brightness);
        expect(
          Theme.of(context).textTheme.bodyMedium?.fontFamily,
          AppTheme.fontFamily,
        );
      },
    );
  }
}
