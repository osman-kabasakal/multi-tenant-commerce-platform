// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

part 'anonymous_type__a25_e79_e1.freezed.dart';
part 'anonymous_type__a25_e79_e1.g.dart';

@freezed
class AnonymousType_A25E79E1
    extends StoreJsonSerializable<AnonymousType_A25E79E1>
    with _$AnonymousType_A25E79E1 {
  factory AnonymousType_A25E79E1(
      {@JsonKey(name: 'enabledattributeids', includeIfNull: false)
      Object? enabledattributeids,
      @JsonKey(name: 'disabledattributeids', includeIfNull: false)
      Object? disabledattributeids,
      @JsonKey(name: 'model', includeIfNull: false) Object? model,
      @JsonKey(name: 'checkoutattributeinfo', includeIfNull: false)
      Object? checkoutattributeinfo}) = _AnonymousType_A25E79E1;

  factory AnonymousType_A25E79E1.fromJson(Map<String, dynamic> json) =>
      _$AnonymousType_A25E79E1FromJson(json);
}
