// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_auto_complete_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SearchAutoCompleteModelImpl _$$SearchAutoCompleteModelImplFromJson(
  Map<String, dynamic> json,
) => _$SearchAutoCompleteModelImpl(
  searchType: json['SearchType'] as String?,
  label: json['Label'] as String?,
  url: json['Url'] as String?,
  desc: json['Desc'] as String?,
  price: json['Price'] as String?,
  priceWithDiscount: json['PriceWithDiscount'] as String?,
  allowCustomerReviews: json['AllowCustomerReviews'] as bool? ?? false,
  rating: (json['Rating'] as num?)?.toDouble(),
  pictureUrl: json['PictureUrl'] as String?,
);

Map<String, dynamic> _$$SearchAutoCompleteModelImplToJson(
  _$SearchAutoCompleteModelImpl instance,
) => <String, dynamic>{
  if (instance.searchType case final value?) 'SearchType': value,
  if (instance.label case final value?) 'Label': value,
  if (instance.url case final value?) 'Url': value,
  if (instance.desc case final value?) 'Desc': value,
  if (instance.price case final value?) 'Price': value,
  if (instance.priceWithDiscount case final value?) 'PriceWithDiscount': value,
  if (instance.allowCustomerReviews case final value?)
    'AllowCustomerReviews': value,
  if (instance.rating case final value?) 'Rating': value,
  if (instance.pictureUrl case final value?) 'PictureUrl': value,
};
