import 'package:store_user_app/core/services/form/form_builder.dart';
import 'package:store_user_app/domain/entities/microsoft/asp_net_core/mvc/rendering/select_list_item/select_list_item.dart';
import 'package:store_user_app/domain/entities/models/catalog/add_product_review_model/add_product_review_model.dart';

class AddReviewModelFormBuilder extends FormBuilder<AddProductReviewModel> {
  AddReviewModelFormBuilder(super.model) {
    addField(
      'Title',
      (model) => model.title,
      label: 'Başlık',
      isRequired: true,
    );
    addMultilineTextField(
      'ReviewText',
      (model) => model.reviewText,
      label: 'Değerlendirmeniz',
      isRequired: true,
    );
    addRadioGroupField(
      'Rating',
      (model) => model.rating,
      (model) => List.generate(
          5,
          (index) => SelectListItem(
              text: List.generate(5 - index, (index) => '⭐').join(' '),
              value: (5 - index).toString())),
      (option) => option.text!,
      (option) => int.parse(option.value!),
      label: 'Oy',
      isRequired: true,
    );
  }
}
