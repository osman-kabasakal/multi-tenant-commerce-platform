import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:store_user_app/core/constants/colors.dart' as appColors;
import 'package:store_user_app/core/constants/strings.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/services/form/app_form_controller.dart';
import 'package:store_user_app/core/services/form/form_builder.dart';
import 'package:store_user_app/core/services/form/form_field.dart';
import 'package:store_user_app/core/services/theme/theme_controller.dart';
import 'package:store_user_app/domain/entities/models/customer/delete_account_model/delete_account_model.dart';
import 'package:store_user_app/presentation/widgets/buttons/view/app_common_button.dart';
import 'package:store_user_app/presentation/widgets/form/widgets/generic_form.dart';

class DeleteAccountBottomSheet extends HookConsumerWidget {
  const DeleteAccountBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themeController = getIt<ThemeController>();
    var formBuilder = useMemoized(()=>FormBuilder(DeleteAccountModel())
      ..addField(
        'Password',
            (model) => model.password,
        label: 'Mevcut Şifreniz',
        type: FormFieldType.password,
        validation: (value) =>
        (value?.isEmpty??true) ? 'Şifre alanı boş bırakılamaz' : null,
      ),[]);
    var controller = useMemoized(()=>AppFormController<DeleteAccountModel>(
      formBuilder.build(),
    ),[formBuilder]);
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(logout,
              textAlign: TextAlign.center,
              style: context.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold, color: appColors.appRedColor)),
          15.height,
          Divider(
            color: themeController.isDarkMode
                ? appColors.borderDark
                : appColors.borderColor,
            height: 1,
            thickness: 1,
          ),
          15.height,
          Text('Hesabınızı silmek istediğinize emin misiniz?',
              textAlign: TextAlign.center,
              style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: themeController.isDarkMode
                      ? appColors.colorGrey300
                      : appColors.colorGrey800)),
          20.height,
          GenericForm<DeleteAccountModel>(
            formController: controller,
            formBuilder: formBuilder,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: AppCommonButton(
                    onPressed: () {
                      context.router.maybePop(null);
                    },
                    text: cancel,
                    height: 58,
                    bgColor: themeController.isDarkMode
                        ? appColors.borderDark
                        : appColors.primaryColor100,
                    textColor: themeController.isDarkMode
                        ? whiteColor
                        : appColors.colorPrimary,
                  )),
              15.width,
              Expanded(
                  child: AppCommonButton(
                      onPressed: () async {
                        if (controller.validate()) {
                          var formValue = controller.getValues();
                          await context.router
                              .maybePop(DeleteAccountModel.fromJson(formValue));
                        }
                      },
                      text: yesDeleteAccount,
                      height: 58)),
            ],
          ),
          if (context.isIOS) 20.height,
        ],
      ),
    );
  }
}
