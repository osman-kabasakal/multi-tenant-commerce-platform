import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../media/picture_model/picture_model.dart';

import '../blog_comment_model/blog_comment_model.dart';

import '../add_blog_comment_model/add_blog_comment_model.dart';

import '../../../common/user_field/user_field.dart';

part 'blog_post_model.freezed.dart';
part 'blog_post_model.g.dart';

@freezed
class BlogPostModel extends StoreJsonSerializable<BlogPostModel>
    with _$BlogPostModel {
  factory BlogPostModel(
      {@JsonKey(name: 'MetaKeywords', includeIfNull: false)
      String? metaKeywords,
      @JsonKey(name: 'MetaDescription', includeIfNull: false)
      String? metaDescription,
      @JsonKey(name: 'MetaTitle', includeIfNull: false) String? metaTitle,
      @JsonKey(name: 'SeName', includeIfNull: false) String? seName,
      @JsonKey(name: 'Title', includeIfNull: false) String? title,
      @JsonKey(name: 'PictureModel', includeIfNull: false)
      PictureModel? pictureModel,
      @JsonKey(name: 'Body', includeIfNull: false) String? body,
      @JsonKey(name: 'BodyOverview', includeIfNull: false) String? bodyOverview,
      @JsonKey(name: 'AllowComments', includeIfNull: false)
      @Default(false)
      bool? allowComments,
      @JsonKey(name: 'NumberOfComments', includeIfNull: false)
      int? numberOfComments,
      @JsonKey(name: 'CreatedOn', includeIfNull: false) DateTime? createdOn,
      @JsonKey(name: 'Tags', includeIfNull: false)
      @Default([])
      List<String>? tags,
      @JsonKey(name: 'Comments', includeIfNull: false)
      @Default([])
      List<BlogCommentModel>? comments,
      @JsonKey(name: 'AddNewComment', includeIfNull: false)
      AddBlogCommentModel? addNewComment,
      @JsonKey(name: 'Id', includeIfNull: false) String? id,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _BlogPostModel;

  factory BlogPostModel.fromJson(Map<String, dynamic> json) =>
      _$BlogPostModelFromJson(json);
}
