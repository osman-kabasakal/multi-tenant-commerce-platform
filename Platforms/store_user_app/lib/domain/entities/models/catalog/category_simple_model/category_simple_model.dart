import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../common/user_field/user_field.dart';

part 'category_simple_model.freezed.dart';
part 'category_simple_model.g.dart';

@freezed
class CategorySimpleModel extends StoreJsonSerializable<CategorySimpleModel>
    with _$CategorySimpleModel {
  factory CategorySimpleModel(
      {@JsonKey(name: 'Name', includeIfNull: false) String? name,
      @JsonKey(name: 'Flag', includeIfNull: false) String? flag,
      @JsonKey(name: 'FlagStyle', includeIfNull: false) String? flagStyle,
      @JsonKey(name: 'Icon', includeIfNull: false) String? icon,
      @JsonKey(name: 'ImageUrl', includeIfNull: false) String? imageUrl,
      @JsonKey(name: 'SeName', includeIfNull: false) String? seName,
      @JsonKey(name: 'NumberOfProducts', includeIfNull: false)
      @Default(null)
      int? numberOfProducts,
      @JsonKey(name: 'IncludeInMenu', includeIfNull: false)
      @Default(false)
      bool? includeInMenu,
      @JsonKey(name: 'SubCategories', includeIfNull: false)
      @Default([])
      List<CategorySimpleModel>? subCategories,
      @JsonKey(name: 'Id', includeIfNull: false) String? id,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _CategorySimpleModel;

  factory CategorySimpleModel.fromJson(Map<String, dynamic> json) =>
      _$CategorySimpleModelFromJson(json);
}
