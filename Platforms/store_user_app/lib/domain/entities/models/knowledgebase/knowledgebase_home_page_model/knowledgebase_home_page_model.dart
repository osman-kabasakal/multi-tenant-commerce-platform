import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../knowledgebase_item_model/knowledgebase_item_model.dart';

import '../knowledgebase_category_model/knowledgebase_category_model.dart';

import '../../../common/user_field/user_field.dart';

part 'knowledgebase_home_page_model.freezed.dart';
part 'knowledgebase_home_page_model.g.dart';

@freezed
class KnowledgebaseHomePageModel
    extends StoreJsonSerializable<KnowledgebaseHomePageModel>
    with _$KnowledgebaseHomePageModel {
  factory KnowledgebaseHomePageModel(
      {@JsonKey(name: 'Items', includeIfNull: false)
      @Default([])
      List<KnowledgebaseItemModel>? items,
      @JsonKey(name: 'Categories', includeIfNull: false)
      @Default([])
      List<KnowledgebaseCategoryModel>? categories,
      @JsonKey(name: 'CurrentCategoryId', includeIfNull: false)
      String? currentCategoryId,
      @JsonKey(name: 'CurrentCategoryDescription', includeIfNull: false)
      String? currentCategoryDescription,
      @JsonKey(name: 'CurrentCategoryMetaTitle', includeIfNull: false)
      String? currentCategoryMetaTitle,
      @JsonKey(name: 'CurrentCategoryMetaDescription', includeIfNull: false)
      String? currentCategoryMetaDescription,
      @JsonKey(name: 'CurrentCategoryMetaKeywords', includeIfNull: false)
      String? currentCategoryMetaKeywords,
      @JsonKey(name: 'CurrentCategoryName', includeIfNull: false)
      String? currentCategoryName,
      @JsonKey(name: 'CurrentCategorySeName', includeIfNull: false)
      String? currentCategorySeName,
      @JsonKey(name: 'CategoryBreadcrumb', includeIfNull: false)
      @Default([])
      List<KnowledgebaseCategoryModel>? categoryBreadcrumb,
      @JsonKey(name: 'SearchKeyword', includeIfNull: false)
      String? searchKeyword,
      @JsonKey(name: 'Id', includeIfNull: false) String? id,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _KnowledgebaseHomePageModel;

  factory KnowledgebaseHomePageModel.fromJson(Map<String, dynamic> json) =>
      _$KnowledgebaseHomePageModelFromJson(json);
}
