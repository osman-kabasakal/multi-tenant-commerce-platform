import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/config/app_config.dart';
import 'package:store_user_app/core/config/image_size_config.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/core/constants/strings.dart';
import 'package:store_user_app/core/models/navigator/signup_route_result.dart';
import 'package:store_user_app/domain/entities/models/customer/LoginModel/loginModel.dart';
import 'package:store_user_app/presentation/screens/signin/providers/signin_screen_controller.dart';
import 'package:store_user_app/presentation/screens/signin/view_models/signin_view_model.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_error_widget.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/either_or.dart';
import 'package:store_user_app/presentation/widgets/buttons/view/app_common_button.dart';
import 'package:store_user_app/presentation/widgets/form/widgets/generic_form.dart';
import 'package:store_user_app/presentation/widgets/images/view/optimized_cache_image.dart';

class SigninForm extends StatefulHookConsumerWidget {
  final bool isDarkMode;
  final SigninScreenController controller;
  final SigninViewModel state;
  const SigninForm({
    super.key,
    required this.controller,
    required this.state,
    required this.isDarkMode,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SigninFormState();
}

class _SigninFormState extends ConsumerState<SigninForm> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 30,
      children: [
        Center(
          child: OptimizedCacheImage(
            fit: BoxFit.contain,

            alignment: Alignment.center,
            imageUrl: AppConfig.instance.storeLogo,
            sizeConfig: ImageSizeConfig(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.2,
            ),
          ),
        ),
        20.height,
        Text(
          signIn,
          style: context.theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ).center(),
        20.height,
        if (widget.state.submitError != null)
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: AppErrorWidget(
              message: widget.state.submitError!,
              type: ErrorType.error,
            ),
          ),
        GenericForm<LoginModel>(
          formBuilder: widget.state.formBuilder,
          formController: widget.state.formController,
        ),
        30.height,
        AppCommonButton(
          onPressed: () async {
            if (widget.state.processing) return;
            await widget.controller.formSubmit();
          },
          text: signIn,
          bgColor: alertColor,
        ),
        30.height,
        EitherOr(orText: dontHaveAccount, isDarkMode: widget.isDarkMode),
        10.height,
        TextButton(
          onPressed:
              widget.state.processing
                  ? null
                  : () {
                    widget.controller.popWithResult(
                      SigninRouteResult.redirectToSignup,
                    );
                  },
          child: Text.rich(
            TextSpan(
              text: signup,
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
