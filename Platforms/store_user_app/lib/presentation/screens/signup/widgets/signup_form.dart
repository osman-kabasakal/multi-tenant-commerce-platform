import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/config/app_config.dart';
import 'package:store_user_app/core/config/image_size_config.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/core/constants/strings.dart';
import 'package:store_user_app/domain/entities/models/customer/register_model/register_model.dart';
import 'package:store_user_app/presentation/screens/signup/providers/signup_controller.dart';
import 'package:store_user_app/presentation/screens/signup/view_models/signup_view_model.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_error_widget.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/either_or.dart';
import 'package:store_user_app/presentation/widgets/buttons/view/app_common_button.dart';
import 'package:store_user_app/presentation/widgets/form/widgets/generic_form.dart';
import 'package:store_user_app/presentation/widgets/images/view/optimized_cache_image.dart';

class SignupForm extends HookConsumerWidget {
  final bool isDarkMode;
  final SignupController controller;
  final SignupViewModel state;
  const SignupForm({
    super.key,
    required this.controller,
    required this.state,
    required this.isDarkMode,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Wrap(
      spacing: 30,
      children: [
        Center(
          child: OptimizedCacheImage(
            fit: BoxFit.contain,
            alignment: Alignment.center,
            imageUrl: AppConfig.instance.storeLogo,
            errorWidget: Center(
              child: Text(
                AppConfig.instance.appTitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            sizeConfig: ImageSizeConfig(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.2,
            ),
          ),
        ),
        Text(
          createNewAccount,
          style: context.theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ).center(),
        20.height,
        if (state.submitError != null)
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: AppErrorWidget(
              message: state.submitError!,
              type: ErrorType.error,
            ),
          ),
        GenericForm<RegisterModel>(
          formBuilder: state.formBuilder,
          formController: state.formController,
        ),
        30.height,
        AppCommonButton(
          onPressed: () async {
            if (state.processing) return;
            await controller.formSubmit();
          },
          text: signup,
          bgColor: alertColor,
        ),
        30.height,
        EitherOr(orText: alreadyHaveAccount, isDarkMode: isDarkMode),
        10.height,
        TextButton(
          onPressed:
              state.processing
                  ? null
                  : () {
                    controller.goToSignInScreen();
                  },
          child: Text.rich(
            TextSpan(
              text: signWithEmail,
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorPrimary,
              ),
            ),
          ),
        ).center(),
        30.height,
      ],
    );
  }
}
