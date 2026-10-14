// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SliderImpl _$$SliderImplFromJson(Map<String, dynamic> json) => _$SliderImpl(
  pictureUrl: json['PictureUrl'] as String?,
  name: json['Name'] as String?,
  description: json['Description'] as String?,
  link: json['Link'] as String?,
  fullWidth: json['FullWidth'] as bool? ?? false,
  cssClass: json['CssClass'] as String?,
);

Map<String, dynamic> _$$SliderImplToJson(_$SliderImpl instance) =>
    <String, dynamic>{
      'PictureUrl': instance.pictureUrl,
      'Name': instance.name,
      'Description': instance.description,
      'Link': instance.link,
      'FullWidth': instance.fullWidth,
      'CssClass': instance.cssClass,
    };
