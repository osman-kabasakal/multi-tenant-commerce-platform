class FormProviderState {
  final Map<String, dynamic> values;
  final Map<String, String?> errors;
  final bool isValid;
  final bool isDirty;
  final bool isTouched;

  const FormProviderState({
    required this.values,
    this.errors = const {},
    this.isValid = false,
    this.isDirty = false,
    this.isTouched = false,
  });

  FormProviderState copyWith({
    Map<String, dynamic>? values,
    Map<String, String?>? errors,
    bool? isValid,
    bool? isDirty,
    bool? isTouched,
  }) {
    return FormProviderState(
      values: values ?? this.values,
      errors: errors ?? this.errors,
      isValid: isValid ?? this.isValid,
      isDirty: isDirty ?? this.isDirty,
      isTouched: isTouched ?? this.isTouched,
    );
  }
}
