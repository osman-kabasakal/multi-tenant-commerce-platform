import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/services/form/app_form_controller.dart';
import 'package:store_user_app/domain/entities/models/catalog/add_product_review_model/add_product_review_model.dart';
import 'package:store_user_app/presentation/form_builders/add_review_model_form_builder.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_widget.dart';
import 'package:store_user_app/presentation/widgets/buttons/view/app_common_button.dart';
import 'package:store_user_app/presentation/widgets/form/widgets/generic_form.dart';
import 'package:store_user_app/presentation/widgets/layout/view/base_bottom_sheet.dart';

class AddReviewWidget extends HookConsumerWidget {
  final AddProductReviewModel model;
  final FutureOr<void> Function(AddProductReviewModel) onSubmit;
  const AddReviewWidget(
      {super.key, required this.model, required this.onSubmit});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var formBuilder = useMemoized(() => AddReviewModelFormBuilder(model));

    var formController =
        useMemoized(() => AppFormController(formBuilder.build()));

    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: fdCommonAppBarWidget(
        context,
      ),
      body: LayoutBuilder(builder: (context, boxConstraint) {
        return BaseBottomSheet(
          title: 'Yorum ve Değerlendirme Ekle',
          width: boxConstraint.maxWidth,
          height: boxConstraint.maxHeight,
          contentBuilder: (context) {
            return Card(
              margin: const EdgeInsets.only(top: 16.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GenericForm(
                    formBuilder: formBuilder, formController: formController),
              ),
            );
          },
          footerBuilder: (context) {
            return Row(
              children: [
                Expanded(
                  child: AppCommonButton(
                    onPressed: () async {
                      if (formController.submit()) {
                        var currentFormModel = formController.getValues();
                        await onSubmit(
                          model.copyWith(
                            rating: currentFormModel['Rating'],
                            title: currentFormModel['Title'],
                            reviewText: currentFormModel['ReviewText'],
                          ),
                        );
                      }
                    },
                    text: 'Değerlendir',
                    height: 58,
                  ),
                ),
              ],
            );
          },
        );
      }),
    );
  }
}
