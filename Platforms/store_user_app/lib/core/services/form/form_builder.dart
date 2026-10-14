import 'package:flutter/material.dart';
import 'package:store_user_app/core/models/form/field_option.dart';
import 'package:store_user_app/core/services/form/form_field.dart';
import 'package:store_user_app/core/services/form/form_field_impl.dart';

typedef AddFieldExpression<TFormModel, TField> = TField Function(
    TFormModel model);

typedef SelectExpression<Tmodel, TField> = TField Function(Tmodel model);

class FormBuilder<TFormModel> {
  late final TFormModel model;
  FormBuilder(this.model);

  final Map<AddFieldExpression<TFormModel, dynamic>, FormFieldImpl<dynamic>>
      _fields = {};

  FormFieldImpl<TField> addField<TField>(
    String name,
    AddFieldExpression<TFormModel, TField> addFieldExpression, {
    String? label,
    bool isRequired = false,
    bool readonly = false,
    ValidationCallback? validation,
    List<ValidationCallback> validations = const [],
    FocusNode? focusNode,
    FormFieldType? type,
    Map<String, dynamic> configurations = const {},
  }) {
    var typeDecision = type ?? getFieldType<TField>();

    var textController = typeDecision != FormFieldType.checkbox &&
            typeDecision != FormFieldType.radio &&
            typeDecision != FormFieldType.swwitch &&
            typeDecision != FormFieldType.date &&
            typeDecision != FormFieldType.dropDown &&
            typeDecision != FormFieldType.file &&
            typeDecision != FormFieldType.image &&
            typeDecision != FormFieldType.radioColor &&
            typeDecision != FormFieldType.checkboxColor
        ? TextEditingController(text: addFieldExpression(model)?.toString())
        : null;
    _fields[addFieldExpression] = FormFieldImpl<TField>(
      name: name,
      label: (label ?? '') + (isRequired ? ' *' : ''),
      isRequired: isRequired,
      readonly: readonly,
      type: typeDecision,
      initialValue: addFieldExpression(model),
      controller: textController,
      validator: validation,
      validators: validations,
      focusNode: focusNode,
    );

    for (var confKey in configurations.keys) {
      _fields[addFieldExpression]!
          .setConfiguration(confKey, configurations[confKey]);
    }

    if (_fields[addFieldExpression]!.type == FormFieldType.checkbox) {
      _fields[addFieldExpression]!
          .setConfiguration('description', label ?? name);
    }
    return _fields[addFieldExpression]! as FormFieldImpl<TField>;
  }

  FormFieldImpl<TField> addMultilineTextField<TField>(
    String name,
    AddFieldExpression<TFormModel, TField> addFieldExpression, {
    String? label,
    int lines = 3,
    bool isRequired = false,
    bool readonly = false,
    ValidationCallback? validation,
    List<ValidationCallback> validations = const [],
    FocusNode? focusNode,
  }) {
    _fields[addFieldExpression] = FormFieldImpl<TField>(
      name: name,
      label: (label ?? '') + (isRequired ? ' *' : ''),
      isRequired: isRequired,
      readonly: readonly,
      type: FormFieldType.multilineText,
      lines: lines,
      initialValue: addFieldExpression(model),
      controller:
          TextEditingController(text: addFieldExpression(model)?.toString()),
      validator: validation,
      validators: validations,
      focusNode: focusNode,
    );
    return _fields[addFieldExpression]! as FormFieldImpl<TField>;
  }

  FormFieldImpl<TDropddownValue>
      addDropDownField<TField, TListModel, TDropddownValue>(
    String name,
    AddFieldExpression<TFormModel, TField> fieldExpression,
    AddFieldExpression<TFormModel, List<TListModel>> valuesExpression,
    SelectExpression<TListModel, String> nameExpression,
    SelectExpression<TListModel, TDropddownValue> valueExpression, {
    String? label,
    bool isRequired = false,
    bool readonly = false,
    List<TDropddownValue>? initalSelectedValues,
    ValidationCallback? validation,
    List<ValidationCallback> validations = const [],
    FocusNode? focusNode,
  }) {
    _fields[fieldExpression] = FormFieldImpl<TDropddownValue>(
      name: name,
      label: label ?? '',
      isRequired: isRequired,
      readonly: readonly,
      type: FormFieldType.dropDown,
      validator: validation,
      validators: validations,
      focusNode: focusNode,
      initialValue: initalSelectedValues?.firstOrNull,
    )..setOptions(valuesExpression(model).map((e) {
        return FieldOption<TDropddownValue>(
            label: nameExpression(e),
            value: valueExpression(e),
            selected:
                initalSelectedValues?.contains(valueExpression(e)) ?? false,
            disabled: readonly);
      }).toList());
    return _fields[fieldExpression]! as FormFieldImpl<TDropddownValue>;
  }

  FormFieldImpl<List<TDropddownValue>>
      addCheckboxGroupField<TField, TListModel, TDropddownValue>(
    String name,
    AddFieldExpression<TFormModel, TField> fieldExpression,
    AddFieldExpression<TFormModel, List<TListModel>> valuesExpression,
    SelectExpression<TListModel, String> nameExpression,
    SelectExpression<TListModel, TDropddownValue> valueExpression, {
    String? label,
    bool readonly = false,
    bool isRequired = false,
    List<TDropddownValue>? initalSelectedValues,
    ValidationCallback? validation,
    List<ValidationCallback> validations = const [],
    FocusNode? focusNode,
    FormFieldType type = FormFieldType.checkbox,
  }) {
    _fields[fieldExpression] = FormFieldImpl<List<TDropddownValue>>(
      name: name,
      label: label ?? '',
      isRequired: isRequired,
      readonly: readonly,
      type: type,
      validator: validation,
      validators: validations,
      focusNode: focusNode,
      initialValue: initalSelectedValues,
    )..setOptions(valuesExpression(model).map((e) {
        return FieldOption<TDropddownValue>(
            label: nameExpression(e),
            value: valueExpression(e),
            selected:
                initalSelectedValues?.contains(valueExpression(e)) ?? false,
            disabled: readonly);
      }).toList());
    return _fields[fieldExpression] as FormFieldImpl<List<TDropddownValue>>;
  }

  FormFieldImpl<TField> addRadioField<TField>(
    String name,
    String label,
    AddFieldExpression<TFormModel, TField> addFieldExpression, {
    bool readonly = false,
    bool isRequired = false,
    ValidationCallback? validation,
    List<ValidationCallback> validations = const [],
    FocusNode? focusNode,
  }) {
    _fields[addFieldExpression] = FormFieldImpl<TField>(
      name: name,
      label: label,
      isRequired: isRequired,
      readonly: readonly,
      type: FormFieldType.radio,
      initialValue: addFieldExpression(model),
      validator: validation,
      validators: validations,
      focusNode: focusNode,
    );
    return _fields[addFieldExpression] as FormFieldImpl<TField>;
  }

  FormFieldImpl<bool> addSwitchField(
    String name,
    String label,
    AddFieldExpression<TFormModel, bool> addFieldExpression, {
    bool readonly = false,
    bool isRequired = false,
    ValidationCallback? validation,
    List<ValidationCallback> validations = const [],
    FocusNode? focusNode,
    Map<String, dynamic> configurations = const {},
  }) {
    _fields[addFieldExpression] = FormFieldImpl<bool>(
      name: name,
      label: label,
      isRequired: isRequired,
      readonly: readonly,
      type: FormFieldType.swwitch,
      validator: validation,
      validators: validations,
      focusNode: focusNode,
      initialValue: addFieldExpression(model),
    );
    for (var confKey in configurations.keys) {
      _fields[addFieldExpression]!
          .setConfiguration(confKey, configurations[confKey]);
    }
    return _fields[addFieldExpression] as FormFieldImpl<bool>;
  }

  FormFieldImpl<TDropddownValue>
      addRadioGroupField<TField, TListModel, TDropddownValue>(
    String name,
    AddFieldExpression<TFormModel, TField> fieldExpression,
    AddFieldExpression<TFormModel, List<TListModel>> valuesExpression,
    SelectExpression<TListModel, String> nameExpression,
    SelectExpression<TListModel, TDropddownValue> valueExpression, {
    String? label,
    bool readonly = false,
    bool isRequired = false,
    FormFieldType type = FormFieldType.radio,
    List<TDropddownValue>? initalSelectedValues,
    ValidationCallback? validation,
    List<ValidationCallback> validations = const [],
    FocusNode? focusNode,
  }) {
    _fields[fieldExpression] = FormFieldImpl<TDropddownValue>(
      name: name,
      label: label ?? '',
      isRequired: isRequired,
      readonly: readonly,
      type: type,
      validator: validation,
      validators: validations,
      focusNode: focusNode,
      initialValue: initalSelectedValues?.firstOrNull,
    )..setOptions(valuesExpression(model).map((e) {
        return FieldOption<TDropddownValue>(
            label: nameExpression(e),
            value: valueExpression(e),
            selected:
                initalSelectedValues?.contains(valueExpression(e)) ?? false,
            disabled: readonly);
      }).toList());
    return _fields[fieldExpression] as FormFieldImpl<TDropddownValue>;
  }

  FormFieldImpl<TField> getField<TField>(
      AddFieldExpression<TFormModel, TField> addFieldExpression) {
    return _fields[addFieldExpression] as FormFieldImpl<TField>;
  }

  void removeField<TField>(
      AddFieldExpression<TFormModel, TField> addFieldExpression) {
    _fields.remove(addFieldExpression);
  }

  void clearFields() {
    _fields.clear();
  }

  List<FormFieldImpl<dynamic>> build() {
    return _fields.values.toList();
  }

  final fieldTypeMap = {
    'String': FormFieldType.text,
    'int': FormFieldType.number,
    'double': FormFieldType.number,
    'bool': FormFieldType.swwitch,
  };

  FormFieldType getFieldType<TField>() {
    return fieldTypeMap[TField.toString().replaceAll('?', '')] ??
        FormFieldType.text;
  }
}
