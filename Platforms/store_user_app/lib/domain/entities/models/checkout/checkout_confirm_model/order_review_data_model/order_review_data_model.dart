import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../common/address_model/address_model.dart';

import '../../../../common/user_field/user_field.dart';


part 'order_review_data_model.freezed.dart';
part 'order_review_data_model.g.dart';

@freezed
class OrderReviewDataModel extends StoreJsonSerializable<OrderReviewDataModel> with _$OrderReviewDataModel {
  factory OrderReviewDataModel({ 
    @JsonKey(name: 'BillingAddress', includeIfNull: false)
     AddressModel? billingAddress,

    @JsonKey(name: 'IsShippable', includeIfNull: false)
    @Default(false) bool? isShippable,

    @JsonKey(name: 'ShippingAddress', includeIfNull: false)
     AddressModel? shippingAddress,

    @JsonKey(name: 'SelectedPickUpInStore', includeIfNull: false)
    @Default(false) bool? selectedPickUpInStore,

    @JsonKey(name: 'PickupAddress', includeIfNull: false)
     AddressModel? pickupAddress,

    @JsonKey(name: 'ShippingMethod', includeIfNull: false)
     String? shippingMethod,

    @JsonKey(name: 'ShippingAdditionDescription', includeIfNull: false)
     String? shippingAdditionDescription,

    @JsonKey(name: 'PaymentMethod', includeIfNull: false)
     String? paymentMethod,

    @JsonKey(name: 'UserFields', includeIfNull: false)
    @Default([]) List<UserField>? userFields
}) = _OrderReviewDataModel;

  factory OrderReviewDataModel.fromJson(Map<String, dynamic> json) =>
      _$OrderReviewDataModelFromJson(json);
}