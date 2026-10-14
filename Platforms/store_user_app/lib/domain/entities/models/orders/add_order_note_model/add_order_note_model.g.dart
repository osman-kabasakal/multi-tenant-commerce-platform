// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_order_note_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AddOrderNoteModelImpl _$$AddOrderNoteModelImplFromJson(
  Map<String, dynamic> json,
) => _$AddOrderNoteModelImpl(
  orderId: json['OrderId'] as String?,
  note: json['Note'] as String?,
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$AddOrderNoteModelImplToJson(
  _$AddOrderNoteModelImpl instance,
) => <String, dynamic>{
  if (instance.orderId case final value?) 'OrderId': value,
  if (instance.note case final value?) 'Note': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
