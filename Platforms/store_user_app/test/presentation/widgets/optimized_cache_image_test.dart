import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:store_user_app/core/config/image_size_config.dart';
import 'package:store_user_app/presentation/widgets/images/view/optimized_cache_image.dart';

void main() {
  testWidgets(
    'an absent tenant logo renders a bounded fallback without authentication or network',
    (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 280,
                child: OptimizedCacheImage(
                  imageUrl: '',
                  sizeConfig: ImageSizeConfig(
                    width: double.infinity,
                    height: 60,
                  ),
                  errorWidget: Text('Test store'),
                ),
              ),
            ),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
      expect(find.text('Test store'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    },
  );
}
