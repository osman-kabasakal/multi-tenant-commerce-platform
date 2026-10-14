import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../../common/user_field/user_field.dart';

part 'tax_rate.freezed.dart';
part 'tax_rate.g.dart';

@freezed
class TaxRate extends StoreJsonSerializable<TaxRate> with _$TaxRate {
  factory TaxRate(
      {@JsonKey(name: 'Rate', includeIfNull: false) String? rate,
      @JsonKey(name: 'Value', includeIfNull: false) String? value,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _TaxRate;

  factory TaxRate.fromJson(Map<String, dynamic> json) =>
      _$TaxRateFromJson(json);
}
