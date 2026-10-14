import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../media/picture_model/picture_model.dart';

import '../../../../common/user_field/user_field.dart';

part 'news_item_model.freezed.dart';
part 'news_item_model.g.dart';

@freezed
class NewsItemModel extends StoreJsonSerializable<NewsItemModel>
    with _$NewsItemModel {
  factory NewsItemModel(
      {@JsonKey(name: 'Id', includeIfNull: false) String? id,
      @JsonKey(name: 'SeName', includeIfNull: false) String? seName,
      @JsonKey(name: 'Title', includeIfNull: false) String? title,
      @JsonKey(name: 'PictureModel', includeIfNull: false)
      PictureModel? pictureModel,
      @JsonKey(name: 'Short', includeIfNull: false) String? short,
      @JsonKey(name: 'Full', includeIfNull: false) String? full,
      @JsonKey(name: 'CreatedOn', includeIfNull: false) DateTime? createdOn,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _NewsItemModel;

  factory NewsItemModel.fromJson(Map<String, dynamic> json) =>
      _$NewsItemModelFromJson(json);
}
