// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discount_box_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DiscountBoxModelImpl _$$DiscountBoxModelImplFromJson(
  Map<String, dynamic> json,
) => _$DiscountBoxModelImpl(
  appliedDiscountsWithCodes:
      (json['AppliedDiscountsWithCodes'] as List<dynamic>?)
          ?.map((e) => DiscountInfoModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  display: json['Display'] as bool? ?? false,
  message: json['Message'] as String?,
  isApplied: json['IsApplied'] as bool? ?? false,
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$DiscountBoxModelImplToJson(
  _$DiscountBoxModelImpl instance,
) => <String, dynamic>{
  if (instance.appliedDiscountsWithCodes case final value?)
    'AppliedDiscountsWithCodes': value,
  if (instance.display case final value?) 'Display': value,
  if (instance.message case final value?) 'Message': value,
  if (instance.isApplied case final value?) 'IsApplied': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
