// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NewsCommentModelImpl _$$NewsCommentModelImplFromJson(
  Map<String, dynamic> json,
) => _$NewsCommentModelImpl(
  customerId: json['CustomerId'] as String?,
  customerName: json['CustomerName'] as String?,
  commentTitle: json['CommentTitle'] as String?,
  commentText: json['CommentText'] as String?,
  createdOn:
      json['CreatedOn'] == null
          ? null
          : DateTime.parse(json['CreatedOn'] as String),
  id: json['Id'] as String?,
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$NewsCommentModelImplToJson(
  _$NewsCommentModelImpl instance,
) => <String, dynamic>{
  if (instance.customerId case final value?) 'CustomerId': value,
  if (instance.customerName case final value?) 'CustomerName': value,
  if (instance.commentTitle case final value?) 'CommentTitle': value,
  if (instance.commentText case final value?) 'CommentText': value,
  if (instance.createdOn?.toIso8601String() case final value?)
    'CreatedOn': value,
  if (instance.id case final value?) 'Id': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
