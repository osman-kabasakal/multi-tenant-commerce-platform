// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gift_voucher_box_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GiftVoucherBoxModelImpl _$$GiftVoucherBoxModelImplFromJson(
  Map<String, dynamic> json,
) => _$GiftVoucherBoxModelImpl(
  display: json['Display'] as bool? ?? false,
  message: json['Message'] as String?,
  isApplied: json['IsApplied'] as bool? ?? false,
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$GiftVoucherBoxModelImplToJson(
  _$GiftVoucherBoxModelImpl instance,
) => <String, dynamic>{
  if (instance.display case final value?) 'Display': value,
  if (instance.message case final value?) 'Message': value,
  if (instance.isApplied case final value?) 'IsApplied': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
