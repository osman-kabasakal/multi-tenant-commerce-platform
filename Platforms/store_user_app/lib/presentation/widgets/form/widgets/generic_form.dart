import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:store_user_app/core/constants/images.dart';
import 'package:store_user_app/core/constants/strings.dart';
import 'package:store_user_app/core/services/form/app_form_controller.dart';
import 'package:store_user_app/core/services/form/form_builder.dart';
import 'package:store_user_app/core/services/form/form_field.dart';
import 'package:store_user_app/core/utils/extensions/string_extensions.dart';
import 'package:store_user_app/core/utils/input_formatters/decimal_currency_input_formatter.dart';
import 'package:store_user_app/core/utils/input_formatters/phone_number_formatters.dart';
import 'package:store_user_app/presentation/widgets/form/widgets/app_check_field.dart';
import 'package:store_user_app/presentation/widgets/form/widgets/app_date_field.dart';
import 'package:store_user_app/presentation/widgets/form/widgets/app_dropdown_field.dart';
import 'package:store_user_app/presentation/widgets/form/widgets/app_radio_list_tile.dart';
import 'package:store_user_app/presentation/widgets/form/widgets/app_switch_field.dart';
import 'package:store_user_app/presentation/widgets/form/widgets/app_text_form_field.dart';

import 'app_file_field.dart';

class GenericForm<T> extends StatefulHookConsumerWidget {
  final FormBuilder<T> formBuilder;
  final AppFormController<T> controller;

  GenericForm({
    super.key,
    required this.formBuilder,
    AppFormController<T>? formController,
    void Function(String, dynamic)? onFieldChange,
    void Function(String, bool)? onFieldFocusChange,
    void Function()? onDispose,
  }) : controller =
      formController ??
          AppFormController<T>(
            formBuilder.build(),
            onFieldChange: onFieldChange,
            onFieldFocusChange: onFieldFocusChange,
            onDispose: onDispose,
          );

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GenericFormState<T>();
}

class _GenericFormState<T> extends ConsumerState<GenericForm<T>> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    try {
      widget.controller.dispose();
    } catch (e) {
      var debug = true;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.controller.mounted) return SizedBox.shrink();

    return Form(
      key: widget.controller.formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var field in widget.controller.fields.where(
                (f) => f.type != FormFieldType.hidden,
          ))
            Container(
              margin: EdgeInsets.only(bottom: 10, top: 10),
              child: _buildField(field, context, ref),
            ),
        ],
      ),
    );
  }

  Widget _buildField(
      IFormField<dynamic> field,
      BuildContext context,
      WidgetRef ref,
      ) {
    switch (field.type) {
      case FormFieldType.number:
        return AppTextFormField(
          textInputAction: TextInputAction.next,
          keyboardType:  TextInputType.number,
          enabled: !field.readonly,
          focusNode: widget.controller.getFocusNode(field.name),
          controller: widget.controller.getController(field.name),
          fieldSubmitted: (v) {
            // focusNodes[field.name]!.unfocus();
          },
          validator: (k) {
            return widget.controller.getErrors()[field.name];
          },
          fieldChanged: (value) {
            if (value == null || value.isEmpty) {
              widget.controller.updateField(field.name, null, false);
              return;
            }
            if (int.tryParse(value) == null) {
              widget.controller.updateField(field.name, 0, true);
              return;
            }
            widget.controller.updateField(field.name, value, false);
          },
          // controller: widget.controller.phoneController,
          hintText: field.configurations['hintText'],
          lefContentPadding: 5,
          labelText: field.label,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          prefixIcon: field.configurations['prefixIcon'],
          prefixIconData: field.configurations['prefixIconData'],
          suffixIcon: field.configurations['suffixIcon'],
          suffixIconData: field.configurations['suffixIconData'],
        );
      case FormFieldType.price:
        return AppTextFormField(
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.number,
          enabled: !field.readonly,
          focusNode: widget.controller.getFocusNode(field.name),
          controller: widget.controller.getController(field.name),
          fieldSubmitted: (v) {
            // focusNodes[field.name]!.unfocus();
          },
          validator: (k) {
            return widget.controller.getErrors()[field.name];
          },
          fieldChanged: (value) {
            widget.controller.updateField(
              field.name,
              value
                  .toDoubleFromCurrency(
                decimalSeparator: ',',
                thousandSeparator: '.',
              )
                  ?.toStringAsFixed(2),
              false,
            );
          },
          // controller: widget.controller.phoneController,
          hintText: field.configurations['hintText'],
          lefContentPadding: 5,
          labelText: field.label,
          inputFormatters: [
            DecimalCurrencyInputFormatter(
              decimalSeparator: '.',
              thousandSeparator: ',',
            ),
          ],
          prefixIcon: field.configurations['prefixIcon'],
          prefixIconData: field.configurations['prefixIconData'],
          suffixIcon: field.configurations['suffixIcon'],
          suffixIconData: field.configurations['suffixIconData'],
        );
      case FormFieldType.checkboxColor:
      case FormFieldType.checkbox:
        return FormField<IFormField<dynamic>>(
          initialValue: field,
          validator: (k) {
            return widget.controller.getErrors()[field.name];
          },
          enabled: !field.readonly,
          builder: (fieldState) {
            return AppCheckField(
              field: fieldState.value!,
              state: widget.controller.getFieldState(fieldState.value!.name)!,
              onChanged:
                  (fieldName, value) =>
                  widget.controller.updateField(field.name, value, false),
            );
          },
        );
      case FormFieldType.phone:
        return AppTextFormField(
          textInputAction: TextInputAction.next,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            PhoneNumberFormatter(),
          ],
          keyboardType: TextInputType.number,
          focusNode: widget.controller.getFocusNode(field.name),
          enabled: !field.readonly,
          controller: widget.controller.getController(field.name),
          fieldSubmitted: (v) {
            // focusNodes[field.name]!.unfocus();
          },
          validator: (k) {
            return widget.controller.getErrors()[field.name];
          },
          fieldChanged: (value) {
            widget.controller.updateField(field.name, value, false);
          },
          hintText: field.configurations['hintText'] ?? phoneHint,
          lefContentPadding: 5,
          prefixIcon: phoneIcon,
          labelText: field.label,
        );
      case FormFieldType.email:
        return AppTextFormField(
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.emailAddress,
          focusNode: widget.controller.getFocusNode(field.name),
          controller: widget.controller.getController(field.name),
          enabled: !field.readonly,
          fieldSubmitted: (v) {},
          validator: (k) {
            return widget.controller.getErrors()[field.name];
          },
          fieldChanged: (value) {
            widget.controller.updateField(field.name, value, false);
          },
          hintText: field.configurations['hintText'],
          labelText: field.label,
          inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
          prefixIcon: field.configurations['prefixIcon'],
          prefixIconData: field.configurations['prefixIconData'],
          suffixIcon: field.configurations['suffixIcon'],
          suffixIconData: field.configurations['suffixIconData'],
        );
      case FormFieldType.radioColor:
      case FormFieldType.radio:
        return FormField<IFormField<dynamic>>(
          initialValue: field,
          validator: (k) {
            return widget.controller.getErrors()[field.name];
          },
          enabled: !field.readonly,
          builder: (fieldState) {
            return AppRadioListTile(
              field: fieldState.value!,
              state: widget.controller.getFieldState(fieldState.value!.name)!,
              onChanged: (name, value) {
                widget.controller.updateField(name, value, false);
              },
            );
          },
        );
      case FormFieldType.date:
        return FormField<IFormField<dynamic>>(
          initialValue: field,
          validator: (k) {
            return widget.controller.getErrors()[field.name];
          },
          enabled: !field.readonly,
          builder: (fieldState) {
            return AppDateField(
              field: fieldState.value!,
              state: widget.controller.getFieldState(fieldState.value!.name)!,
              onChanged: widget.controller.updateField,
            );
          },
        );
      case FormFieldType.swwitch:
        return FormField<IFormField<dynamic>>(
          initialValue: field,
          validator: (k) {
            return widget.controller.getErrors()[field.name];
          },
          enabled: !field.readonly,
          builder: (fieldState) {
            return AppSwitchField(
              field: fieldState.value!,
              state: widget.controller.getFieldState(fieldState.value!.name)!,
              onChanged: widget.controller.updateField,
            );
          },
        );
      case FormFieldType.dropDown:
        return FormField<IFormField<dynamic>>(
          initialValue: field,
          validator: (k) {
            return widget.controller.getErrors()[field.name];
          },
          enabled: !field.readonly,
          builder: (fieldState) {
            return AppDropdownField(
              field: fieldState.value!,
              state: widget.controller.getFieldState(fieldState.value!.name)!,
              onChanged: widget.controller.updateField,
            );
          },
        );
      case FormFieldType.password:
        return AppTextFormField(
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.visiblePassword,
          focusNode: widget.controller.getFocusNode(field.name),
          obscureText: true,
          enabled: !field.readonly,
          controller: widget.controller.getController(field.name),
          fieldSubmitted: (v) {},
          validator: (k) {
            return widget.controller.getErrors()[field.name];
          },
          fieldChanged: (value) {
            widget.controller.updateField(field.name, value);
          },
          hintText: field.configurations['hintText'],
          labelText: field.label,
          prefixIcon: field.configurations['prefixIcon'],
          prefixIconData: field.configurations['prefixIconData'],
          suffixIcon: field.configurations['suffixIcon'],
          suffixIconData: field.configurations['suffixIconData'],
        );
      case FormFieldType.text:
        return AppTextFormField(
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.text,
          focusNode: widget.controller.getFocusNode(field.name),
          enabled: !field.readonly,
          controller: widget.controller.getController(field.name),
          fieldSubmitted: (v) {
            // focusNodes[field.name]!.unfocus();
          },
          validator: (k) {
            return widget.controller.getErrors()[field.name];
          },
          fieldChanged: (value) {
            widget.controller.updateField(field.name, value);
          },
          hintText: field.configurations['hintText'],
          labelText: field.label,
          prefixIcon: field.configurations['prefixIcon'],
          prefixIconData: field.configurations['prefixIconData'],
          suffixIcon: field.configurations['suffixIcon'],
          suffixIconData: field.configurations['suffixIconData'],
        );
      case FormFieldType.multilineText:
        return AppTextFormField(
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.multiline,
          focusNode: widget.controller.getFocusNode(field.name),
          enabled: !field.readonly,
          controller: widget.controller.getController(field.name),
          fieldSubmitted: (v) {
            // focusNodes[field.name]!.unfocus()
          },
          validator: (k) {
            return widget.controller.getErrors()[field.name];
          },
          fieldChanged: (value) {
            widget.controller.updateField(field.name, value);
          },
          lines: field.lines,
          hintText: field.configurations['hintText'],
          labelText: field.label,
          prefixIcon: field.configurations['prefixIcon'],
          prefixIconData: field.configurations['prefixIconData'],
          suffixIcon: field.configurations['suffixIcon'],
          suffixIconData: field.configurations['suffixIconData'],
        );
      case FormFieldType.file:
        return FormField<IFormField<dynamic>>(
          initialValue: field,
          validator: (k) {
            return widget.controller.getErrors()[field.name];
          },
          enabled: !field.readonly,
          builder: (fieldState) {
            return AppFileField(
              field: fieldState.value!,
              state: widget.controller.getFieldState(fieldState.value!.name)!,
              onChanged: widget.controller.updateField,
              onFileSelected: field.configurations['onFileSelected'],
            );
          },
        );
      default:
        return SizedBox.shrink();
    }
  }
}
