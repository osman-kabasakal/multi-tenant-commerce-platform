import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:store_user_app/core/models/form/form_provider_state.dart';
import 'package:store_user_app/core/services/form/app_form_controller.dart';

part 'generic_form_provider.g.dart';

@riverpod
class GenericFormProvider extends _$GenericFormProvider {
  @override
  FormProviderState build(AppFormController controller) {
    return FormProviderState(
      values: controller.getValues(),
      errors: controller.getErrors(),
      isValid: controller.isValid,
      isDirty: controller.isDirty,
      isTouched: controller.isTouched,
    );
  }

  void updateField(String name, dynamic value) {
    controller.updateField(name, value);
    updateState();
  }

  void updateState() {
    state = state.copyWith(
      values: controller.getValues(),
      errors: controller.getErrors(),
      isValid: controller.isValid,
      isDirty: controller.isDirty,
      isTouched: controller.isTouched,
    );
  }
}
