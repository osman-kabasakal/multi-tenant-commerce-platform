import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../common/user_field/user_field.dart';

part 'blog_comment_model.freezed.dart';
part 'blog_comment_model.g.dart';

@freezed
class BlogCommentModel extends StoreJsonSerializable<BlogCommentModel>
    with _$BlogCommentModel {
  factory BlogCommentModel(
      {@JsonKey(name: 'CustomerId', includeIfNull: false) String? customerId,
      @JsonKey(name: 'CustomerName', includeIfNull: false) String? customerName,
      @JsonKey(name: 'CommentText', includeIfNull: false) String? commentText,
      @JsonKey(name: 'CreatedOn', includeIfNull: false) DateTime? createdOn,
      @JsonKey(name: 'Id', includeIfNull: false) String? id,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _BlogCommentModel;

  factory BlogCommentModel.fromJson(Map<String, dynamic> json) =>
      _$BlogCommentModelFromJson(json);
}
