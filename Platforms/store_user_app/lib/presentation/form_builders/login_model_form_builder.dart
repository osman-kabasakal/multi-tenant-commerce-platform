import 'package:store_user_app/core/services/form/form_builder.dart';
import 'package:store_user_app/core/services/form/form_field.dart';
import 'package:store_user_app/domain/entities/models/customer/LoginModel/loginModel.dart';

class LoginModelFormBuilder extends FormBuilder<LoginModel> {
  LoginModelFormBuilder(super.model) {
    addField(
      'Email',
      (model) => model.email,
      label: 'E-posta',
      isRequired: true,
      type: FormFieldType.email,
    ).setHintText('postam@sunucu.com');

    addField(
      'Password',
      (model) => model.password,
      label: 'Şifre',
      isRequired: true,
      type: FormFieldType.password,
    ).setHintText('Şifrenizi girin');
  }
}
