// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VendorListModelImpl _$$VendorListModelImplFromJson(
  Map<String, dynamic> json,
) => _$VendorListModelImpl(
  pagingModel:
      json['PagingModel'] == null
          ? null
          : VendorPagingModel.fromJson(
            json['PagingModel'] as Map<String, dynamic>,
          ),
  vendorsModel:
      (json['VendorsModel'] as List<dynamic>?)
          ?.map((e) => VendorModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$VendorListModelImplToJson(
  _$VendorListModelImpl instance,
) => <String, dynamic>{
  if (instance.pagingModel case final value?) 'PagingModel': value,
  if (instance.vendorsModel case final value?) 'VendorsModel': value,
};
