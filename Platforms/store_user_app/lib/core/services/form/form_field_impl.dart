import 'package:flutter/widgets.dart';
import 'package:store_user_app/core/models/form/field_option.dart';
import 'package:store_user_app/core/services/form/form_field.dart';

typedef FieldChangeCallback = void Function(String fieldName, dynamic value);
typedef ValidationCallback = String? Function(dynamic value);

class FormFieldImpl<T> implements IFormField<T> {
  @override
  final String name;

  @override
  final String label;

  @override
  final FormFieldType type;

  @override
  final bool isRequired;

  @override
  bool readonly;

  T? initialValue;
  List<FieldOption<dynamic>>? _options;
  final Map<String, dynamic> _configurations = {};

  final ValidationCallback? validator;
  final List<ValidationCallback> validators;
  final FocusNode focusNode;
  final TextEditingController? controller;

  FormFieldImpl({
    required this.name,
    required this.label,
    required this.type,
    this.isRequired = false,
    this.readonly = false,
    this.initialValue,
    this.lines,
    this.validator,
    this.validators = const [],
    FocusNode? focusNode,
    this.controller,
  }) : focusNode = focusNode ?? FocusNode();

  @override
  String? validate(T? value) {
    if (isRequired && (value == null || value.toString().isEmpty)) {
      return '$label bilgisi zorunludur';
    }

    if (validator != null) {
      final error = validator!(value);
      if (error != null) return error;
    }

    for (final validator in validators) {
      final error = validator(value);
      if (error != null) return error;
    }

    return null;
  }

  T? valueCast(dynamic value) {
    if (value == null || (value is String && value.isEmpty)) return null;
    if (value is T || value is T?) return value;
    if (value is List) {
      // Handle list types based on generic type parameter
      if (T.toString() == 'List<String>' || T.toString() == 'List<String?>') {
        return value
                .where((element) => element != null)
                .map((e) => e!.toString())
                .toList()
            as T?;
      } else if (T.toString() == 'List<int>' || T.toString() == 'List<int?>') {
        return value
                .map((e) => e != null ? int.tryParse(e.toString()) : null)
                .toList()
            as T?;
      } else if (T.toString() == 'List<double>' ||
          T.toString() == 'List<double?>') {
        return value
                .map((e) => e != null ? double.tryParse(e.toString()) : null)
                .toList()
            as T?;
      } else if (T.toString() == 'List<bool>' ||
          T.toString() == 'List<bool?>') {
        return value
                .map((e) => e != null ? e.toString() == 'true' : null)
                .toList()
            as T?;
      }
      // If no specific type matching, return the original dynamic list
      return value as T?;
    }
    switch (type) {
      case FormFieldType.text:
      case FormFieldType.multilineText:
      case FormFieldType.email:
      case FormFieldType.password:
      case FormFieldType.phone:
      case FormFieldType.hidden:
      case FormFieldType.file:
      case FormFieldType.image:
        return value as T?;
      case FormFieldType.number:
        final parsedInt = int.tryParse(value.toString());
        if (parsedInt != null) {
          if (T.toString() == 'String?' || T.toString() == 'string?') {
            return parsedInt.toString() as T?;
          }
          return parsedInt as T?;
        }
        break;
      case FormFieldType.price:
        final parsedDouble = double.tryParse(value.toString());
        if (parsedDouble != null) {
          return parsedDouble as T?;
        }
        break;
      case FormFieldType.checkbox:
      case FormFieldType.swwitch:
      case FormFieldType.checkboxColor:
        if (value.toLowerCase() == 'true' || value.toLowerCase() == 'false') {
          return (value.toLowerCase() == 'true') as T?;
        }
        break;
      case FormFieldType.date:
        try {
          return DateTime.parse(value.toString()) as T?;
        } catch (_) {
          // Return as is if parsing fails
        }
        break;
      case FormFieldType.radio:
      case FormFieldType.radioColor:
      case FormFieldType.dropDown:
        // For these types, typically return value as is
        return value as T?;
      default:
        // For other types, try to return as is if possible
        break;
    }

    // Fallback to direct cast if no specific handling
    return value as T?;
  }

  @override
  List<FieldOption<TOption>>? getOptions<TOption>() {
    return _options?.cast<FieldOption<TOption>>();
  }

  @override
  void setOptions<TOption>(List<FieldOption<TOption>> options) {
    _options = options.cast<FieldOption<dynamic>>();
  }

  @override
  void setReadOnly(bool value) {
    readonly = value;
  }

  @override
  Map<String, dynamic> get configurations => _configurations;

  @override
  void setConfiguration(String key, dynamic value) {
    _configurations[key] = value;
  }

  @override
  void setHintText(String text) {
    _configurations['hintText'] = text;
  }

  @override
  int? lines;

  FormFieldImpl<T> copyWith({
    String? name,
    String? label,
    FormFieldType? type,
    bool? isRequired,
    bool? readonly,
    T? initialValue,
    List<FieldOption<dynamic>>? options,
    Map<String, dynamic>? configurations,
    ValidationCallback? validator,
    List<ValidationCallback>? validators,
    FocusNode? focusNode,
    TextEditingController? controller,
  }) {
    return FormFieldImpl<T>(
      name: name ?? this.name,
      label: label ?? this.label,
      type: type ?? this.type,
      isRequired: isRequired ?? this.isRequired,
      readonly: readonly ?? this.readonly,
      initialValue: initialValue ?? this.initialValue,
      lines: lines ?? this.lines,
      validator: validator ?? this.validator,
      validators: validators ?? this.validators,
      focusNode: focusNode ?? this.focusNode,
      controller: controller ?? this.controller,
    );
  }
}
