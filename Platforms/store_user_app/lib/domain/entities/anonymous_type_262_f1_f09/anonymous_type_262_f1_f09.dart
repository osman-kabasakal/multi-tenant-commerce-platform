import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

part 'anonymous_type_262_f1_f09.freezed.dart';
part 'anonymous_type_262_f1_f09.g.dart';

@freezed
class AnonymousType_262F1F09
    extends StoreJsonSerializable<AnonymousType_262F1F09>
    with _$AnonymousType_262F1F09 {
  factory AnonymousType_262F1F09(
      {@JsonKey(name: 'stockAvailability', includeIfNull: false)
      String? stockAvailability}) = _AnonymousType_262F1F09;

  factory AnonymousType_262F1F09.fromJson(Map<String, dynamic> json) =>
      _$AnonymousType_262F1F09FromJson(json);
}
