import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:store_user_app/core/models/form/form_field_state.dart';
import 'package:store_user_app/core/services/form/form_field_impl.dart';

class AppFormController<T>
    extends StateNotifier<Map<String, AppFormFieldState>> {
  final List<FormFieldImpl> fields;
  final FieldChangeCallback? onFieldChange;
  final void Function(String fieldName, bool hasFocus)? onFieldFocusChange;
  final ValueNotifier<bool> onSubmit = ValueNotifier(false);
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final VoidCallback? onDispose;

  // Field'ları izlemek için map'ler
  final Map<String, FocusNode> _focusNodes = {};
  final Map<String, TextEditingController> _controllers = {};

  AppFormController(
      this.fields, {
        this.onFieldChange,
        this.onFieldFocusChange,
        this.onDispose,
      }) : super({}) {
    _initializeFields();
  }

  // Field'ları başlat
  void _initializeFields() {
    for (final field in fields) {
      // State'i başlat
      state[field.name] = AppFormFieldState(
        value: field.initialValue,
        isValid: _validInitialField(field) == null,
      );

      // Focus node'u kaydet
      _focusNodes[field.name] = field.focusNode;

      // Controller varsa kaydet
      if (field.controller != null) {
        _controllers[field.name] = field.controller!;
      }

      // Focus değişikliklerini dinle
      field.focusNode.addListener(() {
        _handleFocusChange(field.name, field.focusNode.hasFocus);
      });
    }
  }

  String? _validInitialField(FormFieldImpl field) {
    try {
      return field.validate(field.initialValue);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('AppFormController _validInitialField error: $e');
      }
    }
    return null;
  }

  final Map<String, Timer> _debounceTimers = {};
  final Duration _debounceDuration = Duration(milliseconds: 300);

  // Field değerini güncelle
  void updateField(
      String fieldName,
      dynamic value, [
        bool updateController = false,
      ]) {
    if (_debounceTimers.containsKey(fieldName)) {
      _debounceTimers[fieldName]?.cancel();
    }

    _debounceTimers[fieldName] = Timer(_debounceDuration, () {
      final field = fields.firstWhere((f) => f.name == fieldName);
      var valueCast = field.valueCast(value);
      final error = field.validate(valueCast);
      var ctrl = getController(fieldName);
      if (updateController && ctrl != null && ctrl.text != value) {
        ctrl.text = value;
      }

      state = {
        ...state,
        fieldName: AppFormFieldState(
          value: valueCast,
          error: error,
          isDirty: true,
          isTouched: true,
          isValid: error == null,
        ),
      };

      onFieldChange?.call(fieldName, value);
      _debounceTimers.remove(fieldName);
    });
  }

  // Focus değişikliğini işle
  void _handleFocusChange(String fieldName, bool hasFocus) {
    final currentState = state[fieldName];
    if (currentState != null) {
      final field = fields.firstWhere((f) => f.name == fieldName);
      final error = field.validate(currentState.value);
      state = {
        ...state.map(
              (key, value) => MapEntry(key, value.copyWith(isFocused: false)),
        ),
        fieldName: currentState.copyWith(
          isFocused: hasFocus,
          isTouched: true,
          error: error,
          isValid: error == null,
        ),
      };

      onFieldFocusChange?.call(fieldName, hasFocus);
    }
  }

  // Form değerlerini al
  Map<String, dynamic> getValues() {
    return state.map((key, value) => MapEntry(key, value.value));
  }

  // Formu doğrula
  bool validate() {
    bool isValid = true;
    final newState = Map<String, AppFormFieldState>.from(state);

    for (final field in fields) {
      final currentState = state[field.name];
      final error = field.validate(currentState?.value);

      newState[field.name] = newState[field.name]!.copyWith(
        value: currentState?.value,
        error: error,
        isDirty: true,
        isTouched: true,
        isValid: error == null,
      );

      if (error != null) {
        isValid = false;
      }
    }

    state = newState;
    return isValid;
  }

  // Formu submit et
  bool submit() {
    var isValid = validate();
    onSubmit.value = isValid;
    formKey.currentState?.validate();
    var errState =
        state.entries.where((v) => v.value.error != null).firstOrNull;
    if (errState != null) {
      setFocus(errState.key);
    }
    return isValid;
  }

  // Field'ı resetle
  void resetField(String fieldName) {
    final field = fields.firstWhere((f) => f.name == fieldName);
    var newFieldState = AppFormFieldState(
      value: field.initialValue,
      isValid: field.validate(field.initialValue) == null,
    );
    if (field.initialValue != null && field.initialValue is String) {
      field.controller?.text = field.initialValue;
    } else {
      field.controller?.clear();
    }
    state = {...state, fieldName: newFieldState};
  }

  // Tüm formu resetle
  void reset() {
    final newState = <String, AppFormFieldState>{};
    for (final field in fields) {
      var controller = getController(field.name);
      if (field.initialValue != null && field.initialValue is String) {
        controller?.text = field.initialValue;
      } else {
        controller?.clear();
      }
      //  = field.initialValue;
      newState[field.name] = AppFormFieldState(
        value: field.initialValue,
        isValid: field.validate(field.initialValue) == null,
      );
    }
    state = newState;
  }

  // Field focus'unu değiştir
  void setFocus(String fieldName) {
    final focusNode = _focusNodes[fieldName];
    if (focusNode != null && !focusNode.hasFocus) {
      focusNode.requestFocus();
    }
  }

  // Controller'ı al
  TextEditingController? getController(String fieldName) {
    return _controllers[fieldName];
  }

  // Field durumunu al
  AppFormFieldState? getFieldState(String fieldName) {
    return state[fieldName];
  }

  FocusNode getFocusNode(String fieldName) {
    return _focusNodes[fieldName]!;
  }

  // Formdaki tüm hataları al
  Map<String, String> getErrors() {
    return state.map((key, value) => MapEntry(key, value.error ?? ''))
      ..removeWhere((key, value) => value.isEmpty);
  }

  void setValidator(String fieldName, ValidationCallback validator) {
    final field = fields.firstWhere((f) => f.name == fieldName);
    var index = fields.indexOf(field);

    fields.remove(field);
    fields.insert(index, field.copyWith(validator: validator));
    state = {...state};
  }

  // Form geçerli mi?
  bool get isValid => state.values.every((field) => field.isValid);

  // Form dirty mi?
  bool get isDirty => state.values.any((field) => field.isDirty);

  // Form touched mu?
  bool get isTouched => state.values.any((field) => field.isTouched);

  @override
  void dispose() {
    try {
      onDispose?.call();
      for (var controller in _controllers.values) {
        controller.dispose();
      }
      for (final node in _focusNodes.values) {
        node.dispose();
      }

      onSubmit.dispose();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('AppFormController dispose error: $e');
      }
    }
    super.dispose();
  }
}
