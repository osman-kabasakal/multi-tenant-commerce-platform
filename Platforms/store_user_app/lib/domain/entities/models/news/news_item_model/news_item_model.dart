import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../media/picture_model/picture_model.dart';

import '../news_comment_model/news_comment_model.dart';

import '../add_news_comment_model/add_news_comment_model.dart';

import '../../../common/user_field/user_field.dart';

part 'news_item_model.freezed.dart';
part 'news_item_model.g.dart';

@freezed
class NewsItemModel extends StoreJsonSerializable<NewsItemModel>
    with _$NewsItemModel {
  factory NewsItemModel(
      {@JsonKey(name: 'NewsItemId', includeIfNull: false) String? newsItemId,
      @JsonKey(name: 'MetaKeywords', includeIfNull: false) String? metaKeywords,
      @JsonKey(name: 'MetaDescription', includeIfNull: false)
      String? metaDescription,
      @JsonKey(name: 'MetaTitle', includeIfNull: false) String? metaTitle,
      @JsonKey(name: 'SeName', includeIfNull: false) String? seName,
      @JsonKey(name: 'Title', includeIfNull: false) String? title,
      @JsonKey(name: 'PictureModel', includeIfNull: false)
      PictureModel? pictureModel,
      @JsonKey(name: 'Short', includeIfNull: false) String? short,
      @JsonKey(name: 'Full', includeIfNull: false) String? full,
      @JsonKey(name: 'AllowComments', includeIfNull: false)
      @Default(false)
      bool? allowComments,
      @JsonKey(name: 'NumberOfComments', includeIfNull: false)
      int? numberOfComments,
      @JsonKey(name: 'CreatedOn', includeIfNull: false) DateTime? createdOn,
      @JsonKey(name: 'Comments', includeIfNull: false)
      @Default([])
      List<NewsCommentModel>? comments,
      @JsonKey(name: 'AddNewComment', includeIfNull: false)
      AddNewsCommentModel? addNewComment,
      @JsonKey(name: 'Id', includeIfNull: false) String? id,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _NewsItemModel;

  factory NewsItemModel.fromJson(Map<String, dynamic> json) =>
      _$NewsItemModelFromJson(json);
}
