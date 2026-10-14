import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/services/form/app_form_controller.dart';
import 'package:store_user_app/domain/entities/models/customer/register_model/register_model.dart';
import 'package:store_user_app/presentation/form_builders/register_model_form_builder.dart';

part 'signup_view_model.freezed.dart';

@freezed
class SignupViewModel with _$SignupViewModel {
  const factory SignupViewModel({
    required AppFormController<RegisterModel> formController,
    required RegisterModelFormBuilder formBuilder,
    RegisterModel? registerModel,
    Map<String, dynamic>? claims,
    String? returnUrl,
    @Default(false) bool processing,
    String? submitError,
    int? registrationResultId,
    String? registrationResultMessage,
    @Default(false) bool showRegistrationResult,
  }) = _SignupViewModel;
}
