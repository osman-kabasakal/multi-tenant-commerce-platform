import '../../models/form/field_option.dart';

enum FormFieldType {
  text,
  multilineText,
  number,
  price,
  checkbox,
  phone,
  email,
  radio,
  date,
  swwitch,
  dropDown,
  password,
  hidden,
  file,
  image,
  radioColor,
  checkboxColor,
}

enum FieldState { VALID, INVALID, EMPTY, FOCUS, BLUR, INITIAL }

abstract class IFormField<T> {
  // Temel özellikler
  String get name;
  String get label;
  FormFieldType get type;
  bool get isRequired;
  bool get readonly;

  int? get lines;

  // Durum yönetimi
  // AppFormFieldState<T> get state;

  // Validation
  String? validate(T? value);
  // bool get isValid;

  // Dropdown, Radio ve Checkbox grupları için gerekli özellikler
  List<FieldOption<TOption>>? getOptions<TOption>();
  void setOptions<TOption>(List<FieldOption<TOption>> options);

  // // Field'ın durumunu sıfırlama
  // void reset();

  // Field'ı disable/enable etme
  void setReadOnly(bool value);

  // Field için özel konfigürasyonlar
  Map<String, dynamic> get configurations;
  void setConfiguration(String key, dynamic value);
  void setHintText(String text);
}
