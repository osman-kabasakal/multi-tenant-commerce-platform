import 'dart:io';

import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/services/form/form_builder.dart';
import 'package:store_user_app/core/services/form/form_field.dart';
import 'package:store_user_app/domain/entities/catalog/attribute_control_type/attribute_control_type.dart';
import 'package:store_user_app/domain/entities/models/shopping_cart/shopping_cart_model/checkout_attribute_model/checkout_attribute_model.dart';
import 'package:store_user_app/domain/repositories/shopping_cart/shopping_cart_repository.dart';

class CheckoutAttributeModelFormBuilder
    extends FormBuilder<CheckoutAttributeModel> {
  CheckoutAttributeModelFormBuilder(CheckoutAttributeModel model)
      : super(model) {
    // Handle different attribute control types
    switch (model.attributeControlType) {
      case AttributeControlType.checkboxes:
      case AttributeControlType.readonlyCheckboxes:
        if (model.values?.isNotEmpty ?? false) {
          addCheckboxGroupField(
            model.id!,
            (model) => model,
            (model) => model.values!,
            (item) =>
                '${item.name ?? ''} ${item.priceAdjustment.isEmptyOrNull ? '' : ' (${item.priceAdjustment})'}',
            (item) => item.id!,
            label: (model.textPrompt ?? (model.name ?? '')),
            isRequired: model.isRequired ?? false,
            readonly: model.attributeControlType ==
                AttributeControlType.readonlyCheckboxes,
            initalSelectedValues: model.defaultValue?.split(',') ??
                model.values!
                    .where((v) => v.isPreSelected ?? false)
                    .map((e) => e.id)
                    .toList(),
          );
        }
        break;

      case AttributeControlType.dropdownList:
        if (model.values?.isNotEmpty ?? false) {
          addDropDownField(
            model.id!,
            (model) => model,
            (model) => model.values!,
            (item) =>
                '${item.name ?? ''} ${item.priceAdjustment.isEmptyOrNull ? '' : ' (${item.priceAdjustment})'}',
            (item) => item.id!,
            label: model.textPrompt ?? model.name ?? '',
            isRequired: model.isRequired ?? false,
            initalSelectedValues: model.defaultValue?.split(',') ??
                model.values!
                    .where((v) => v.isPreSelected ?? false)
                    .map((e) => e.id)
                    .toList(),
          );
        }
        break;

      case AttributeControlType.radioList:
        if (model.values?.isNotEmpty ?? false) {
          addRadioGroupField(
            model.id!,
            (model) => model,
            (model) => model.values!,
            (item) =>
                '${item.name ?? ''} ${item.priceAdjustment.isEmptyOrNull ? '' : ' (${item.priceAdjustment})'}',
            (item) => item.id!,
            label: model.textPrompt ?? model.name ?? '',
            isRequired: model.isRequired ?? false,
            initalSelectedValues: model.defaultValue?.split(',') ??
                model.values!
                    .where((v) => v.isPreSelected ?? false)
                    .map((e) => e.id)
                    .toList(),
          );
        }
        break;

      case AttributeControlType.textBox:
        addField(
          model.id!,
          (model) => model.defaultValue,
          label: (model.textPrompt ?? (model.name ?? '')) +
              (model.values?.firstOrNull?.priceAdjustment.isEmptyOrNull ?? true
                  ? ''
                  : ' (${model.values?.firstOrNull?.priceAdjustment})'),
          isRequired: model.isRequired ?? false,
        ).setHintText(
            (model.values?.firstOrNull?.priceAdjustment.isEmptyOrNull ?? true
                ? ''
                : ' (${model.values?.firstOrNull?.priceAdjustment})'));
        break;

      case AttributeControlType.multilineTextbox:
        addMultilineTextField(
          model.id!,
          (model) => model.defaultValue,
          label: (model.textPrompt ?? (model.name ?? '')) +
              (model.values?.firstOrNull?.priceAdjustment.isEmptyOrNull ?? true
                  ? ''
                  : ' (${model.values?.firstOrNull?.priceAdjustment})'),
          isRequired: model.isRequired ?? false,
        ).setHintText(
            (model.values?.firstOrNull?.priceAdjustment.isEmptyOrNull ?? true
                ? ''
                : ' (${model.values?.firstOrNull?.priceAdjustment})'));
        break;

      case AttributeControlType.datepicker:
        addField(
          model.id!,
          (model) => model.defaultValue != null
              ? DateTime.tryParse(model.defaultValue!)
              : null,
          label: (model.textPrompt ?? (model.name ?? '')) +
              (model.values?.firstOrNull?.priceAdjustment.isEmptyOrNull ?? true
                  ? ''
                  : ' (${model.values?.firstOrNull?.priceAdjustment})'),
          isRequired: model.isRequired ?? false,
          type: FormFieldType.date,
        ).setHintText(
            (model.values?.firstOrNull?.priceAdjustment.isEmptyOrNull ?? true
                ? ''
                : ' (${model.values?.firstOrNull?.priceAdjustment})'));
        break;

      case AttributeControlType.fileUpload:
        addField(
          model.id!,
          (model) => model.defaultValue,
          label: (model.textPrompt ?? (model.name ?? '')) +
              (model.values?.firstOrNull?.priceAdjustment.isEmptyOrNull ?? true
                  ? ''
                  : ' (${model.values?.firstOrNull?.priceAdjustment})'),
          isRequired: model.isRequired ?? false,
          type: FormFieldType.file,
          configurations: {
            'allowedExtensions': model.allowedFileExtensions ?? [],
            'onFileSelected': _handleFileUpload,
          },
        );
        break;

      case AttributeControlType.colorSquares:
        if (model.values?.isNotEmpty ?? false) {
          addRadioGroupField(
            model.id!,
            (model) => model,
            (model) => model.values!,
            (item) => item.colorSquaresRgb ?? '',
            (item) => item.id!,
            label: model.textPrompt ?? model.name ?? '',
            isRequired: model.isRequired ?? false,
            type: FormFieldType.radioColor,
            initalSelectedValues: model.defaultValue?.split(',') ??
                model.values!
                    .where((v) => v.isPreSelected ?? false)
                    .map((e) => e.id)
                    .toList(),
          );
        }
        break;

      case AttributeControlType.imageSquares:
        if (model.values?.isNotEmpty ?? false) {
          addRadioGroupField(
            model.id!,
            (model) => model,
            (model) => model.values!,
            (item) => item.name ?? '',
            (item) => item.id!,
            label: model.textPrompt ?? model.name ?? '',
            isRequired: model.isRequired ?? false,
            type: FormFieldType.image,
            initalSelectedValues: model.defaultValue?.split(',') ??
                model.values!
                    .where((v) => v.isPreSelected ?? false)
                    .map((e) => e.id)
                    .toList(),
          );
        }
        break;

      case AttributeControlType.hidden:
        addField(
          model.id!,
          (model) => model.defaultValue,
          type: FormFieldType.hidden,
        );
        break;
      case null:
        throw UnimplementedError();
    }
  }

  Future<String> _handleFileUpload(String fieldName, File? file) async {
    if (file != null && file.existsSync()) {
      var response = await (await getIt.getAsync<ShoppingCartRepository>())
          .postShoppingCartUploadFileCheckoutAttribute(model.id!, file);
      if (response?.data?.success ?? false) {
        return response!.data!.downloadGuid!;
      } else if (response?.data?.message?.isNotEmpty ?? false) {
        toast(response!.data!.message!);
      }
    }

    return "";
  }
}
