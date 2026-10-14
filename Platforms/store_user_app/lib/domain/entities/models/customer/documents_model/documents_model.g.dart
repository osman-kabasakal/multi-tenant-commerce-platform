// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'documents_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DocumentsModelImpl _$$DocumentsModelImplFromJson(Map<String, dynamic> json) =>
    _$DocumentsModelImpl(
      documentList:
          (json['DocumentList'] as List<dynamic>?)
              ?.map((e) => Document.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      pagingContext:
          json['PagingContext'] == null
              ? null
              : DocumentPagingModel.fromJson(
                json['PagingContext'] as Map<String, dynamic>,
              ),
      customerId: json['CustomerId'] as String?,
      userFields:
          (json['UserFields'] as List<dynamic>?)
              ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$DocumentsModelImplToJson(
  _$DocumentsModelImpl instance,
) => <String, dynamic>{
  if (instance.documentList case final value?) 'DocumentList': value,
  if (instance.pagingContext case final value?) 'PagingContext': value,
  if (instance.customerId case final value?) 'CustomerId': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
