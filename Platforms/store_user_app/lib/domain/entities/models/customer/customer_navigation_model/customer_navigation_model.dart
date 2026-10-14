import 'package:freezed_annotation/freezed_annotation.dart';

import 'account_navigation_enum/account_navigation_enum.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

part 'customer_navigation_model.freezed.dart';
part 'customer_navigation_model.g.dart';

@freezed
class CustomerNavigationModel
    extends StoreJsonSerializable<CustomerNavigationModel>
    with _$CustomerNavigationModel {
  const factory CustomerNavigationModel({
    @Default(false)
    @JsonKey(name: 'HideInfo', includeIfNull: false)
    bool? hideInfo,
    @Default(false)
    @JsonKey(name: 'HideAddresses', includeIfNull: false)
    bool? hideAddresses,
    @Default(false)
    @JsonKey(name: 'HideOrders', includeIfNull: false)
    bool? hideOrders,
    @Default(false)
    @JsonKey(name: 'HideOutOfStockSubscriptions', includeIfNull: false)
    bool? hideOutOfStockSubscriptions,
    @Default(false)
    @JsonKey(name: 'HideMerchandiseReturns', includeIfNull: false)
    bool? hideMerchandiseReturns,
    @Default(false)
    @JsonKey(name: 'HideDownloadableProducts', includeIfNull: false)
    bool? hideDownloadableProducts,
    @Default(false)
    @JsonKey(name: 'HideLoyaltyPoints', includeIfNull: false)
    bool? hideLoyaltyPoints,
    @Default(false)
    @JsonKey(name: 'HideChangePassword', includeIfNull: false)
    bool? hideChangePassword,
    @Default(false)
    @JsonKey(name: 'HideDeleteAccount', includeIfNull: false)
    bool? hideDeleteAccount,
    @Default(false)
    @JsonKey(name: 'HideAuctions', includeIfNull: false)
    bool? hideAuctions,
    @Default(false)
    @JsonKey(name: 'HideNotes', includeIfNull: false)
    bool? hideNotes,
    @Default(false)
    @JsonKey(name: 'HideDocuments', includeIfNull: false)
    bool? hideDocuments,
    @Default(false)
    @JsonKey(name: 'HideReviews', includeIfNull: false)
    bool? hideReviews,
    @Default(false)
    @JsonKey(name: 'HideCourses', includeIfNull: false)
    bool? hideCourses,
    @Default(false)
    @JsonKey(name: 'HideSubAccounts', includeIfNull: false)
    bool? hideSubAccounts,
    @Default(AccountNavigationEnum.info)
    @JsonKey(name: 'SelectedTab', includeIfNull: false)
    AccountNavigationEnum? selectedTab,
  }) = _CustomerNavigationModel;

  factory CustomerNavigationModel.fromJson(Map<String, dynamic> json) =>
      _$CustomerNavigationModelFromJson(json);
}
