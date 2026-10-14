// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'queued_email.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

QueuedEmail _$QueuedEmailFromJson(Map<String, dynamic> json) {
  return _QueuedEmail.fromJson(json);
}

/// @nodoc
mixin _$QueuedEmail {
  @JsonKey(name: 'PriorityId', includeIfNull: false)
  QueuedEmailPriority? get priorityId => throw _privateConstructorUsedError;
  @JsonKey(name: 'From', includeIfNull: false)
  String? get from => throw _privateConstructorUsedError;
  @JsonKey(name: 'FromName', includeIfNull: false)
  String? get fromName => throw _privateConstructorUsedError;
  @JsonKey(name: 'To', includeIfNull: false)
  String? get to => throw _privateConstructorUsedError;
  @JsonKey(name: 'ToName', includeIfNull: false)
  String? get toName => throw _privateConstructorUsedError;
  @JsonKey(name: 'ReplyTo', includeIfNull: false)
  String? get replyTo => throw _privateConstructorUsedError;
  @JsonKey(name: 'ReplyToName', includeIfNull: false)
  String? get replyToName => throw _privateConstructorUsedError;
  @JsonKey(name: 'CC', includeIfNull: false)
  String? get cC => throw _privateConstructorUsedError;
  @JsonKey(name: 'Bcc', includeIfNull: false)
  String? get bcc => throw _privateConstructorUsedError;
  @JsonKey(name: 'Subject', includeIfNull: false)
  String? get subject => throw _privateConstructorUsedError;
  @JsonKey(name: 'Body', includeIfNull: false)
  String? get body => throw _privateConstructorUsedError;
  @JsonKey(name: 'AttachmentFilePath', includeIfNull: false)
  String? get attachmentFilePath => throw _privateConstructorUsedError;
  @JsonKey(name: 'AttachmentFileName', includeIfNull: false)
  String? get attachmentFileName => throw _privateConstructorUsedError;
  @JsonKey(name: 'AttachedDownloads', includeIfNull: false)
  List<String>? get attachedDownloads => throw _privateConstructorUsedError;
  @JsonKey(name: 'DontSendBeforeDateUtc', includeIfNull: false)
  DateTime? get dontSendBeforeDateUtc => throw _privateConstructorUsedError;
  @JsonKey(name: 'SentTries', includeIfNull: false)
  int? get sentTries => throw _privateConstructorUsedError;
  @JsonKey(name: 'SentOnUtc', includeIfNull: false)
  DateTime? get sentOnUtc => throw _privateConstructorUsedError;
  @JsonKey(name: 'ReadOnUtc', includeIfNull: false)
  DateTime? get readOnUtc => throw _privateConstructorUsedError;
  @JsonKey(name: 'EmailAccountId', includeIfNull: false)
  String? get emailAccountId => throw _privateConstructorUsedError;
  @JsonKey(name: 'Reference', includeIfNull: false)
  Reference? get reference => throw _privateConstructorUsedError;
  @JsonKey(name: 'ObjectId', includeIfNull: false)
  String? get objectId => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;
  @JsonKey(name: 'CreatedOnUtc', includeIfNull: false)
  DateTime? get createdOnUtc => throw _privateConstructorUsedError;
  @JsonKey(name: 'CreatedBy', includeIfNull: false)
  String? get createdBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'UpdatedOnUtc', includeIfNull: false)
  DateTime? get updatedOnUtc => throw _privateConstructorUsedError;
  @JsonKey(name: 'UpdatedBy', includeIfNull: false)
  String? get updatedBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id => throw _privateConstructorUsedError;

  /// Serializes this QueuedEmail to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QueuedEmail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QueuedEmailCopyWith<QueuedEmail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QueuedEmailCopyWith<$Res> {
  factory $QueuedEmailCopyWith(
    QueuedEmail value,
    $Res Function(QueuedEmail) then,
  ) = _$QueuedEmailCopyWithImpl<$Res, QueuedEmail>;
  @useResult
  $Res call({
    @JsonKey(name: 'PriorityId', includeIfNull: false)
    QueuedEmailPriority? priorityId,
    @JsonKey(name: 'From', includeIfNull: false) String? from,
    @JsonKey(name: 'FromName', includeIfNull: false) String? fromName,
    @JsonKey(name: 'To', includeIfNull: false) String? to,
    @JsonKey(name: 'ToName', includeIfNull: false) String? toName,
    @JsonKey(name: 'ReplyTo', includeIfNull: false) String? replyTo,
    @JsonKey(name: 'ReplyToName', includeIfNull: false) String? replyToName,
    @JsonKey(name: 'CC', includeIfNull: false) String? cC,
    @JsonKey(name: 'Bcc', includeIfNull: false) String? bcc,
    @JsonKey(name: 'Subject', includeIfNull: false) String? subject,
    @JsonKey(name: 'Body', includeIfNull: false) String? body,
    @JsonKey(name: 'AttachmentFilePath', includeIfNull: false)
    String? attachmentFilePath,
    @JsonKey(name: 'AttachmentFileName', includeIfNull: false)
    String? attachmentFileName,
    @JsonKey(name: 'AttachedDownloads', includeIfNull: false)
    List<String>? attachedDownloads,
    @JsonKey(name: 'DontSendBeforeDateUtc', includeIfNull: false)
    DateTime? dontSendBeforeDateUtc,
    @JsonKey(name: 'SentTries', includeIfNull: false) int? sentTries,
    @JsonKey(name: 'SentOnUtc', includeIfNull: false) DateTime? sentOnUtc,
    @JsonKey(name: 'ReadOnUtc', includeIfNull: false) DateTime? readOnUtc,
    @JsonKey(name: 'EmailAccountId', includeIfNull: false)
    String? emailAccountId,
    @JsonKey(name: 'Reference', includeIfNull: false) Reference? reference,
    @JsonKey(name: 'ObjectId', includeIfNull: false) String? objectId,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
    @JsonKey(name: 'CreatedOnUtc', includeIfNull: false) DateTime? createdOnUtc,
    @JsonKey(name: 'CreatedBy', includeIfNull: false) String? createdBy,
    @JsonKey(name: 'UpdatedOnUtc', includeIfNull: false) DateTime? updatedOnUtc,
    @JsonKey(name: 'UpdatedBy', includeIfNull: false) String? updatedBy,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
  });
}

/// @nodoc
class _$QueuedEmailCopyWithImpl<$Res, $Val extends QueuedEmail>
    implements $QueuedEmailCopyWith<$Res> {
  _$QueuedEmailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QueuedEmail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? priorityId = freezed,
    Object? from = freezed,
    Object? fromName = freezed,
    Object? to = freezed,
    Object? toName = freezed,
    Object? replyTo = freezed,
    Object? replyToName = freezed,
    Object? cC = freezed,
    Object? bcc = freezed,
    Object? subject = freezed,
    Object? body = freezed,
    Object? attachmentFilePath = freezed,
    Object? attachmentFileName = freezed,
    Object? attachedDownloads = freezed,
    Object? dontSendBeforeDateUtc = freezed,
    Object? sentTries = freezed,
    Object? sentOnUtc = freezed,
    Object? readOnUtc = freezed,
    Object? emailAccountId = freezed,
    Object? reference = freezed,
    Object? objectId = freezed,
    Object? userFields = freezed,
    Object? createdOnUtc = freezed,
    Object? createdBy = freezed,
    Object? updatedOnUtc = freezed,
    Object? updatedBy = freezed,
    Object? id = freezed,
  }) {
    return _then(
      _value.copyWith(
            priorityId:
                freezed == priorityId
                    ? _value.priorityId
                    : priorityId // ignore: cast_nullable_to_non_nullable
                        as QueuedEmailPriority?,
            from:
                freezed == from
                    ? _value.from
                    : from // ignore: cast_nullable_to_non_nullable
                        as String?,
            fromName:
                freezed == fromName
                    ? _value.fromName
                    : fromName // ignore: cast_nullable_to_non_nullable
                        as String?,
            to:
                freezed == to
                    ? _value.to
                    : to // ignore: cast_nullable_to_non_nullable
                        as String?,
            toName:
                freezed == toName
                    ? _value.toName
                    : toName // ignore: cast_nullable_to_non_nullable
                        as String?,
            replyTo:
                freezed == replyTo
                    ? _value.replyTo
                    : replyTo // ignore: cast_nullable_to_non_nullable
                        as String?,
            replyToName:
                freezed == replyToName
                    ? _value.replyToName
                    : replyToName // ignore: cast_nullable_to_non_nullable
                        as String?,
            cC:
                freezed == cC
                    ? _value.cC
                    : cC // ignore: cast_nullable_to_non_nullable
                        as String?,
            bcc:
                freezed == bcc
                    ? _value.bcc
                    : bcc // ignore: cast_nullable_to_non_nullable
                        as String?,
            subject:
                freezed == subject
                    ? _value.subject
                    : subject // ignore: cast_nullable_to_non_nullable
                        as String?,
            body:
                freezed == body
                    ? _value.body
                    : body // ignore: cast_nullable_to_non_nullable
                        as String?,
            attachmentFilePath:
                freezed == attachmentFilePath
                    ? _value.attachmentFilePath
                    : attachmentFilePath // ignore: cast_nullable_to_non_nullable
                        as String?,
            attachmentFileName:
                freezed == attachmentFileName
                    ? _value.attachmentFileName
                    : attachmentFileName // ignore: cast_nullable_to_non_nullable
                        as String?,
            attachedDownloads:
                freezed == attachedDownloads
                    ? _value.attachedDownloads
                    : attachedDownloads // ignore: cast_nullable_to_non_nullable
                        as List<String>?,
            dontSendBeforeDateUtc:
                freezed == dontSendBeforeDateUtc
                    ? _value.dontSendBeforeDateUtc
                    : dontSendBeforeDateUtc // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            sentTries:
                freezed == sentTries
                    ? _value.sentTries
                    : sentTries // ignore: cast_nullable_to_non_nullable
                        as int?,
            sentOnUtc:
                freezed == sentOnUtc
                    ? _value.sentOnUtc
                    : sentOnUtc // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            readOnUtc:
                freezed == readOnUtc
                    ? _value.readOnUtc
                    : readOnUtc // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            emailAccountId:
                freezed == emailAccountId
                    ? _value.emailAccountId
                    : emailAccountId // ignore: cast_nullable_to_non_nullable
                        as String?,
            reference:
                freezed == reference
                    ? _value.reference
                    : reference // ignore: cast_nullable_to_non_nullable
                        as Reference?,
            objectId:
                freezed == objectId
                    ? _value.objectId
                    : objectId // ignore: cast_nullable_to_non_nullable
                        as String?,
            userFields:
                freezed == userFields
                    ? _value.userFields
                    : userFields // ignore: cast_nullable_to_non_nullable
                        as List<UserField>?,
            createdOnUtc:
                freezed == createdOnUtc
                    ? _value.createdOnUtc
                    : createdOnUtc // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            createdBy:
                freezed == createdBy
                    ? _value.createdBy
                    : createdBy // ignore: cast_nullable_to_non_nullable
                        as String?,
            updatedOnUtc:
                freezed == updatedOnUtc
                    ? _value.updatedOnUtc
                    : updatedOnUtc // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            updatedBy:
                freezed == updatedBy
                    ? _value.updatedBy
                    : updatedBy // ignore: cast_nullable_to_non_nullable
                        as String?,
            id:
                freezed == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$QueuedEmailImplCopyWith<$Res>
    implements $QueuedEmailCopyWith<$Res> {
  factory _$$QueuedEmailImplCopyWith(
    _$QueuedEmailImpl value,
    $Res Function(_$QueuedEmailImpl) then,
  ) = __$$QueuedEmailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'PriorityId', includeIfNull: false)
    QueuedEmailPriority? priorityId,
    @JsonKey(name: 'From', includeIfNull: false) String? from,
    @JsonKey(name: 'FromName', includeIfNull: false) String? fromName,
    @JsonKey(name: 'To', includeIfNull: false) String? to,
    @JsonKey(name: 'ToName', includeIfNull: false) String? toName,
    @JsonKey(name: 'ReplyTo', includeIfNull: false) String? replyTo,
    @JsonKey(name: 'ReplyToName', includeIfNull: false) String? replyToName,
    @JsonKey(name: 'CC', includeIfNull: false) String? cC,
    @JsonKey(name: 'Bcc', includeIfNull: false) String? bcc,
    @JsonKey(name: 'Subject', includeIfNull: false) String? subject,
    @JsonKey(name: 'Body', includeIfNull: false) String? body,
    @JsonKey(name: 'AttachmentFilePath', includeIfNull: false)
    String? attachmentFilePath,
    @JsonKey(name: 'AttachmentFileName', includeIfNull: false)
    String? attachmentFileName,
    @JsonKey(name: 'AttachedDownloads', includeIfNull: false)
    List<String>? attachedDownloads,
    @JsonKey(name: 'DontSendBeforeDateUtc', includeIfNull: false)
    DateTime? dontSendBeforeDateUtc,
    @JsonKey(name: 'SentTries', includeIfNull: false) int? sentTries,
    @JsonKey(name: 'SentOnUtc', includeIfNull: false) DateTime? sentOnUtc,
    @JsonKey(name: 'ReadOnUtc', includeIfNull: false) DateTime? readOnUtc,
    @JsonKey(name: 'EmailAccountId', includeIfNull: false)
    String? emailAccountId,
    @JsonKey(name: 'Reference', includeIfNull: false) Reference? reference,
    @JsonKey(name: 'ObjectId', includeIfNull: false) String? objectId,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
    @JsonKey(name: 'CreatedOnUtc', includeIfNull: false) DateTime? createdOnUtc,
    @JsonKey(name: 'CreatedBy', includeIfNull: false) String? createdBy,
    @JsonKey(name: 'UpdatedOnUtc', includeIfNull: false) DateTime? updatedOnUtc,
    @JsonKey(name: 'UpdatedBy', includeIfNull: false) String? updatedBy,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
  });
}

/// @nodoc
class __$$QueuedEmailImplCopyWithImpl<$Res>
    extends _$QueuedEmailCopyWithImpl<$Res, _$QueuedEmailImpl>
    implements _$$QueuedEmailImplCopyWith<$Res> {
  __$$QueuedEmailImplCopyWithImpl(
    _$QueuedEmailImpl _value,
    $Res Function(_$QueuedEmailImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QueuedEmail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? priorityId = freezed,
    Object? from = freezed,
    Object? fromName = freezed,
    Object? to = freezed,
    Object? toName = freezed,
    Object? replyTo = freezed,
    Object? replyToName = freezed,
    Object? cC = freezed,
    Object? bcc = freezed,
    Object? subject = freezed,
    Object? body = freezed,
    Object? attachmentFilePath = freezed,
    Object? attachmentFileName = freezed,
    Object? attachedDownloads = freezed,
    Object? dontSendBeforeDateUtc = freezed,
    Object? sentTries = freezed,
    Object? sentOnUtc = freezed,
    Object? readOnUtc = freezed,
    Object? emailAccountId = freezed,
    Object? reference = freezed,
    Object? objectId = freezed,
    Object? userFields = freezed,
    Object? createdOnUtc = freezed,
    Object? createdBy = freezed,
    Object? updatedOnUtc = freezed,
    Object? updatedBy = freezed,
    Object? id = freezed,
  }) {
    return _then(
      _$QueuedEmailImpl(
        priorityId:
            freezed == priorityId
                ? _value.priorityId
                : priorityId // ignore: cast_nullable_to_non_nullable
                    as QueuedEmailPriority?,
        from:
            freezed == from
                ? _value.from
                : from // ignore: cast_nullable_to_non_nullable
                    as String?,
        fromName:
            freezed == fromName
                ? _value.fromName
                : fromName // ignore: cast_nullable_to_non_nullable
                    as String?,
        to:
            freezed == to
                ? _value.to
                : to // ignore: cast_nullable_to_non_nullable
                    as String?,
        toName:
            freezed == toName
                ? _value.toName
                : toName // ignore: cast_nullable_to_non_nullable
                    as String?,
        replyTo:
            freezed == replyTo
                ? _value.replyTo
                : replyTo // ignore: cast_nullable_to_non_nullable
                    as String?,
        replyToName:
            freezed == replyToName
                ? _value.replyToName
                : replyToName // ignore: cast_nullable_to_non_nullable
                    as String?,
        cC:
            freezed == cC
                ? _value.cC
                : cC // ignore: cast_nullable_to_non_nullable
                    as String?,
        bcc:
            freezed == bcc
                ? _value.bcc
                : bcc // ignore: cast_nullable_to_non_nullable
                    as String?,
        subject:
            freezed == subject
                ? _value.subject
                : subject // ignore: cast_nullable_to_non_nullable
                    as String?,
        body:
            freezed == body
                ? _value.body
                : body // ignore: cast_nullable_to_non_nullable
                    as String?,
        attachmentFilePath:
            freezed == attachmentFilePath
                ? _value.attachmentFilePath
                : attachmentFilePath // ignore: cast_nullable_to_non_nullable
                    as String?,
        attachmentFileName:
            freezed == attachmentFileName
                ? _value.attachmentFileName
                : attachmentFileName // ignore: cast_nullable_to_non_nullable
                    as String?,
        attachedDownloads:
            freezed == attachedDownloads
                ? _value._attachedDownloads
                : attachedDownloads // ignore: cast_nullable_to_non_nullable
                    as List<String>?,
        dontSendBeforeDateUtc:
            freezed == dontSendBeforeDateUtc
                ? _value.dontSendBeforeDateUtc
                : dontSendBeforeDateUtc // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        sentTries:
            freezed == sentTries
                ? _value.sentTries
                : sentTries // ignore: cast_nullable_to_non_nullable
                    as int?,
        sentOnUtc:
            freezed == sentOnUtc
                ? _value.sentOnUtc
                : sentOnUtc // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        readOnUtc:
            freezed == readOnUtc
                ? _value.readOnUtc
                : readOnUtc // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        emailAccountId:
            freezed == emailAccountId
                ? _value.emailAccountId
                : emailAccountId // ignore: cast_nullable_to_non_nullable
                    as String?,
        reference:
            freezed == reference
                ? _value.reference
                : reference // ignore: cast_nullable_to_non_nullable
                    as Reference?,
        objectId:
            freezed == objectId
                ? _value.objectId
                : objectId // ignore: cast_nullable_to_non_nullable
                    as String?,
        userFields:
            freezed == userFields
                ? _value._userFields
                : userFields // ignore: cast_nullable_to_non_nullable
                    as List<UserField>?,
        createdOnUtc:
            freezed == createdOnUtc
                ? _value.createdOnUtc
                : createdOnUtc // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        createdBy:
            freezed == createdBy
                ? _value.createdBy
                : createdBy // ignore: cast_nullable_to_non_nullable
                    as String?,
        updatedOnUtc:
            freezed == updatedOnUtc
                ? _value.updatedOnUtc
                : updatedOnUtc // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        updatedBy:
            freezed == updatedBy
                ? _value.updatedBy
                : updatedBy // ignore: cast_nullable_to_non_nullable
                    as String?,
        id:
            freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$QueuedEmailImpl implements _QueuedEmail {
  _$QueuedEmailImpl({
    @JsonKey(name: 'PriorityId', includeIfNull: false)
    this.priorityId = QueuedEmailPriority.low,
    @JsonKey(name: 'From', includeIfNull: false) this.from,
    @JsonKey(name: 'FromName', includeIfNull: false) this.fromName,
    @JsonKey(name: 'To', includeIfNull: false) this.to,
    @JsonKey(name: 'ToName', includeIfNull: false) this.toName,
    @JsonKey(name: 'ReplyTo', includeIfNull: false) this.replyTo,
    @JsonKey(name: 'ReplyToName', includeIfNull: false) this.replyToName,
    @JsonKey(name: 'CC', includeIfNull: false) this.cC,
    @JsonKey(name: 'Bcc', includeIfNull: false) this.bcc,
    @JsonKey(name: 'Subject', includeIfNull: false) this.subject,
    @JsonKey(name: 'Body', includeIfNull: false) this.body,
    @JsonKey(name: 'AttachmentFilePath', includeIfNull: false)
    this.attachmentFilePath,
    @JsonKey(name: 'AttachmentFileName', includeIfNull: false)
    this.attachmentFileName,
    @JsonKey(name: 'AttachedDownloads', includeIfNull: false)
    final List<String>? attachedDownloads = const [],
    @JsonKey(name: 'DontSendBeforeDateUtc', includeIfNull: false)
    this.dontSendBeforeDateUtc = null,
    @JsonKey(name: 'SentTries', includeIfNull: false) this.sentTries,
    @JsonKey(name: 'SentOnUtc', includeIfNull: false) this.sentOnUtc = null,
    @JsonKey(name: 'ReadOnUtc', includeIfNull: false) this.readOnUtc = null,
    @JsonKey(name: 'EmailAccountId', includeIfNull: false) this.emailAccountId,
    @JsonKey(name: 'Reference', includeIfNull: false)
    this.reference = Reference.none,
    @JsonKey(name: 'ObjectId', includeIfNull: false) this.objectId,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
    @JsonKey(name: 'CreatedOnUtc', includeIfNull: false) this.createdOnUtc,
    @JsonKey(name: 'CreatedBy', includeIfNull: false) this.createdBy,
    @JsonKey(name: 'UpdatedOnUtc', includeIfNull: false)
    this.updatedOnUtc = null,
    @JsonKey(name: 'UpdatedBy', includeIfNull: false) this.updatedBy,
    @JsonKey(name: 'Id', includeIfNull: false) this.id,
  }) : _attachedDownloads = attachedDownloads,
       _userFields = userFields;

  factory _$QueuedEmailImpl.fromJson(Map<String, dynamic> json) =>
      _$$QueuedEmailImplFromJson(json);

  @override
  @JsonKey(name: 'PriorityId', includeIfNull: false)
  final QueuedEmailPriority? priorityId;
  @override
  @JsonKey(name: 'From', includeIfNull: false)
  final String? from;
  @override
  @JsonKey(name: 'FromName', includeIfNull: false)
  final String? fromName;
  @override
  @JsonKey(name: 'To', includeIfNull: false)
  final String? to;
  @override
  @JsonKey(name: 'ToName', includeIfNull: false)
  final String? toName;
  @override
  @JsonKey(name: 'ReplyTo', includeIfNull: false)
  final String? replyTo;
  @override
  @JsonKey(name: 'ReplyToName', includeIfNull: false)
  final String? replyToName;
  @override
  @JsonKey(name: 'CC', includeIfNull: false)
  final String? cC;
  @override
  @JsonKey(name: 'Bcc', includeIfNull: false)
  final String? bcc;
  @override
  @JsonKey(name: 'Subject', includeIfNull: false)
  final String? subject;
  @override
  @JsonKey(name: 'Body', includeIfNull: false)
  final String? body;
  @override
  @JsonKey(name: 'AttachmentFilePath', includeIfNull: false)
  final String? attachmentFilePath;
  @override
  @JsonKey(name: 'AttachmentFileName', includeIfNull: false)
  final String? attachmentFileName;
  final List<String>? _attachedDownloads;
  @override
  @JsonKey(name: 'AttachedDownloads', includeIfNull: false)
  List<String>? get attachedDownloads {
    final value = _attachedDownloads;
    if (value == null) return null;
    if (_attachedDownloads is EqualUnmodifiableListView)
      return _attachedDownloads;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'DontSendBeforeDateUtc', includeIfNull: false)
  final DateTime? dontSendBeforeDateUtc;
  @override
  @JsonKey(name: 'SentTries', includeIfNull: false)
  final int? sentTries;
  @override
  @JsonKey(name: 'SentOnUtc', includeIfNull: false)
  final DateTime? sentOnUtc;
  @override
  @JsonKey(name: 'ReadOnUtc', includeIfNull: false)
  final DateTime? readOnUtc;
  @override
  @JsonKey(name: 'EmailAccountId', includeIfNull: false)
  final String? emailAccountId;
  @override
  @JsonKey(name: 'Reference', includeIfNull: false)
  final Reference? reference;
  @override
  @JsonKey(name: 'ObjectId', includeIfNull: false)
  final String? objectId;
  final List<UserField>? _userFields;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields {
    final value = _userFields;
    if (value == null) return null;
    if (_userFields is EqualUnmodifiableListView) return _userFields;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'CreatedOnUtc', includeIfNull: false)
  final DateTime? createdOnUtc;
  @override
  @JsonKey(name: 'CreatedBy', includeIfNull: false)
  final String? createdBy;
  @override
  @JsonKey(name: 'UpdatedOnUtc', includeIfNull: false)
  final DateTime? updatedOnUtc;
  @override
  @JsonKey(name: 'UpdatedBy', includeIfNull: false)
  final String? updatedBy;
  @override
  @JsonKey(name: 'Id', includeIfNull: false)
  final String? id;

  @override
  String toString() {
    return 'QueuedEmail(priorityId: $priorityId, from: $from, fromName: $fromName, to: $to, toName: $toName, replyTo: $replyTo, replyToName: $replyToName, cC: $cC, bcc: $bcc, subject: $subject, body: $body, attachmentFilePath: $attachmentFilePath, attachmentFileName: $attachmentFileName, attachedDownloads: $attachedDownloads, dontSendBeforeDateUtc: $dontSendBeforeDateUtc, sentTries: $sentTries, sentOnUtc: $sentOnUtc, readOnUtc: $readOnUtc, emailAccountId: $emailAccountId, reference: $reference, objectId: $objectId, userFields: $userFields, createdOnUtc: $createdOnUtc, createdBy: $createdBy, updatedOnUtc: $updatedOnUtc, updatedBy: $updatedBy, id: $id)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QueuedEmailImpl &&
            (identical(other.priorityId, priorityId) ||
                other.priorityId == priorityId) &&
            (identical(other.from, from) || other.from == from) &&
            (identical(other.fromName, fromName) ||
                other.fromName == fromName) &&
            (identical(other.to, to) || other.to == to) &&
            (identical(other.toName, toName) || other.toName == toName) &&
            (identical(other.replyTo, replyTo) || other.replyTo == replyTo) &&
            (identical(other.replyToName, replyToName) ||
                other.replyToName == replyToName) &&
            (identical(other.cC, cC) || other.cC == cC) &&
            (identical(other.bcc, bcc) || other.bcc == bcc) &&
            (identical(other.subject, subject) || other.subject == subject) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.attachmentFilePath, attachmentFilePath) ||
                other.attachmentFilePath == attachmentFilePath) &&
            (identical(other.attachmentFileName, attachmentFileName) ||
                other.attachmentFileName == attachmentFileName) &&
            const DeepCollectionEquality().equals(
              other._attachedDownloads,
              _attachedDownloads,
            ) &&
            (identical(other.dontSendBeforeDateUtc, dontSendBeforeDateUtc) ||
                other.dontSendBeforeDateUtc == dontSendBeforeDateUtc) &&
            (identical(other.sentTries, sentTries) ||
                other.sentTries == sentTries) &&
            (identical(other.sentOnUtc, sentOnUtc) ||
                other.sentOnUtc == sentOnUtc) &&
            (identical(other.readOnUtc, readOnUtc) ||
                other.readOnUtc == readOnUtc) &&
            (identical(other.emailAccountId, emailAccountId) ||
                other.emailAccountId == emailAccountId) &&
            (identical(other.reference, reference) ||
                other.reference == reference) &&
            (identical(other.objectId, objectId) ||
                other.objectId == objectId) &&
            const DeepCollectionEquality().equals(
              other._userFields,
              _userFields,
            ) &&
            (identical(other.createdOnUtc, createdOnUtc) ||
                other.createdOnUtc == createdOnUtc) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.updatedOnUtc, updatedOnUtc) ||
                other.updatedOnUtc == updatedOnUtc) &&
            (identical(other.updatedBy, updatedBy) ||
                other.updatedBy == updatedBy) &&
            (identical(other.id, id) || other.id == id));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    priorityId,
    from,
    fromName,
    to,
    toName,
    replyTo,
    replyToName,
    cC,
    bcc,
    subject,
    body,
    attachmentFilePath,
    attachmentFileName,
    const DeepCollectionEquality().hash(_attachedDownloads),
    dontSendBeforeDateUtc,
    sentTries,
    sentOnUtc,
    readOnUtc,
    emailAccountId,
    reference,
    objectId,
    const DeepCollectionEquality().hash(_userFields),
    createdOnUtc,
    createdBy,
    updatedOnUtc,
    updatedBy,
    id,
  ]);

  /// Create a copy of QueuedEmail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QueuedEmailImplCopyWith<_$QueuedEmailImpl> get copyWith =>
      __$$QueuedEmailImplCopyWithImpl<_$QueuedEmailImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QueuedEmailImplToJson(this);
  }
}

abstract class _QueuedEmail implements QueuedEmail {
  factory _QueuedEmail({
    @JsonKey(name: 'PriorityId', includeIfNull: false)
    final QueuedEmailPriority? priorityId,
    @JsonKey(name: 'From', includeIfNull: false) final String? from,
    @JsonKey(name: 'FromName', includeIfNull: false) final String? fromName,
    @JsonKey(name: 'To', includeIfNull: false) final String? to,
    @JsonKey(name: 'ToName', includeIfNull: false) final String? toName,
    @JsonKey(name: 'ReplyTo', includeIfNull: false) final String? replyTo,
    @JsonKey(name: 'ReplyToName', includeIfNull: false)
    final String? replyToName,
    @JsonKey(name: 'CC', includeIfNull: false) final String? cC,
    @JsonKey(name: 'Bcc', includeIfNull: false) final String? bcc,
    @JsonKey(name: 'Subject', includeIfNull: false) final String? subject,
    @JsonKey(name: 'Body', includeIfNull: false) final String? body,
    @JsonKey(name: 'AttachmentFilePath', includeIfNull: false)
    final String? attachmentFilePath,
    @JsonKey(name: 'AttachmentFileName', includeIfNull: false)
    final String? attachmentFileName,
    @JsonKey(name: 'AttachedDownloads', includeIfNull: false)
    final List<String>? attachedDownloads,
    @JsonKey(name: 'DontSendBeforeDateUtc', includeIfNull: false)
    final DateTime? dontSendBeforeDateUtc,
    @JsonKey(name: 'SentTries', includeIfNull: false) final int? sentTries,
    @JsonKey(name: 'SentOnUtc', includeIfNull: false) final DateTime? sentOnUtc,
    @JsonKey(name: 'ReadOnUtc', includeIfNull: false) final DateTime? readOnUtc,
    @JsonKey(name: 'EmailAccountId', includeIfNull: false)
    final String? emailAccountId,
    @JsonKey(name: 'Reference', includeIfNull: false)
    final Reference? reference,
    @JsonKey(name: 'ObjectId', includeIfNull: false) final String? objectId,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
    @JsonKey(name: 'CreatedOnUtc', includeIfNull: false)
    final DateTime? createdOnUtc,
    @JsonKey(name: 'CreatedBy', includeIfNull: false) final String? createdBy,
    @JsonKey(name: 'UpdatedOnUtc', includeIfNull: false)
    final DateTime? updatedOnUtc,
    @JsonKey(name: 'UpdatedBy', includeIfNull: false) final String? updatedBy,
    @JsonKey(name: 'Id', includeIfNull: false) final String? id,
  }) = _$QueuedEmailImpl;

  factory _QueuedEmail.fromJson(Map<String, dynamic> json) =
      _$QueuedEmailImpl.fromJson;

  @override
  @JsonKey(name: 'PriorityId', includeIfNull: false)
  QueuedEmailPriority? get priorityId;
  @override
  @JsonKey(name: 'From', includeIfNull: false)
  String? get from;
  @override
  @JsonKey(name: 'FromName', includeIfNull: false)
  String? get fromName;
  @override
  @JsonKey(name: 'To', includeIfNull: false)
  String? get to;
  @override
  @JsonKey(name: 'ToName', includeIfNull: false)
  String? get toName;
  @override
  @JsonKey(name: 'ReplyTo', includeIfNull: false)
  String? get replyTo;
  @override
  @JsonKey(name: 'ReplyToName', includeIfNull: false)
  String? get replyToName;
  @override
  @JsonKey(name: 'CC', includeIfNull: false)
  String? get cC;
  @override
  @JsonKey(name: 'Bcc', includeIfNull: false)
  String? get bcc;
  @override
  @JsonKey(name: 'Subject', includeIfNull: false)
  String? get subject;
  @override
  @JsonKey(name: 'Body', includeIfNull: false)
  String? get body;
  @override
  @JsonKey(name: 'AttachmentFilePath', includeIfNull: false)
  String? get attachmentFilePath;
  @override
  @JsonKey(name: 'AttachmentFileName', includeIfNull: false)
  String? get attachmentFileName;
  @override
  @JsonKey(name: 'AttachedDownloads', includeIfNull: false)
  List<String>? get attachedDownloads;
  @override
  @JsonKey(name: 'DontSendBeforeDateUtc', includeIfNull: false)
  DateTime? get dontSendBeforeDateUtc;
  @override
  @JsonKey(name: 'SentTries', includeIfNull: false)
  int? get sentTries;
  @override
  @JsonKey(name: 'SentOnUtc', includeIfNull: false)
  DateTime? get sentOnUtc;
  @override
  @JsonKey(name: 'ReadOnUtc', includeIfNull: false)
  DateTime? get readOnUtc;
  @override
  @JsonKey(name: 'EmailAccountId', includeIfNull: false)
  String? get emailAccountId;
  @override
  @JsonKey(name: 'Reference', includeIfNull: false)
  Reference? get reference;
  @override
  @JsonKey(name: 'ObjectId', includeIfNull: false)
  String? get objectId;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;
  @override
  @JsonKey(name: 'CreatedOnUtc', includeIfNull: false)
  DateTime? get createdOnUtc;
  @override
  @JsonKey(name: 'CreatedBy', includeIfNull: false)
  String? get createdBy;
  @override
  @JsonKey(name: 'UpdatedOnUtc', includeIfNull: false)
  DateTime? get updatedOnUtc;
  @override
  @JsonKey(name: 'UpdatedBy', includeIfNull: false)
  String? get updatedBy;
  @override
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id;

  /// Create a copy of QueuedEmail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QueuedEmailImplCopyWith<_$QueuedEmailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
