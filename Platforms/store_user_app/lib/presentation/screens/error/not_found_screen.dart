import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/core/constants/images.dart';
import 'package:store_user_app/core/constants/strings.dart';
import 'package:store_user_app/core/navigation/app_paths.dart';
import 'package:store_user_app/core/navigation/app_router.gr.dart';

@RoutePage()
class NotFoundScreen extends StatelessWidget {
  final String? message;
  final String? path;

  const NotFoundScreen({Key? key, this.message, this.path}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sayfa Bulunamadı'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.router.navigate(const HomeRoute());
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(noSearchResultIcon, width: 200, height: 200),
              const SizedBox(height: 32),
              Text(
                '404',
                style: theme.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorPrimary,
                  fontSize: 48,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                message ??
                    '⚠️ İstediğiniz sayfayı bulamadık ve bunun nedenini tahmin edebiliyoruz. Endişelenmeyin, alışverişinize devam etmeniz için size yardımcı olacağız!',
                style: theme.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              if (path != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Yol: $path',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: lightTextColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  context.router.navigate(const HomeRoute());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorPrimary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Ana Sayfa'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
