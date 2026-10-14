import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

part 'anonymous_type_3037_ab66.freezed.dart';
part 'anonymous_type_3037_ab66.g.dart';

@freezed
class AnonymousType_3037AB66
    extends StoreJsonSerializable<AnonymousType_3037AB66>
    with _$AnonymousType_3037AB66 {
  factory AnonymousType_3037AB66(
      {@JsonKey(name: 'result', includeIfNull: false)
      @Default(false)
      bool? result}) = _AnonymousType_3037AB66;

  factory AnonymousType_3037AB66.fromJson(Map<String, dynamic> json) =>
      _$AnonymousType_3037AB66FromJson(json);
}
