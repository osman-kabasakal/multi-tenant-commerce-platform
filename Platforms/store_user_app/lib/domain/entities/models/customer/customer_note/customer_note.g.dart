// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CustomerNoteImpl _$$CustomerNoteImplFromJson(Map<String, dynamic> json) =>
    _$CustomerNoteImpl(
      noteId: json['NoteId'] as String?,
      downloadId: json['DownloadId'] as String?,
      title: json['Title'] as String?,
      note: json['Note'] as String?,
      createdOn:
          json['CreatedOn'] == null
              ? null
              : DateTime.parse(json['CreatedOn'] as String),
    );

Map<String, dynamic> _$$CustomerNoteImplToJson(_$CustomerNoteImpl instance) =>
    <String, dynamic>{
      if (instance.noteId case final value?) 'NoteId': value,
      if (instance.downloadId case final value?) 'DownloadId': value,
      if (instance.title case final value?) 'Title': value,
      if (instance.note case final value?) 'Note': value,
      if (instance.createdOn?.toIso8601String() case final value?)
        'CreatedOn': value,
    };
