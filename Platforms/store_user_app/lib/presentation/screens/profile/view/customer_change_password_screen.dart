import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/services/form/app_form_controller.dart';
import 'package:store_user_app/core/services/form/form_builder.dart';
import 'package:store_user_app/core/services/form/form_field.dart';
import 'package:store_user_app/core/services/theme/theme_controller.dart';
import 'package:store_user_app/domain/entities/models/customer/change_password_model/change_password_model.dart';
import 'package:store_user_app/presentation/screens/profile/providers/change_password_controller.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_error_widget.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_widget.dart';
import 'package:store_user_app/presentation/widgets/buttons/view/app_common_button.dart';
import 'package:store_user_app/presentation/widgets/form/widgets/generic_form.dart';

@RoutePage()
class CustomerChangePasswordScreen extends HookConsumerWidget {
  const CustomerChangePasswordScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(changePasswordControllerProvider.notifier);
    final state = ref.watch(changePasswordControllerProvider);
    final themeController = getIt<ThemeController>();
    // Create the form controller
    late AppFormController<ChangePasswordModel>? formController;

    // Create the form builder with the model from the controller
    final formBuilder = useMemoized(
        () => FormBuilder<ChangePasswordModel>(
            state.valueOrNull?.model ?? ChangePasswordModel())
          ..addField(
            'OldPassword',
            (model) => model.oldPassword,
            label: 'Mevcut Şifre',
            type: FormFieldType.password,
            isRequired: true,
            validation: (value) => (value == null || value.isEmpty)
                ? 'Mevcut şifre gereklidir'
                : null,
          )
          ..addField(
            'NewPassword',
            (model) => model.newPassword,
            label: 'Yeni Şifre',
            type: FormFieldType.password,
            isRequired: true,
            validation: (value) => (value == null || value.isEmpty)
                ? 'Yeni şifre gereklidir'
                : (value.length < 6)
                    ? 'Şifre en az 6 karakter olmalıdır'
                    : null,
          )
          ..addField(
            'ConfirmNewPassword',
            (model) => model.confirmNewPassword,
            label: 'Yeni Şifre (Tekrar)',
            type: FormFieldType.password,
            isRequired: true,
            validation: (value) {
              if ((value == null || value.isEmpty)) {
                return 'Şifre tekrarı gereklidir';
              }

              if (formController != null) {
                final newPassword =
                    formController.getFieldState('NewPassword')?.value;
                if (newPassword != value &&
                    newPassword != null &&
                    newPassword.isNotEmpty) {
                  return 'Şifreler eşleşmiyor';
                }
              }
              return null;
            },
          ),
        [state.valueOrNull?.model]);

    formController = useMemoized(
        () => AppFormController<ChangePasswordModel>(formBuilder.build(),
                onFieldChange: (name, value) {
              // Add special validation for matching passwords
              // if (name == 'NewPassword' || name == 'ConfirmNewPassword') {
              //   final newPassword =
              //       formController.getFieldState('NewPassword')?.value;
              //   final confirmPassword =
              //       formController.getFieldState('ConfirmNewPassword')?.value;

              //   if (confirmPassword != null &&
              //       confirmPassword.isNotEmpty &&
              //       newPassword != null &&
              //       newPassword.isNotEmpty &&
              //       newPassword != confirmPassword) {
              //     formController.updateField(
              //       'ConfirmNewPassword',
              //       confirmPassword,
              //       false,
              //     );
              //     formController.setValidator(
              //         'ConfirmNewPassword',
              //         (value) =>
              //             value != newPassword ? 'Şifreler eşleşmiyor' : null);
              //   } else if (confirmPassword != null &&
              //       confirmPassword.isNotEmpty &&
              //       newPassword != null &&
              //       newPassword.isNotEmpty &&
              //       newPassword == confirmPassword) {
              //     formController.setValidator(
              //         'ConfirmNewPassword', (value) => null);
              //   }
              // }
            }),
        [formBuilder]);

    // Handle submission
    final handleSubmit = useCallback(() async {
      if (formController != null && formController.submit()) {
        final values = formController.getValues();
        final model = ChangePasswordModel(
          oldPassword: values['OldPassword'],
          newPassword: values['NewPassword'],
          confirmNewPassword: values['ConfirmNewPassword'],
        );
        await controller.changePassword(model);
      }
    }, [formController, controller]);

    // Reset form when we get a successful result
    useEffect(() {
      if (formController != null && (state.valueOrNull?.success ?? false)) {
        formController.reset();
      }
      return null;
    }, [state.valueOrNull?.success]);

    return Scaffold(
      appBar: fdCommonAppBarWidget(
        context,
        titleText: 'Şifre Değiştir',
        isback: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Show initial message
            if (!(state.valueOrNull?.isSubmitted ?? false) &&
                (state.valueOrNull?.message) == null)
              AppErrorWidget(
                message:
                    'Güvenliğiniz için şifrenizi düzenli olarak değiştirmenizi öneririz. Güçlü bir şifre oluşturmak için büyük ve küçük harfler, rakamlar ve özel karakterler kullanın.',
                type: ErrorType.info,
                isDismissible: false,
              ),

            // Show error message if submission failed
            if ((state.valueOrNull?.message) != null &&
                !(state.valueOrNull?.success ?? false))
              AppErrorWidget(
                message: (state.valueOrNull!.message ?? ''),
                type: ErrorType.error,
                isDismissible: true,
              ),

            // Show success message if submission succeeded
            if (state.valueOrNull?.success ?? false)
              AppErrorWidget(
                message: state.valueOrNull!.message ??
                    'Şifreniz başarıyla değiştirildi.',
                type: ErrorType.success,
                isDismissible: true,
              ),

            const SizedBox(height: 16),

            // Form fields
            Expanded(
              child: SingleChildScrollView(
                child: RepaintBoundary(
                  child: GenericForm<ChangePasswordModel>(
                    formController: formController,
                    formBuilder: formBuilder,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Submit button
            AppCommonButton(
              text: 'Şifreyi Değiştir',
              onPressed: state.isLoading ? null : handleSubmit,
              bgColor: themeController.isDarkMode ? cardDark : colorPrimary,
            ),
          ],
        ),
      ),
    );
  }
}
