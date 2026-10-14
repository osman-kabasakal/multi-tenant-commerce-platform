import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../../common/user_field/user_field.dart';

part 'out_of_stock_subscription_model.freezed.dart';
part 'out_of_stock_subscription_model.g.dart';

@freezed
class OutOfStockSubscriptionModel
    extends StoreJsonSerializable<OutOfStockSubscriptionModel>
    with _$OutOfStockSubscriptionModel {
  factory OutOfStockSubscriptionModel(
      {@JsonKey(name: 'ProductId', includeIfNull: false) String? productId,
      @JsonKey(name: 'ProductName', includeIfNull: false) String? productName,
      @JsonKey(name: 'AttributeDescription', includeIfNull: false)
      String? attributeDescription,
      @JsonKey(name: 'SeName', includeIfNull: false) String? seName,
      @JsonKey(name: 'Id', includeIfNull: false) String? id,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _OutOfStockSubscriptionModel;

  factory OutOfStockSubscriptionModel.fromJson(Map<String, dynamic> json) =>
      _$OutOfStockSubscriptionModelFromJson(json);
}
