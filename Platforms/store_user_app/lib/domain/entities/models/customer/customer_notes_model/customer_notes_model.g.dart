// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_notes_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CustomerNotesModelImpl _$$CustomerNotesModelImplFromJson(
  Map<String, dynamic> json,
) => _$CustomerNotesModelImpl(
  customerNoteList:
      (json['CustomerNoteList'] as List<dynamic>?)
          ?.map((e) => CustomerNote.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  customerId: json['CustomerId'] as String?,
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$CustomerNotesModelImplToJson(
  _$CustomerNotesModelImpl instance,
) => <String, dynamic>{
  if (instance.customerNoteList case final value?) 'CustomerNoteList': value,
  if (instance.customerId case final value?) 'CustomerId': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
