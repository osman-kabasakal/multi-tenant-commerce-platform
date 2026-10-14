import 'dart:io';

import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/services/form/form_builder.dart';
import 'package:store_user_app/core/services/form/form_field.dart';
import 'package:store_user_app/domain/entities/catalog/attribute_control_type/attribute_control_type.dart';
import 'package:store_user_app/domain/entities/models/catalog/product_details_model/product_attribute_model/product_attribute_model.dart';
import 'package:store_user_app/domain/entities/models/catalog/product_details_model/product_attribute_value_model/product_attribute_value_model.dart';
import 'package:store_user_app/domain/repositories/product/product_repository.dart';

class ProductAttributeFormBuilder extends FormBuilder<ProductAttributeModel> {
  ProductAttributeFormBuilder(super.model) {
    _addCustomAttributeFields(model);
  }

  void _addCustomAttributeFields(ProductAttributeModel element) {
    switch (element.attributeControlType) {
      case null:
        // TODO: Handle this case.
        throw UnimplementedError();
      case AttributeControlType.dropdownList:
        addDropDownField<String, ProductAttributeValueModel, String>(
          getAttributeKey(element),
          (model) => "",
          (v) => element.values ?? [],
          (v) =>
              '${v.name ?? ''} ${(v.priceAdjustment.isEmptyOrNull ? '' : '[${v.priceAdjustment ?? ''}]')}',
          (v) => v.id!,
          initalSelectedValues:
              element.values
                  ?.where((v) => v.isPreSelected ?? false)
                  .map((x) => x.id!)
                  .toList() ??
              [],
          label: element.name,
          isRequired: element.isRequired ?? false,
        );

      case AttributeControlType.radioList:
        addRadioGroupField<String, ProductAttributeValueModel, String>(
          getAttributeKey(element),
          (model) => "",
          (v) => element.values ?? [],
          (v) =>
              '${v.name ?? ''} ${(v.priceAdjustment.isEmptyOrNull ? '' : '[${v.priceAdjustment ?? ''}]')}',
          (v) => v.id!,
          initalSelectedValues:
              element.values
                  ?.where((v) => v.isPreSelected ?? false)
                  .map((x) => x.id!)
                  .toList() ??
              [],
          label: element.name,
          isRequired: element.isRequired ?? false,
        );

      case AttributeControlType.checkboxes:
        addCheckboxGroupField<String, ProductAttributeValueModel, String>(
          getAttributeKey(element),
          (model) => "",
          (v) => element.values ?? [],
          (v) =>
              '${v.name ?? ''} ${(v.priceAdjustment.isEmptyOrNull ? '' : '[${v.priceAdjustment ?? ''}]')}',
          (v) => v.id!,
          initalSelectedValues:
              element.values
                  ?.where((v) => v.isPreSelected ?? false)
                  .map((x) => x.id!)
                  .toList() ??
              [],
          label: element.name,
          isRequired: element.isRequired ?? false,
        );
      case AttributeControlType.textBox:
        addField(
          getAttributeKey(element),
          (model) => element.defaultValue,
          label: element.name ?? '',
          isRequired: element.isRequired ?? false,
        ).setHintText(element.textPrompt ?? '');
        break;
      case AttributeControlType.hidden:
        addField(
          getAttributeKey(element),
          (model) => element.defaultValue,
          type: FormFieldType.hidden,
        );
      case AttributeControlType.multilineTextbox:
        addMultilineTextField(
          getAttributeKey(element),
          (model) => element.defaultValue,
          label: element.name,
          isRequired: element.isRequired ?? false,
        ).setHintText(element.textPrompt ?? '');
      case AttributeControlType.datepicker:
        addField(
          getAttributeKey(element),
          (model) =>
              element.defaultValue != null
                  ? DateTime.parse(element.defaultValue!)
                  : DateTime.now(),
          label: element.name,
          isRequired: element.isRequired ?? false,
          type: FormFieldType.date,
        );
      case AttributeControlType.fileUpload:
        addField(
          getAttributeKey(element),
          (model) => element.defaultValue,
          label:
              (element.textPrompt ?? (element.name ?? '')) +
              (element.values?.firstOrNull?.priceAdjustment.isEmptyOrNull ??
                      true
                  ? ''
                  : ' (${element.values?.firstOrNull?.priceAdjustment})'),
          isRequired: element.isRequired ?? false,
          type: FormFieldType.file,
          configurations: {
            'allowedExtensions': element.allowedFileExtensions ?? [],
            'onFileSelected': _handleFileUpload,
          },
        );
        break;
      case AttributeControlType.colorSquares:
        addRadioGroupField<String, ProductAttributeValueModel, String>(
          getAttributeKey(element),
          (model) => "",
          (v) => element.values ?? [],
          (v) => v.colorSquaresRgb ?? '#000000',
          (v) => v.id!,
          initalSelectedValues:
              element.values
                  ?.where((v) => v.isPreSelected ?? false)
                  .map((x) => x.id!)
                  .toList() ??
              [],
          label: element.name,
          type: FormFieldType.radioColor,
          isRequired: element.isRequired ?? false,
        );
      case AttributeControlType.imageSquares:
        // TODO: Handle this case.
        throw UnimplementedError();
      case AttributeControlType.readonlyCheckboxes:
        addCheckboxGroupField<String, ProductAttributeValueModel, String>(
          getAttributeKey(element),
          (model) => "",
          (v) => element.values ?? [],
          (v) =>
              '${v.name ?? ''} ${(v.priceAdjustment.isEmptyOrNull ? '' : '[${v.priceAdjustment ?? ''}]')}',
          (v) => v.id!,
          initalSelectedValues:
              element.values
                  ?.where((v) => v.isPreSelected ?? false)
                  .map((x) => x.id!)
                  .toList() ??
              [],
          label: element.name,
          isRequired: element.isRequired ?? false,
          readonly: true,
        );
    }
  }

  String getAttributeKey(ProductAttributeModel attribute) {
    return '${attribute.id}';
  }

  Future<String> _handleFileUpload(String fieldName, File? file) async {
    if (file != null && file.existsSync()) {
      var response = await (await getIt.getAsync<ProductRepository>())
          .postProductUploadFileProductAttribute(
            fieldName.split('_')[1],
            model.productId!,
            file,
          );
      if (response?.data?.success ?? false) {
        return response!.data!.downloadGuid!;
      } else if (response?.data?.message?.isNotEmpty ?? false) {
        toast(response!.data!.message!);
      }
    }

    return "";
  }
}
