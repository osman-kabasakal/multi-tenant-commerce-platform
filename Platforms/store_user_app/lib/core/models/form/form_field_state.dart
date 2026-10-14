class AppFormFieldState<T> {
  final T? value;
  final String? error;
  final bool isDirty;
  final bool isTouched;
  final bool isFocused;
  final bool isValid;

  const AppFormFieldState({
    this.value,
    this.error,
    this.isDirty = false,
    this.isTouched = false,
    this.isFocused = false,
    this.isValid = false,
  });

  AppFormFieldState<T> copyWith({
    T? value,
    String? error,
    bool? isDirty,
    bool? isTouched,
    bool? isFocused,
    bool? isValid,
  }) {
    return AppFormFieldState<T>(
      value: value ?? this.value,
      error: error ?? this.error,
      isDirty: isDirty ?? this.isDirty,
      isTouched: isTouched ?? this.isTouched,
      isFocused: isFocused ?? this.isFocused,
      isValid: isValid ?? this.isValid,
    );
  }
}
