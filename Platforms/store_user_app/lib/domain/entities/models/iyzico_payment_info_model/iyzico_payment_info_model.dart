import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../utilities/field_definition/field_definition.dart';

import '../../model/card/card.dart';

import '../../common/user_field/user_field.dart';


part 'iyzico_payment_info_model.freezed.dart';
part 'iyzico_payment_info_model.g.dart';

@freezed
class IyzicoPaymentInfoModel extends StoreJsonSerializable<IyzicoPaymentInfoModel> with _$IyzicoPaymentInfoModel {
  factory IyzicoPaymentInfoModel({ 
    @JsonKey(name: 'CreditCardFormData', includeIfNull: false)
    @Default({}) Map<String, FieldDefinition>? creditCardFormData,

    @JsonKey(name: 'StoredUserCards', includeIfNull: false)
    @Default([]) List<Card>? storedUserCards,

    @JsonKey(name: 'SandBox', includeIfNull: false)
    @Default(false) bool? sandBox,

    @JsonKey(name: 'SelectedCardToken', includeIfNull: false)
     String? selectedCardToken,

    @JsonKey(name: 'InstallmentQueryUrl', includeIfNull: false)
     String? installmentQueryUrl,

    @JsonKey(name: 'IyzicoBrandImageUrl', includeIfNull: false)
     String? iyzicoBrandImageUrl,

    @JsonKey(name: 'CreditCardBrandUrl', includeIfNull: false)
     String? creditCardBrandUrl,

    @JsonKey(name: 'UserFields', includeIfNull: false)
    @Default([]) List<UserField>? userFields
}) = _IyzicoPaymentInfoModel;

  factory IyzicoPaymentInfoModel.fromJson(Map<String, dynamic> json) =>
      _$IyzicoPaymentInfoModelFromJson(json);
}