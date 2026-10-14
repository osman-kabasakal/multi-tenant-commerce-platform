import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/core/constants/images.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/services/form/app_form_controller.dart';
import 'package:store_user_app/core/services/form/form_builder.dart';
import 'package:store_user_app/core/services/theme/theme_controller.dart';
import 'package:store_user_app/domain/entities/microsoft/asp_net_core/mvc/rendering/select_list_item/select_list_item.dart';
import 'package:store_user_app/domain/entities/models/catalog/product_details_model/add_to_cart_model/add_to_cart_model.dart';
import 'package:store_user_app/presentation/widgets/buttons/view/app_icon_button.dart';
import 'package:store_user_app/presentation/widgets/form/widgets/generic_form.dart';
import 'package:store_user_app/presentation/widgets/layout/view/load_component_when_visible.dart';

class QuantitySelectorWidget extends HookConsumerWidget {
  final AddToCartModel model;
  final FutureOr<void> Function()? onIncrease;
  final FutureOr<void> Function()? onDecrease;
  final FutureOr<void> Function(int selectedQuantity)? onChanged;
  final String? validationMessage;

  const QuantitySelectorWidget({
    super.key,
    required this.model,
    this.onDecrease,
    this.onIncrease,
    this.onChanged,
    this.validationMessage,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var allowedQuantityBuilder = FormBuilder<AddToCartModel>(model)
      ..addDropDownField(
        'Quantity',
        // label: 'Adet',
        (model) => (model.enteredQuantity ?? 0),
        (option) => (option.allowedQuantities ?? <SelectListItem>[]),
        (opt) => opt.text ?? '',
        (opt) => int.parse(opt.value ?? '0'),
        isRequired: true,
        validation: (value) => validationMessage,
        initalSelectedValues: model.enteredQuantity != null
            ? [model.enteredQuantity]
            : model.allowedQuantities
                    ?.where((v) => v.selected ?? false)
                    .map((v) => int.parse(v.value ?? '0'))
                    .toList() ??
                [],
      ).setHintText('Adet');
    var formController = AppFormController(allowedQuantityBuilder.build(),
        onFieldChange: (field, value) {
      onChanged?.call(value);
    });

    var themeController = getIt<ThemeController>();
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (model.allowedQuantities?.isNotEmpty ?? false)
          SizedBox(
            width: double.infinity,
            // height: MediaQuery.of(context).size.height * 0.12,
            child: LoadComponentWhenVisible(onVisible: () async {
              if (validationMessage != null) {
                formController.submit();
              }
            }, builder: (context) {
              return GenericForm(
                  formBuilder: allowedQuantityBuilder,
                  formController: formController);
            }),
          ),
        if (!(model.allowedQuantities?.isNotEmpty ?? false))
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              AppIconButton(
                  icon: SvgPicture.asset(
                    themeController.isDarkMode ? minusDarkIcon : minusIcon,
                    width: 35,
                    height: 35,
                  ),
                  onPressed: (model.enteredQuantity ?? 0) == 1
                      ? null
                      : () async {
                          if ((model.enteredQuantity ?? 0) > 1) {
                            await onDecrease?.call();
                          }
                        }),
              15.width,
              Text(
                '${model.enteredQuantity ?? 1}',
                style: context.textTheme.bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w900),
              ),
              15.width,
              AppIconButton(
                onPressed: onIncrease,
                icon: SvgPicture.asset(
                  themeController.isDarkMode ? addDarkIcon : addIcon,
                  width: 35,
                  height: 35,
                ),
              ),
            ],
          ),
      ],
    );
  }
}
