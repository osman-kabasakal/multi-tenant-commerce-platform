// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_navigation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CustomerNavigationModelImpl _$$CustomerNavigationModelImplFromJson(
  Map<String, dynamic> json,
) => _$CustomerNavigationModelImpl(
  hideInfo: json['HideInfo'] as bool? ?? false,
  hideAddresses: json['HideAddresses'] as bool? ?? false,
  hideOrders: json['HideOrders'] as bool? ?? false,
  hideOutOfStockSubscriptions:
      json['HideOutOfStockSubscriptions'] as bool? ?? false,
  hideMerchandiseReturns: json['HideMerchandiseReturns'] as bool? ?? false,
  hideDownloadableProducts: json['HideDownloadableProducts'] as bool? ?? false,
  hideLoyaltyPoints: json['HideLoyaltyPoints'] as bool? ?? false,
  hideChangePassword: json['HideChangePassword'] as bool? ?? false,
  hideDeleteAccount: json['HideDeleteAccount'] as bool? ?? false,
  hideAuctions: json['HideAuctions'] as bool? ?? false,
  hideNotes: json['HideNotes'] as bool? ?? false,
  hideDocuments: json['HideDocuments'] as bool? ?? false,
  hideReviews: json['HideReviews'] as bool? ?? false,
  hideCourses: json['HideCourses'] as bool? ?? false,
  hideSubAccounts: json['HideSubAccounts'] as bool? ?? false,
  selectedTab:
      $enumDecodeNullable(
        _$AccountNavigationEnumEnumMap,
        json['SelectedTab'],
      ) ??
      AccountNavigationEnum.info,
);

Map<String, dynamic> _$$CustomerNavigationModelImplToJson(
  _$CustomerNavigationModelImpl instance,
) => <String, dynamic>{
  if (instance.hideInfo case final value?) 'HideInfo': value,
  if (instance.hideAddresses case final value?) 'HideAddresses': value,
  if (instance.hideOrders case final value?) 'HideOrders': value,
  if (instance.hideOutOfStockSubscriptions case final value?)
    'HideOutOfStockSubscriptions': value,
  if (instance.hideMerchandiseReturns case final value?)
    'HideMerchandiseReturns': value,
  if (instance.hideDownloadableProducts case final value?)
    'HideDownloadableProducts': value,
  if (instance.hideLoyaltyPoints case final value?) 'HideLoyaltyPoints': value,
  if (instance.hideChangePassword case final value?)
    'HideChangePassword': value,
  if (instance.hideDeleteAccount case final value?) 'HideDeleteAccount': value,
  if (instance.hideAuctions case final value?) 'HideAuctions': value,
  if (instance.hideNotes case final value?) 'HideNotes': value,
  if (instance.hideDocuments case final value?) 'HideDocuments': value,
  if (instance.hideReviews case final value?) 'HideReviews': value,
  if (instance.hideCourses case final value?) 'HideCourses': value,
  if (instance.hideSubAccounts case final value?) 'HideSubAccounts': value,
  if (_$AccountNavigationEnumEnumMap[instance.selectedTab] case final value?)
    'SelectedTab': value,
};

const _$AccountNavigationEnumEnumMap = {
  AccountNavigationEnum.info: 0,
  AccountNavigationEnum.addresses: 10,
  AccountNavigationEnum.orders: 20,
  AccountNavigationEnum.outOfStockSubscriptions: 30,
  AccountNavigationEnum.merchandiseReturns: 40,
  AccountNavigationEnum.downloadableProducts: 50,
  AccountNavigationEnum.loyaltyPoints: 60,
  AccountNavigationEnum.changePassword: 70,
  AccountNavigationEnum.deleteAccount: 75,
  AccountNavigationEnum.vendorInfo: 100,
  AccountNavigationEnum.auctions: 110,
  AccountNavigationEnum.notes: 120,
  AccountNavigationEnum.documents: 130,
  AccountNavigationEnum.reviews: 140,
  AccountNavigationEnum.courses: 150,
  AccountNavigationEnum.subAccounts: 160,
  AccountNavigationEnum.others: 900,
};
