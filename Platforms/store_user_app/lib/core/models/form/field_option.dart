class FieldOption<T> {
  final String label;
  final T value;
  final bool disabled;
  final bool selected;

  const FieldOption(
      {required this.label,
      required this.value,
      this.disabled = false,
      this.selected = false});
}
