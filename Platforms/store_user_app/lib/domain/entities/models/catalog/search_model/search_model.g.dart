// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SearchModelImpl _$$SearchModelImplFromJson(Map<String, dynamic> json) =>
    _$SearchModelImpl(
      warning: json['Warning'] as String?,
      noResults: json['NoResults'] as bool? ?? false,
      searchCategoryId: json['SearchCategoryId'] as String?,
      q: json['q'] as String?,
      cid: json['cid'] as String?,
      isc: json['isc'] as bool? ?? false,
      mid: json['mid'] as String?,
      vid: json['vid'] as String?,
      pf: json['pf'] as String?,
      pt: json['pt'] as String?,
      sid: json['sid'] as bool? ?? false,
      adv: json['adv'] as bool? ?? false,
      asv: json['asv'] as bool? ?? false,
      box: json['Box'] as bool? ?? false,
      availableCategories:
          (json['AvailableCategories'] as List<dynamic>?)
              ?.map((e) => SelectListItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      availableCollections:
          (json['AvailableCollections'] as List<dynamic>?)
              ?.map((e) => SelectListItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      availableVendors:
          (json['AvailableVendors'] as List<dynamic>?)
              ?.map((e) => SelectListItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      pagingFilteringContext:
          json['PagingFilteringContext'] == null
              ? null
              : CatalogPagingFilteringModel.fromJson(
                json['PagingFilteringContext'] as Map<String, dynamic>,
              ),
      products:
          (json['Products'] as List<dynamic>?)
              ?.map(
                (e) => ProductOverviewModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
      userFields:
          (json['UserFields'] as List<dynamic>?)
              ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$SearchModelImplToJson(
  _$SearchModelImpl instance,
) => <String, dynamic>{
  if (instance.warning case final value?) 'Warning': value,
  if (instance.noResults case final value?) 'NoResults': value,
  if (instance.searchCategoryId case final value?) 'SearchCategoryId': value,
  if (instance.q case final value?) 'q': value,
  if (instance.cid case final value?) 'cid': value,
  if (instance.isc case final value?) 'isc': value,
  if (instance.mid case final value?) 'mid': value,
  if (instance.vid case final value?) 'vid': value,
  if (instance.pf case final value?) 'pf': value,
  if (instance.pt case final value?) 'pt': value,
  if (instance.sid case final value?) 'sid': value,
  if (instance.adv case final value?) 'adv': value,
  if (instance.asv case final value?) 'asv': value,
  if (instance.box case final value?) 'Box': value,
  if (instance.availableCategories case final value?)
    'AvailableCategories': value,
  if (instance.availableCollections case final value?)
    'AvailableCollections': value,
  if (instance.availableVendors case final value?) 'AvailableVendors': value,
  if (instance.pagingFilteringContext case final value?)
    'PagingFilteringContext': value,
  if (instance.products case final value?) 'Products': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
