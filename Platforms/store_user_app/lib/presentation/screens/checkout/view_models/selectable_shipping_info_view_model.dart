import 'package:store_user_app/domain/entities/common/user_field/user_field.dart';

class SelectableStepInfoViewModel {
  final String? name;
  final String? description;
  final String? fee;
  final List<UserField>? userFields;

  SelectableStepInfoViewModel({
    this.name,
    this.description,
    this.fee,
    this.userFields,
  });
}
