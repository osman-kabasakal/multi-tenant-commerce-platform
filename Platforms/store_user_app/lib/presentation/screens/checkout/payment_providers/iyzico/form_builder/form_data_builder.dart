import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:store_user_app/core/models/form/field_option.dart';
import 'package:store_user_app/core/services/form/form_builder.dart';
import 'package:store_user_app/core/services/form/form_field.dart';
import 'package:store_user_app/domain/entities/utilities/field_definition/field_definition.dart';
import 'package:store_user_app/presentation/screens/checkout/payment_providers/iyzico/view_models/dynamic_form_field.dart';

class FormDataBuilder extends FormBuilder<Map<String, FieldDefinition>> {
  FormDataBuilder(super.model) {
    var dyanmicFormFields = model.keys
        .where((x) =>
            x != 'cardToken' &&
            x != 'installment' &&
            x != 'use3dPayment' &&
            x != 'approveCartStoreWithIyzico')
        .map((key) {
      return DynamicFormField.fromJson(
          key,
          (jsonDecode(jsonEncode(model[key]!.toJson()))
              as Map<String, dynamic>));
    });
    for (var f in dyanmicFormFields) {
      _buildField(f);
    }
  }

  void _buildField(DynamicFormField field) {
    switch (field.type.toLowerCase()) {
      case 'text':
      case 'tel':
      case 'number':
      case 'email':
      case 'password':
        return _addTextField(field);
      case 'textarea':
        return _addMultilineTextField(field);
      case 'checkbox':
        return _addCheckbox(field);
      case 'radio':
        return _addRadioGroup(field);
      case 'select':
        return _addDropdown(field);
      default:
        return;
    }
  }

  String? _validateField(DynamicFormField field, dynamic value) {
    // Required field validation
    if (field.required && (value == null || value.toString().isEmpty)) {
      return field.validationMessages['required'];
    }

    if (value != null && value.toString().isNotEmpty) {
      // Pattern validation
      if (field.validations.containsKey('pattern')) {
        final pattern = RegExp(field.validations['pattern']);
        if (!pattern.hasMatch(value.toString())) {
          return field.validationMessages['pattern'];
        }
      }

      // Numeric validations
      if (field.type.toLowerCase() == 'number') {
        final numValue = num.tryParse(value.toString());
        if (numValue != null) {
          // Min validation
          if (field.validations.containsKey('min') &&
              numValue < field.validations['min']) {
            return field.validationMessages['min'];
          }
          // Max validation
          if (field.validations.containsKey('max') &&
              numValue > field.validations['max']) {
            return field.validationMessages['max'];
          }
        }
      }

      // Length validations
      if (field.validations.containsKey('minLength')) {
        if (value.toString().length < field.validations['minLength']) {
          return field.validationMessages['minLength'];
        }
      }
      if (field.validations.containsKey('maxLength')) {
        if (value.toString().length > field.validations['maxLength']) {
          return field.validationMessages['maxLength'];
        }
      }
    }

    return null;
  }

  void _addTextField(DynamicFormField field) {
    addField(field.name, (f) => f[field.name]!.value,
        label: field.label,
        isRequired: field.required,
        validation: (v) => _validateField(field, v),
        type: _getType(field.type),
        focusNode: FocusNode());
  }

  FormFieldType _getType(String type) {
    switch (type.toLowerCase()) {
      case 'tel':
        return FormFieldType.phone;
      case 'number':
        return FormFieldType.number;
      case 'email':
        return FormFieldType.email;
      case 'password':
        return FormFieldType.password;
      case 'textarea':
        return FormFieldType.multilineText;
      default:
        return FormFieldType.text;
    }
  }

  void _addCheckbox(DynamicFormField field) {
    addField(field.name, (f) => f[field.name]!.value,
            label: field.label,
            isRequired: field.required,
            validation: (v) => _validateField(field, v),
            type: FormFieldType.checkbox,
            focusNode: FocusNode())
        .setConfiguration('description', null);
  }

  void _addRadioGroup(DynamicFormField field) {
    addField(
      field.name,
      (f) => f[field.name]!.value,
      label: field.label,
      isRequired: field.required,
      validation: (v) => _validateField(field, v),
      type: FormFieldType.radio,
      focusNode: FocusNode(),
    ).setOptions(field.options!
        .map((e) => FieldOption(label: e.toString(), value: e.toString()))
        .toList());
  }

  void _addDropdown(DynamicFormField field) {
    addField(
      field.name,
      (f) => f[field.name]!.value,
      label: field.label,
      isRequired: field.required,
      validation: (v) => _validateField(field, v),
      type: FormFieldType.dropDown,
      focusNode: FocusNode(),
    ).setOptions(field.options!
        .map((e) => FieldOption(label: e.toString(), value: e.toString()))
        .toList());
  }

  void _addMultilineTextField(DynamicFormField field) {
    addMultilineTextField(
      field.name,
      (f) => f[field.name]!.value,
      label: field.label,
      isRequired: field.required,
      validation: (v) => _validateField(field, v),
      focusNode: FocusNode(),
    );
  }
}
