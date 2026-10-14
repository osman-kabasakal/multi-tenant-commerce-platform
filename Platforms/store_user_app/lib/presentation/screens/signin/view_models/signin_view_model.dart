import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/services/form/app_form_controller.dart';
import 'package:store_user_app/domain/entities/models/customer/LoginModel/loginModel.dart';
import 'package:store_user_app/presentation/form_builders/login_model_form_builder.dart';

part 'signin_view_model.freezed.dart';

@freezed
class SigninViewModel with _$SigninViewModel {
  const factory SigninViewModel({
    @Default(false) bool isLoading,
    required AppFormController<LoginModel> formController,
    required LoginModelFormBuilder formBuilder,
    required LoginModel loginModel,
    String? returnUrl,
    @Default(false) bool processing,
    String? submitError,
  }) = _SigninViewModel;
}
