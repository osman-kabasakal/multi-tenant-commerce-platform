import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../common/user_field/user_field.dart';

part 'knowledgebase_category_model.freezed.dart';
part 'knowledgebase_category_model.g.dart';

@freezed
class KnowledgebaseCategoryModel
    extends StoreJsonSerializable<KnowledgebaseCategoryModel>
    with _$KnowledgebaseCategoryModel {
  factory KnowledgebaseCategoryModel(
      {@JsonKey(name: 'Name', includeIfNull: false) String? name,
      @JsonKey(name: 'Description', includeIfNull: false) String? description,
      @JsonKey(name: 'IsCurrent', includeIfNull: false)
      @Default(false)
      bool? isCurrent,
      @JsonKey(name: 'Children', includeIfNull: false)
      @Default([])
      List<KnowledgebaseCategoryModel>? children,
      @JsonKey(name: 'Parent', includeIfNull: false)
      KnowledgebaseCategoryModel? parent,
      @JsonKey(name: 'SeName', includeIfNull: false) String? seName,
      @JsonKey(name: 'Id', includeIfNull: false) String? id,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _KnowledgebaseCategoryModel;

  factory KnowledgebaseCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$KnowledgebaseCategoryModelFromJson(json);
}
