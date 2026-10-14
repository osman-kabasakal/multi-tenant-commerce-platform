import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../media/picture_model/picture_model.dart';

import '../blog_paging_filtering_model/blog_paging_filtering_model.dart';

import '../blog_post_model/blog_post_model.dart';

import '../../../common/user_field/user_field.dart';

part 'blog_post_list_model.freezed.dart';
part 'blog_post_list_model.g.dart';

@freezed
class BlogPostListModel extends StoreJsonSerializable<BlogPostListModel>
    with _$BlogPostListModel {
  factory BlogPostListModel(
      {@JsonKey(name: 'PictureModel', includeIfNull: false)
      PictureModel? pictureModel,
      @JsonKey(name: 'WorkingLanguageId', includeIfNull: false)
      String? workingLanguageId,
      @JsonKey(name: 'PagingFilteringContext', includeIfNull: false)
      BlogPagingFilteringModel? pagingFilteringContext,
      @JsonKey(name: 'BlogPosts', includeIfNull: false)
      @Default([])
      List<BlogPostModel>? blogPosts,
      @JsonKey(name: 'SearchKeyword', includeIfNull: false)
      String? searchKeyword,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _BlogPostListModel;

  factory BlogPostListModel.fromJson(Map<String, dynamic> json) =>
      _$BlogPostListModelFromJson(json);
}
