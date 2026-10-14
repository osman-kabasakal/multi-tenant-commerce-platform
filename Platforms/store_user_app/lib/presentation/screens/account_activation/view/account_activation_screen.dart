import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/presentation/screens/account_activation/providers/account_activation_controller.dart';
import 'package:store_user_app/presentation/screens/account_activation/view_models/account_activation_view_model.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_widget.dart';

@RoutePage()
class AccountActivationScreen extends HookConsumerWidget {
  final String? token;
  final String? email;

  const AccountActivationScreen({
    Key? key,
    @QueryParam() this.token,
    @QueryParam() this.email,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(accountActivationControllerProvider(token, email).notifier);
    final state = ref.watch(accountActivationControllerProvider(token, email));

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: fdCommonAppBarWidget(context),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: state.when(
              data: (data) => _buildContent(context, data, controller),
              loading: () => const CircularProgressIndicator(),
              error: (error, stack) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Bir hata oluştu',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    error.toString(),
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => controller.goToLogin(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorPrimary,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    ),
                    child: const Text(
                      'Giriş Yap',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, AccountActivationViewModel data, AccountActivationController controller) {
    if (data.isProcessing) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 24),
          Text(
            'Hesabınız aktive ediliyor...',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Lütfen hesabınızı doğrularken bekleyin.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          data.isActivationSuccess 
            ? Icons.check_circle_outline 
            : Icons.error_outline,
          size: 80,
          color: data.isActivationSuccess ? colorPrimary : Colors.red,
        ),
        const SizedBox(height: 24),
        Text(
          data.isActivationSuccess 
            ? 'Hesap Aktive Edildi!' 
            : 'Aktivasyon Başarısız',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            data.resultMessage ?? data.errorMessage ?? 'Beklenmeyen bir hata oluştu.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: () => controller.goToLogin(),
          style: ElevatedButton.styleFrom(
            backgroundColor: colorPrimary,
            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Giriş Yap',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}