import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/state_management/riverpod/cache_aware_provider.dart';
import 'package:store_user_app/domain/entities/models/customer/change_password_model/change_password_model.dart';
import 'package:store_user_app/domain/repositories/account/account_repository.dart';
import 'package:store_user_app/presentation/screens/profile/view_models/change_password_view_model.dart';

part 'change_password_controller.g.dart';

@riverpod
class ChangePasswordController extends _$ChangePasswordController
    with
        CacheInvalidationBase,
        CacheAwareAsyncProvider<ChangePasswordViewModel> {
  late AccountRepository _accountRepository;

  @override
  FutureOr<ChangePasswordViewModel> build() async {
    await registerCorrelation();

    _accountRepository = await getIt.getAsync<AccountRepository>();

    try {
      var changePasswordModel =
          await correlationService.runRepositoryMethodWithCorrelation(
        correlationId,
        () async => await _accountRepository.getAccountChangePassword(),
      );

      if (changePasswordModel != null && changePasswordModel.data != null) {
        return ChangePasswordViewModel(
          model: changePasswordModel.data,
          isLoading: false,
          success: false,
          isSubmitted: false,
          message: null,
          error: null,
        );
      } else {
        return ChangePasswordViewModel(
          model: ChangePasswordModel(),
          isLoading: false,
          success: false,
          isSubmitted: false,
          message: null,
          error: null,
        );
      }
    } catch (e) {
      return ChangePasswordViewModel(
        error: e,
        message: 'Şifre değiştirme formu yüklenirken bir hata oluştu.',
        isLoading: false,
        model: ChangePasswordModel(),
      );
    }
  }

  Future<void> changePassword(ChangePasswordModel model) async {
    if (!state.hasValue) return;

    state = AsyncValue.data(state.requireValue.copyWith(
        isLoading: true, isSubmitted: true, success: false, message: null));

    try {
      final response =
          await _accountRepository.postAccountChangePassword(model);

      if (response != null) {
        if (response.isRedirectResponse) {
          state = AsyncValue.data(state.requireValue.copyWith(
            isLoading: false,
            success: false,
            message: 'İşlem tamamlanamadı. Yönlendirme hatası.',
          ));
          return;
        }

        if (response.data?.result != null) {
          state = AsyncValue.data(state.requireValue.copyWith(
            isLoading: false,
            success: true,
            message: response.data!.result,
            model: ChangePasswordModel(),
          ));
        } else {
          state = AsyncValue.data(state.requireValue.copyWith(
            isLoading: false,
            success: true,
            message: 'Şifreniz başarıyla değiştirildi.',
            model: ChangePasswordModel(),
          ));
        }
      } else {
        state = AsyncValue.data(state.requireValue.copyWith(
          isLoading: false,
          success: false,
          message: 'Şifre değiştirme işlemi başarısız oldu.',
        ));
      }
    } catch (e) {
      state = AsyncValue.data(state.requireValue.copyWith(
        isLoading: false,
        error: e,
        success: false,
        message: 'Şifre değiştirme sırasında bir hata oluştu: ${e.toString()}',
      ));
    }
  }
}
