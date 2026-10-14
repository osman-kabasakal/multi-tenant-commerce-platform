import 'package:auto_route/auto_route.dart';
import 'package:flextras/flextras.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/config/theme/theme.dart';
import 'package:store_user_app/core/constants/strings.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/services/form/app_form_controller.dart';
import 'package:store_user_app/core/services/form/form_builder.dart';
import 'package:store_user_app/core/services/form/form_field.dart';
import 'package:store_user_app/core/services/theme/theme_controller.dart';
import 'package:store_user_app/core/constants/colors.dart' as app_colors;
import 'package:store_user_app/domain/entities/models/orders/add_order_note_model/add_order_note_model.dart';
import 'package:store_user_app/presentation/widgets/buttons/view/app_common_button.dart';
import 'package:store_user_app/presentation/widgets/form/widgets/generic_form.dart';
import 'package:store_user_app/presentation/widgets/layout/view/app_card.dart';

class AddOrderNoteButtomSheetWidget extends StatefulHookConsumerWidget {
  final String orderId;
  const AddOrderNoteButtomSheetWidget({super.key, required this.orderId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddOrderNoteButtomSheetWidgetState();
}

class _AddOrderNoteButtomSheetWidgetState
    extends ConsumerState<AddOrderNoteButtomSheetWidget> {
  late final _themeController = getIt<ThemeController>();
  late final ThemeData _theme;

  late final FormBuilder<AddOrderNoteModel> _formBuilder;
  late final AppFormController<AddOrderNoteModel> _appFormController;

  @override
  void initState() {
    _formBuilder = FormBuilder<AddOrderNoteModel>(
        AddOrderNoteModel(orderId: widget.orderId))
      ..addField('OrderId', (m) => m.orderId, type: FormFieldType.hidden)
      ..addMultilineTextField(
        'Note',
        label: 'Notunuzu Yazınız....',
        (model) => model.note,
        isRequired: true,
        validation: (value) {
          if (value!.isEmpty) {
            return 'Lütfen sipariş notunu giriniz';
          }

          if (value.length > 500) {
            return 'Sipariş notu 500 karakterden fazla olamaz';
          }

          return null;
        },
      );

    _appFormController = AppFormController(_formBuilder.build());

    _theme = _themeController.isDarkMode
        ? AppTheme.foodDarkTheme
        : AppTheme.foodLightTheme;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: SeparatedColumn(
        separatorBuilder: () => const Gap(15),
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Notunuzu Yazınız',
              textAlign: TextAlign.center,
              style: _theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold, color: app_colors.appRedColor)),
          Divider(
            color: _themeController.isDarkMode
                ? app_colors.borderDark
                : app_colors.borderColor,
            height: 1,
            thickness: 1,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: AppCard(
                child: GenericForm<AddOrderNoteModel>(
                  formBuilder: _formBuilder,
                  formController: _appFormController,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: AppCommonButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                text: cancel,
                height: 58,
                bgColor: _themeController.isDarkMode
                    ? app_colors.borderDark
                    : app_colors.primaryColor100,
                textColor: _themeController.isDarkMode
                    ? whiteColor
                    : app_colors.colorPrimary,
              )),
              15.width,
              Expanded(
                  child: AppCommonButton(
                      onPressed: () async {
                        if (_appFormController.validate()) {
                          await context.router.maybePop(
                              AddOrderNoteModel.fromJson(
                                  _appFormController.getValues()));
                        }
                      },
                      text: add,
                      height: 58)),
            ],
          ),
          if (context.isIOS) 20.height,
        ],
      ),
    );
  }
}
