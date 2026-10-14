import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../product_tag_model/product_tag_model.dart';

import '../../../common/user_field/user_field.dart';

part 'popular_product_tags_model.freezed.dart';
part 'popular_product_tags_model.g.dart';

@freezed
class PopularProductTagsModel
    extends StoreJsonSerializable<PopularProductTagsModel>
    with _$PopularProductTagsModel {
  factory PopularProductTagsModel(
      {@JsonKey(name: 'TotalTags', includeIfNull: false) int? totalTags,
      @JsonKey(name: 'Tags', includeIfNull: false)
      @Default([])
      List<ProductTagModel>? tags,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _PopularProductTagsModel;

  factory PopularProductTagsModel.fromJson(Map<String, dynamic> json) =>
      _$PopularProductTagsModelFromJson(json);
}
