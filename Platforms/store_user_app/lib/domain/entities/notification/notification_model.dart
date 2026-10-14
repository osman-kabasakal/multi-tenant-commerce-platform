import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';
import 'package:store_user_app/domain/entities/messages/queued_email/queued_email.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

@freezed
class NotificationListResponse
    with _$NotificationListResponse
    implements StoreJsonSerializable {
  const factory NotificationListResponse({
    @Default([]) @JsonKey(name: 'Data') List<QueuedEmail>? data,
    @JsonKey(name: 'Total') int? total,
  }) = _NotificationListResponse;

  factory NotificationListResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificationListResponseFromJson(json);
}

@freezed
class NotificationDetailResponse
    with _$NotificationDetailResponse
    implements StoreJsonSerializable {
  const factory NotificationDetailResponse({
    bool? success,
    QueuedEmail? message,
  }) = _NotificationDetailResponse;

  factory NotificationDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificationDetailResponseFromJson(json);
}
