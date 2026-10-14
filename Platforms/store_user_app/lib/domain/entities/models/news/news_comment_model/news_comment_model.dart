import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../common/user_field/user_field.dart';

part 'news_comment_model.freezed.dart';
part 'news_comment_model.g.dart';

@freezed
class NewsCommentModel extends StoreJsonSerializable<NewsCommentModel>
    with _$NewsCommentModel {
  factory NewsCommentModel(
      {@JsonKey(name: 'CustomerId', includeIfNull: false) String? customerId,
      @JsonKey(name: 'CustomerName', includeIfNull: false) String? customerName,
      @JsonKey(name: 'CommentTitle', includeIfNull: false) String? commentTitle,
      @JsonKey(name: 'CommentText', includeIfNull: false) String? commentText,
      @JsonKey(name: 'CreatedOn', includeIfNull: false) DateTime? createdOn,
      @JsonKey(name: 'Id', includeIfNull: false) String? id,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _NewsCommentModel;

  factory NewsCommentModel.fromJson(Map<String, dynamic> json) =>
      _$NewsCommentModelFromJson(json);
}
