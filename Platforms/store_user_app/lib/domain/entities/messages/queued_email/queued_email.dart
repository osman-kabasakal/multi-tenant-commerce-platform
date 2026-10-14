import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../queued_email_priority/queued_email_priority.dart';

import '../../common/reference/reference.dart';

import '../../common/user_field/user_field.dart';


part 'queued_email.freezed.dart';
part 'queued_email.g.dart';

@freezed
class QueuedEmail extends StoreJsonSerializable<QueuedEmail> with _$QueuedEmail {
  factory QueuedEmail({ 
    @JsonKey(name: 'PriorityId', includeIfNull: false)
    @Default(QueuedEmailPriority.low) QueuedEmailPriority? priorityId,

    @JsonKey(name: 'From', includeIfNull: false)
     String? from,

    @JsonKey(name: 'FromName', includeIfNull: false)
     String? fromName,

    @JsonKey(name: 'To', includeIfNull: false)
     String? to,

    @JsonKey(name: 'ToName', includeIfNull: false)
     String? toName,

    @JsonKey(name: 'ReplyTo', includeIfNull: false)
     String? replyTo,

    @JsonKey(name: 'ReplyToName', includeIfNull: false)
     String? replyToName,

    @JsonKey(name: 'CC', includeIfNull: false)
     String? cC,

    @JsonKey(name: 'Bcc', includeIfNull: false)
     String? bcc,

    @JsonKey(name: 'Subject', includeIfNull: false)
     String? subject,

    @JsonKey(name: 'Body', includeIfNull: false)
     String? body,

    @JsonKey(name: 'AttachmentFilePath', includeIfNull: false)
     String? attachmentFilePath,

    @JsonKey(name: 'AttachmentFileName', includeIfNull: false)
     String? attachmentFileName,

    @JsonKey(name: 'AttachedDownloads', includeIfNull: false)
    @Default([]) List<String>? attachedDownloads,

    @JsonKey(name: 'DontSendBeforeDateUtc', includeIfNull: false)
    @Default(null) DateTime? dontSendBeforeDateUtc,

    @JsonKey(name: 'SentTries', includeIfNull: false)
     int? sentTries,

    @JsonKey(name: 'SentOnUtc', includeIfNull: false)
    @Default(null) DateTime? sentOnUtc,

    @JsonKey(name: 'ReadOnUtc', includeIfNull: false)
    @Default(null) DateTime? readOnUtc,

    @JsonKey(name: 'EmailAccountId', includeIfNull: false)
     String? emailAccountId,

    @JsonKey(name: 'Reference', includeIfNull: false)
    @Default(Reference.none) Reference? reference,

    @JsonKey(name: 'ObjectId', includeIfNull: false)
     String? objectId,

    @JsonKey(name: 'UserFields', includeIfNull: false)
    @Default([]) List<UserField>? userFields,

    @JsonKey(name: 'CreatedOnUtc', includeIfNull: false)
     DateTime? createdOnUtc,

    @JsonKey(name: 'CreatedBy', includeIfNull: false)
     String? createdBy,

    @JsonKey(name: 'UpdatedOnUtc', includeIfNull: false)
    @Default(null) DateTime? updatedOnUtc,

    @JsonKey(name: 'UpdatedBy', includeIfNull: false)
     String? updatedBy,

    @JsonKey(name: 'Id', includeIfNull: false)
     String? id
}) = _QueuedEmail;

  factory QueuedEmail.fromJson(Map<String, dynamic> json) =>
      _$QueuedEmailFromJson(json);
}