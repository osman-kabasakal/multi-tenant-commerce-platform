import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/navigation/app_router.dart';
import 'package:store_user_app/core/navigation/app_router.gr.dart';
import 'package:store_user_app/domain/repositories/account/account_repository.dart';
import 'package:store_user_app/presentation/screens/account_activation/view_models/account_activation_view_model.dart';

part 'account_activation_controller.g.dart';

@riverpod
class AccountActivationController extends _$AccountActivationController {
  late AccountRepository _accountRepository;
  late AppRouter _appRouter;

  @override
  Future<AccountActivationViewModel> build(String? token, String? email) async {
    _accountRepository = await getIt.getAsync<AccountRepository>();
    _appRouter = getIt<AppRouter>();
    
    // Check if token and email are provided
    if (token == null || email == null) {
      return AccountActivationViewModel(
        token: '',
        email: '',
        isProcessing: false,
        isActivationSuccess: false,
        errorMessage: 'Geçersiz aktivasyon bağlantısı. Token veya e-posta eksik.',
      );
    }
    
    // Automatically activate account when screen loads
    final viewModel = AccountActivationViewModel(
      token: token,
      email: email,
      isProcessing: true,
    );
    
    // Start activation process
    Future.microtask(() => _activateAccount());
    
    return viewModel;
  }

  Future<void> _activateAccount() async {
    try {
      final response = await _accountRepository.getAccountAccountActivation(
        state.requireValue.token,
        state.requireValue.email,
      );

      if (response != null) {
        // Check if response has redirect
        if (response.redirect != null && response.redirect!.redirectUri != null) {
          final redirectPath = response.redirect!.redirectUri!.path;
          
          // Check if redirect is to home or root
          if (redirectPath.startsWith('/home') || redirectPath == '/') {
            // Activation successful
            state = AsyncValue.data(state.requireValue.copyWith(
              isProcessing: false,
              isActivationSuccess: true,
              resultMessage: 'Hesabınız başarıyla aktive edildi!',
            ));
          } else {
            // Activation failed
            state = AsyncValue.data(state.requireValue.copyWith(
              isProcessing: false,
              isActivationSuccess: false,
              errorMessage: 'Hesap aktivasyonu başarısız oldu. Lütfen tekrar deneyin veya destek ile iletişime geçin.',
            ));
          }
        } else if (response.data != null && response.data!.result != null) {
          // Show result message from server
          state = AsyncValue.data(state.requireValue.copyWith(
            isProcessing: false,
            isActivationSuccess: false,
            resultMessage: response.data!.result,
          ));
        } else {
          // Unknown response
          state = AsyncValue.data(state.requireValue.copyWith(
            isProcessing: false,
            isActivationSuccess: false,
            errorMessage: 'Beklenmeyen bir hata oluştu. Lütfen tekrar deneyin.',
          ));
        }
      } else {
        // No response
        state = AsyncValue.data(state.requireValue.copyWith(
          isProcessing: false,
          isActivationSuccess: false,
          errorMessage: 'Hesap aktive edilemedi. Lütfen internet bağlantınızı kontrol edin.',
        ));
      }
    } catch (e) {
      state = AsyncValue.data(state.requireValue.copyWith(
        isProcessing: false,
        isActivationSuccess: false,
        errorMessage: 'Bir hata oluştu: ${e.toString()}',
      ));
    }
  }

  void goToLogin() {
    _appRouter.replace(SigninRoute());
  }
}