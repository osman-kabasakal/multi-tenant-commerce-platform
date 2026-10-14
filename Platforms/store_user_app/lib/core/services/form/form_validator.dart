import 'package:store_user_app/core/services/form/form_field.dart';

abstract class IFormValidator {
  String? validate<T>(
    IFormField<T> field,
    T? value,
    List<String> rules,
  );
}

class DefaultFormValidator implements IFormValidator {
  @override
  String? validate<T>(
    IFormField<T> field,
    T? value,
    List<String> rules,
  ) {
    if (field.isRequired && (value == null || value.toString().isEmpty)) {
      return 'Lütfen ${field.label} bilgisini giriniz';
    }

    // Tip bazlı default validasyonlar
    switch (field.type) {
      case FormFieldType.text:
      case FormFieldType.multilineText:
        if (value != null && value is String) {
          if (rules.contains('min:3') && value.length < 3) {
            return '${field.label} 3 karakterden az olamaz';
          }
        }
        break;
      case FormFieldType.number:
        if (value != null && value is num) {
          if (rules.contains('positive') && value < 0) {
            return '${field.label} pozitif bir değer olmalıdır';
          }
        }
        break;
      // Diğer tipler için validasyonlar...
      case FormFieldType.checkbox:
      case FormFieldType.phone:
      case FormFieldType.email:
      case FormFieldType.radio:
      case FormFieldType.date:
      case FormFieldType.swwitch:
      case FormFieldType.dropDown:
      case FormFieldType.password:
      case FormFieldType.hidden:
      case FormFieldType.file:
      case FormFieldType.image:
      case FormFieldType.radioColor:
      case FormFieldType.checkboxColor:
      case FormFieldType.price:
        break;
    }
    return null;
  }
}
