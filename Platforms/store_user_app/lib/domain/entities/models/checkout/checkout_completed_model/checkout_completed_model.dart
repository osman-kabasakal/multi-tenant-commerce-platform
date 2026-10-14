import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../common/user_field/user_field.dart';

part 'checkout_completed_model.freezed.dart';
part 'checkout_completed_model.g.dart';

@freezed
class CheckoutCompletedModel
    extends StoreJsonSerializable<CheckoutCompletedModel>
    with _$CheckoutCompletedModel {
  factory CheckoutCompletedModel(
      {@JsonKey(name: 'OrderId', includeIfNull: false) String? orderId,
      @JsonKey(name: 'OrderNumber', includeIfNull: false) int? orderNumber,
      @JsonKey(name: 'OrderCode', includeIfNull: false) String? orderCode,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _CheckoutCompletedModel;

  factory CheckoutCompletedModel.fromJson(Map<String, dynamic> json) =>
      _$CheckoutCompletedModelFromJson(json);
}
