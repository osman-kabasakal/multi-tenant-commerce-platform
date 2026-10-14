import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../common/user_field/user_field.dart';

part 'knowledgebase_item_model.freezed.dart';
part 'knowledgebase_item_model.g.dart';

@freezed
class KnowledgebaseItemModel
    extends StoreJsonSerializable<KnowledgebaseItemModel>
    with _$KnowledgebaseItemModel {
  factory KnowledgebaseItemModel(
      {@JsonKey(name: 'Name', includeIfNull: false) String? name,
      @JsonKey(name: 'SeName', includeIfNull: false) String? seName,
      @JsonKey(name: 'IsArticle', includeIfNull: false)
      @Default(false)
      bool? isArticle,
      @JsonKey(name: 'FormattedBreadcrumbs', includeIfNull: false)
      String? formattedBreadcrumbs,
      @JsonKey(name: 'Id', includeIfNull: false) String? id,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _KnowledgebaseItemModel;

  factory KnowledgebaseItemModel.fromJson(Map<String, dynamic> json) =>
      _$KnowledgebaseItemModelFromJson(json);
}
