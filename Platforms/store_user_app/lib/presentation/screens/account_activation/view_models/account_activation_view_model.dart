import 'package:freezed_annotation/freezed_annotation.dart';

part 'account_activation_view_model.freezed.dart';

@freezed
class AccountActivationViewModel with _$AccountActivationViewModel {
  const factory AccountActivationViewModel({
    required String token,
    required String email,
    @Default(false) bool isProcessing,
    @Default(false) bool isActivationSuccess,
    String? resultMessage,
    String? errorMessage,
  }) = _AccountActivationViewModel;
}