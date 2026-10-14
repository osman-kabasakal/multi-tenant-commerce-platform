import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../../common/user_field/user_field.dart';

part 'payment_method_model.freezed.dart';
part 'payment_method_model.g.dart';

@freezed
class PaymentMethodModel extends StoreJsonSerializable<PaymentMethodModel>
    with _$PaymentMethodModel {
  factory PaymentMethodModel(
      {@JsonKey(name: 'PaymentMethodSystemName', includeIfNull: false)
      String? paymentMethodSystemName,
      @JsonKey(name: 'Name', includeIfNull: false) String? name,
      @JsonKey(name: 'Description', includeIfNull: false) String? description,
      @JsonKey(name: 'Fee', includeIfNull: false) String? fee,
      @JsonKey(name: 'Selected', includeIfNull: false)
      @Default(false)
      bool? selected,
      @JsonKey(name: 'LogoUrl', includeIfNull: false) String? logoUrl,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _PaymentMethodModel;

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodModelFromJson(json);
}
