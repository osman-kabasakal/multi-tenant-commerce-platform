// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderNoteImpl _$$OrderNoteImplFromJson(Map<String, dynamic> json) =>
    _$OrderNoteImpl(
      hasDownload: json['HasDownload'] as bool? ?? false,
      note: json['Note'] as String?,
      createdOn:
          json['CreatedOn'] == null
              ? null
              : DateTime.parse(json['CreatedOn'] as String),
      orderId: json['OrderId'] as String?,
      id: json['Id'] as String?,
      userFields:
          (json['UserFields'] as List<dynamic>?)
              ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$OrderNoteImplToJson(_$OrderNoteImpl instance) =>
    <String, dynamic>{
      if (instance.hasDownload case final value?) 'HasDownload': value,
      if (instance.note case final value?) 'Note': value,
      if (instance.createdOn?.toIso8601String() case final value?)
        'CreatedOn': value,
      if (instance.orderId case final value?) 'OrderId': value,
      if (instance.id case final value?) 'Id': value,
      if (instance.userFields case final value?) 'UserFields': value,
    };
