// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer_note.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CustomerNote _$CustomerNoteFromJson(Map<String, dynamic> json) {
  return _CustomerNote.fromJson(json);
}

/// @nodoc
mixin _$CustomerNote {
  @JsonKey(name: 'NoteId', includeIfNull: false)
  String? get noteId => throw _privateConstructorUsedError;
  @JsonKey(name: 'DownloadId', includeIfNull: false)
  String? get downloadId => throw _privateConstructorUsedError;
  @JsonKey(name: 'Title', includeIfNull: false)
  String? get title => throw _privateConstructorUsedError;
  @JsonKey(name: 'Note', includeIfNull: false)
  String? get note => throw _privateConstructorUsedError;
  @JsonKey(name: 'CreatedOn', includeIfNull: false)
  DateTime? get createdOn => throw _privateConstructorUsedError;

  /// Serializes this CustomerNote to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CustomerNote
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CustomerNoteCopyWith<CustomerNote> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomerNoteCopyWith<$Res> {
  factory $CustomerNoteCopyWith(
    CustomerNote value,
    $Res Function(CustomerNote) then,
  ) = _$CustomerNoteCopyWithImpl<$Res, CustomerNote>;
  @useResult
  $Res call({
    @JsonKey(name: 'NoteId', includeIfNull: false) String? noteId,
    @JsonKey(name: 'DownloadId', includeIfNull: false) String? downloadId,
    @JsonKey(name: 'Title', includeIfNull: false) String? title,
    @JsonKey(name: 'Note', includeIfNull: false) String? note,
    @JsonKey(name: 'CreatedOn', includeIfNull: false) DateTime? createdOn,
  });
}

/// @nodoc
class _$CustomerNoteCopyWithImpl<$Res, $Val extends CustomerNote>
    implements $CustomerNoteCopyWith<$Res> {
  _$CustomerNoteCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CustomerNote
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? noteId = freezed,
    Object? downloadId = freezed,
    Object? title = freezed,
    Object? note = freezed,
    Object? createdOn = freezed,
  }) {
    return _then(
      _value.copyWith(
            noteId:
                freezed == noteId
                    ? _value.noteId
                    : noteId // ignore: cast_nullable_to_non_nullable
                        as String?,
            downloadId:
                freezed == downloadId
                    ? _value.downloadId
                    : downloadId // ignore: cast_nullable_to_non_nullable
                        as String?,
            title:
                freezed == title
                    ? _value.title
                    : title // ignore: cast_nullable_to_non_nullable
                        as String?,
            note:
                freezed == note
                    ? _value.note
                    : note // ignore: cast_nullable_to_non_nullable
                        as String?,
            createdOn:
                freezed == createdOn
                    ? _value.createdOn
                    : createdOn // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CustomerNoteImplCopyWith<$Res>
    implements $CustomerNoteCopyWith<$Res> {
  factory _$$CustomerNoteImplCopyWith(
    _$CustomerNoteImpl value,
    $Res Function(_$CustomerNoteImpl) then,
  ) = __$$CustomerNoteImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'NoteId', includeIfNull: false) String? noteId,
    @JsonKey(name: 'DownloadId', includeIfNull: false) String? downloadId,
    @JsonKey(name: 'Title', includeIfNull: false) String? title,
    @JsonKey(name: 'Note', includeIfNull: false) String? note,
    @JsonKey(name: 'CreatedOn', includeIfNull: false) DateTime? createdOn,
  });
}

/// @nodoc
class __$$CustomerNoteImplCopyWithImpl<$Res>
    extends _$CustomerNoteCopyWithImpl<$Res, _$CustomerNoteImpl>
    implements _$$CustomerNoteImplCopyWith<$Res> {
  __$$CustomerNoteImplCopyWithImpl(
    _$CustomerNoteImpl _value,
    $Res Function(_$CustomerNoteImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CustomerNote
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? noteId = freezed,
    Object? downloadId = freezed,
    Object? title = freezed,
    Object? note = freezed,
    Object? createdOn = freezed,
  }) {
    return _then(
      _$CustomerNoteImpl(
        noteId:
            freezed == noteId
                ? _value.noteId
                : noteId // ignore: cast_nullable_to_non_nullable
                    as String?,
        downloadId:
            freezed == downloadId
                ? _value.downloadId
                : downloadId // ignore: cast_nullable_to_non_nullable
                    as String?,
        title:
            freezed == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                    as String?,
        note:
            freezed == note
                ? _value.note
                : note // ignore: cast_nullable_to_non_nullable
                    as String?,
        createdOn:
            freezed == createdOn
                ? _value.createdOn
                : createdOn // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CustomerNoteImpl implements _CustomerNote {
  _$CustomerNoteImpl({
    @JsonKey(name: 'NoteId', includeIfNull: false) this.noteId,
    @JsonKey(name: 'DownloadId', includeIfNull: false) this.downloadId,
    @JsonKey(name: 'Title', includeIfNull: false) this.title,
    @JsonKey(name: 'Note', includeIfNull: false) this.note,
    @JsonKey(name: 'CreatedOn', includeIfNull: false) this.createdOn,
  });

  factory _$CustomerNoteImpl.fromJson(Map<String, dynamic> json) =>
      _$$CustomerNoteImplFromJson(json);

  @override
  @JsonKey(name: 'NoteId', includeIfNull: false)
  final String? noteId;
  @override
  @JsonKey(name: 'DownloadId', includeIfNull: false)
  final String? downloadId;
  @override
  @JsonKey(name: 'Title', includeIfNull: false)
  final String? title;
  @override
  @JsonKey(name: 'Note', includeIfNull: false)
  final String? note;
  @override
  @JsonKey(name: 'CreatedOn', includeIfNull: false)
  final DateTime? createdOn;

  @override
  String toString() {
    return 'CustomerNote(noteId: $noteId, downloadId: $downloadId, title: $title, note: $note, createdOn: $createdOn)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomerNoteImpl &&
            (identical(other.noteId, noteId) || other.noteId == noteId) &&
            (identical(other.downloadId, downloadId) ||
                other.downloadId == downloadId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.createdOn, createdOn) ||
                other.createdOn == createdOn));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, noteId, downloadId, title, note, createdOn);

  /// Create a copy of CustomerNote
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomerNoteImplCopyWith<_$CustomerNoteImpl> get copyWith =>
      __$$CustomerNoteImplCopyWithImpl<_$CustomerNoteImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CustomerNoteImplToJson(this);
  }
}

abstract class _CustomerNote implements CustomerNote {
  factory _CustomerNote({
    @JsonKey(name: 'NoteId', includeIfNull: false) final String? noteId,
    @JsonKey(name: 'DownloadId', includeIfNull: false) final String? downloadId,
    @JsonKey(name: 'Title', includeIfNull: false) final String? title,
    @JsonKey(name: 'Note', includeIfNull: false) final String? note,
    @JsonKey(name: 'CreatedOn', includeIfNull: false) final DateTime? createdOn,
  }) = _$CustomerNoteImpl;

  factory _CustomerNote.fromJson(Map<String, dynamic> json) =
      _$CustomerNoteImpl.fromJson;

  @override
  @JsonKey(name: 'NoteId', includeIfNull: false)
  String? get noteId;
  @override
  @JsonKey(name: 'DownloadId', includeIfNull: false)
  String? get downloadId;
  @override
  @JsonKey(name: 'Title', includeIfNull: false)
  String? get title;
  @override
  @JsonKey(name: 'Note', includeIfNull: false)
  String? get note;
  @override
  @JsonKey(name: 'CreatedOn', includeIfNull: false)
  DateTime? get createdOn;

  /// Create a copy of CustomerNote
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CustomerNoteImplCopyWith<_$CustomerNoteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
