// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchandise_return_note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MerchandiseReturnNoteImpl _$$MerchandiseReturnNoteImplFromJson(
  Map<String, dynamic> json,
) => _$MerchandiseReturnNoteImpl(
  hasDownload: json['HasDownload'] as bool? ?? false,
  note: json['Note'] as String?,
  createdOn:
      json['CreatedOn'] == null
          ? null
          : DateTime.parse(json['CreatedOn'] as String),
  merchandiseReturnId: json['MerchandiseReturnId'] as String?,
  id: json['Id'] as String?,
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$MerchandiseReturnNoteImplToJson(
  _$MerchandiseReturnNoteImpl instance,
) => <String, dynamic>{
  if (instance.hasDownload case final value?) 'HasDownload': value,
  if (instance.note case final value?) 'Note': value,
  if (instance.createdOn?.toIso8601String() case final value?)
    'CreatedOn': value,
  if (instance.merchandiseReturnId case final value?)
    'MerchandiseReturnId': value,
  if (instance.id case final value?) 'Id': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
