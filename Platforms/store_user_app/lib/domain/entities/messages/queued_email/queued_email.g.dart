// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'queued_email.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QueuedEmailImpl _$$QueuedEmailImplFromJson(Map<String, dynamic> json) =>
    _$QueuedEmailImpl(
      priorityId:
          $enumDecodeNullable(
            _$QueuedEmailPriorityEnumMap,
            json['PriorityId'],
          ) ??
          QueuedEmailPriority.low,
      from: json['From'] as String?,
      fromName: json['FromName'] as String?,
      to: json['To'] as String?,
      toName: json['ToName'] as String?,
      replyTo: json['ReplyTo'] as String?,
      replyToName: json['ReplyToName'] as String?,
      cC: json['CC'] as String?,
      bcc: json['Bcc'] as String?,
      subject: json['Subject'] as String?,
      body: json['Body'] as String?,
      attachmentFilePath: json['AttachmentFilePath'] as String?,
      attachmentFileName: json['AttachmentFileName'] as String?,
      attachedDownloads:
          (json['AttachedDownloads'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      dontSendBeforeDateUtc:
          json['DontSendBeforeDateUtc'] == null
              ? null
              : DateTime.parse(json['DontSendBeforeDateUtc'] as String),
      sentTries: (json['SentTries'] as num?)?.toInt(),
      sentOnUtc:
          json['SentOnUtc'] == null
              ? null
              : DateTime.parse(json['SentOnUtc'] as String),
      readOnUtc:
          json['ReadOnUtc'] == null
              ? null
              : DateTime.parse(json['ReadOnUtc'] as String),
      emailAccountId: json['EmailAccountId'] as String?,
      reference:
          $enumDecodeNullable(_$ReferenceEnumMap, json['Reference']) ??
          Reference.none,
      objectId: json['ObjectId'] as String?,
      userFields:
          (json['UserFields'] as List<dynamic>?)
              ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      createdOnUtc:
          json['CreatedOnUtc'] == null
              ? null
              : DateTime.parse(json['CreatedOnUtc'] as String),
      createdBy: json['CreatedBy'] as String?,
      updatedOnUtc:
          json['UpdatedOnUtc'] == null
              ? null
              : DateTime.parse(json['UpdatedOnUtc'] as String),
      updatedBy: json['UpdatedBy'] as String?,
      id: json['Id'] as String?,
    );

Map<String, dynamic> _$$QueuedEmailImplToJson(
  _$QueuedEmailImpl instance,
) => <String, dynamic>{
  if (_$QueuedEmailPriorityEnumMap[instance.priorityId] case final value?)
    'PriorityId': value,
  if (instance.from case final value?) 'From': value,
  if (instance.fromName case final value?) 'FromName': value,
  if (instance.to case final value?) 'To': value,
  if (instance.toName case final value?) 'ToName': value,
  if (instance.replyTo case final value?) 'ReplyTo': value,
  if (instance.replyToName case final value?) 'ReplyToName': value,
  if (instance.cC case final value?) 'CC': value,
  if (instance.bcc case final value?) 'Bcc': value,
  if (instance.subject case final value?) 'Subject': value,
  if (instance.body case final value?) 'Body': value,
  if (instance.attachmentFilePath case final value?)
    'AttachmentFilePath': value,
  if (instance.attachmentFileName case final value?)
    'AttachmentFileName': value,
  if (instance.attachedDownloads case final value?) 'AttachedDownloads': value,
  if (instance.dontSendBeforeDateUtc?.toIso8601String() case final value?)
    'DontSendBeforeDateUtc': value,
  if (instance.sentTries case final value?) 'SentTries': value,
  if (instance.sentOnUtc?.toIso8601String() case final value?)
    'SentOnUtc': value,
  if (instance.readOnUtc?.toIso8601String() case final value?)
    'ReadOnUtc': value,
  if (instance.emailAccountId case final value?) 'EmailAccountId': value,
  if (_$ReferenceEnumMap[instance.reference] case final value?)
    'Reference': value,
  if (instance.objectId case final value?) 'ObjectId': value,
  if (instance.userFields case final value?) 'UserFields': value,
  if (instance.createdOnUtc?.toIso8601String() case final value?)
    'CreatedOnUtc': value,
  if (instance.createdBy case final value?) 'CreatedBy': value,
  if (instance.updatedOnUtc?.toIso8601String() case final value?)
    'UpdatedOnUtc': value,
  if (instance.updatedBy case final value?) 'UpdatedBy': value,
  if (instance.id case final value?) 'Id': value,
};

const _$QueuedEmailPriorityEnumMap = {
  QueuedEmailPriority.low: 0,
  QueuedEmailPriority.high: 5,
};

const _$ReferenceEnumMap = {
  Reference.none: 0,
  Reference.order: 10,
  Reference.shipment: 20,
  Reference.merchandiseReturn: 30,
  Reference.product: 40,
  Reference.category: 50,
  Reference.brand: 60,
  Reference.collection: 70,
  Reference.vendor: 80,
  Reference.settings: 90,
  Reference.blog: 100,
  Reference.course: 110,
  Reference.document: 120,
  Reference.campaign: 130,
  Reference.customer: 150,
  Reference.other1: 901,
  Reference.other2: 902,
  Reference.other3: 903,
};
