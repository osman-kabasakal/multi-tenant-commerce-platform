// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_paging_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VendorPagingModelImpl _$$VendorPagingModelImplFromJson(
  Map<String, dynamic> json,
) => _$VendorPagingModelImpl(
  firstItem: (json['FirstItem'] as num?)?.toInt(),
  hasNextPage: json['HasNextPage'] as bool? ?? false,
  hasPreviousPage: json['HasPreviousPage'] as bool? ?? false,
  lastItem: (json['LastItem'] as num?)?.toInt(),
  pageIndex: (json['PageIndex'] as num?)?.toInt(),
  pageNumber: (json['PageNumber'] as num?)?.toInt(),
  pageSize: (json['PageSize'] as num?)?.toInt(),
  totalItems: (json['TotalItems'] as num?)?.toInt(),
  totalPages: (json['TotalPages'] as num?)?.toInt(),
);

Map<String, dynamic> _$$VendorPagingModelImplToJson(
  _$VendorPagingModelImpl instance,
) => <String, dynamic>{
  if (instance.firstItem case final value?) 'FirstItem': value,
  if (instance.hasNextPage case final value?) 'HasNextPage': value,
  if (instance.hasPreviousPage case final value?) 'HasPreviousPage': value,
  if (instance.lastItem case final value?) 'LastItem': value,
  if (instance.pageIndex case final value?) 'PageIndex': value,
  if (instance.pageNumber case final value?) 'PageNumber': value,
  if (instance.pageSize case final value?) 'PageSize': value,
  if (instance.totalItems case final value?) 'TotalItems': value,
  if (instance.totalPages case final value?) 'TotalPages': value,
};
