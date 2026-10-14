// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PublicInfoModelImpl _$$PublicInfoModelImplFromJson(
  Map<String, dynamic> json,
) => _$PublicInfoModelImpl(
  slide:
      (json['Slide'] as List<dynamic>?)
          ?.map((e) => Slider.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$PublicInfoModelImplToJson(
  _$PublicInfoModelImpl instance,
) => <String, dynamic>{
  if (instance.slide case final value?) 'Slide': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
