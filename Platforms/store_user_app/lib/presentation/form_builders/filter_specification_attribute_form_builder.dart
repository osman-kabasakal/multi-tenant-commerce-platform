import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/services/form/form_builder.dart';
import 'package:store_user_app/core/services/form/form_field.dart';
import 'package:store_user_app/domain/entities/models/catalog/catalog_paging_filtering_model/specification_filter_item/specification_filter_item.dart';

class FilterSpecificationAttributeFormBuilder
    extends FormBuilder<Map<String, List<SpecificationFilterItem>>> {
  FilterSpecificationAttributeFormBuilder(super.model) {
    for (var group in model.entries) {
      addCheckboxGroupField(
        group.key,
        (v) => group.key,
        (v) => v[group.key]!,
        (o) => (o.specificationAttributeOptionColorRgb.isEmptyOrNull ?? true)
            ? (o.specificationAttributeOptionName ?? '')
            : o.specificationAttributeOptionColorRgb!,
        (o) => o.specificationAttributeOptionSeName,
        label: group.value.firstOrNull?.specificationAttributeName,
        type: (group.value.firstOrNull?.specificationAttributeOptionColorRgb
                    .isEmptyOrNull ??
                true)
            ? FormFieldType.checkbox
            : FormFieldType.checkboxColor,
      );
    }
  }
}
