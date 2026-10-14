// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shipment_note.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ShipmentNote _$ShipmentNoteFromJson(Map<String, dynamic> json) {
  return _ShipmentNote.fromJson(json);
}

/// @nodoc
mixin _$ShipmentNote {
  @JsonKey(name: 'HasDownload', includeIfNull: false)
  bool? get hasDownload => throw _privateConstructorUsedError;
  @JsonKey(name: 'Note', includeIfNull: false)
  String? get note => throw _privateConstructorUsedError;
  @JsonKey(name: 'CreatedOn', includeIfNull: false)
  DateTime? get createdOn => throw _privateConstructorUsedError;
  @JsonKey(name: 'ShipmentId', includeIfNull: false)
  String? get shipmentId => throw _privateConstructorUsedError;
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this ShipmentNote to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ShipmentNote
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShipmentNoteCopyWith<ShipmentNote> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShipmentNoteCopyWith<$Res> {
  factory $ShipmentNoteCopyWith(
    ShipmentNote value,
    $Res Function(ShipmentNote) then,
  ) = _$ShipmentNoteCopyWithImpl<$Res, ShipmentNote>;
  @useResult
  $Res call({
    @JsonKey(name: 'HasDownload', includeIfNull: false) bool? hasDownload,
    @JsonKey(name: 'Note', includeIfNull: false) String? note,
    @JsonKey(name: 'CreatedOn', includeIfNull: false) DateTime? createdOn,
    @JsonKey(name: 'ShipmentId', includeIfNull: false) String? shipmentId,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$ShipmentNoteCopyWithImpl<$Res, $Val extends ShipmentNote>
    implements $ShipmentNoteCopyWith<$Res> {
  _$ShipmentNoteCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShipmentNote
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hasDownload = freezed,
    Object? note = freezed,
    Object? createdOn = freezed,
    Object? shipmentId = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            hasDownload:
                freezed == hasDownload
                    ? _value.hasDownload
                    : hasDownload // ignore: cast_nullable_to_non_nullable
                        as bool?,
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
            shipmentId:
                freezed == shipmentId
                    ? _value.shipmentId
                    : shipmentId // ignore: cast_nullable_to_non_nullable
                        as String?,
            id:
                freezed == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String?,
            userFields:
                freezed == userFields
                    ? _value.userFields
                    : userFields // ignore: cast_nullable_to_non_nullable
                        as List<UserField>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ShipmentNoteImplCopyWith<$Res>
    implements $ShipmentNoteCopyWith<$Res> {
  factory _$$ShipmentNoteImplCopyWith(
    _$ShipmentNoteImpl value,
    $Res Function(_$ShipmentNoteImpl) then,
  ) = __$$ShipmentNoteImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'HasDownload', includeIfNull: false) bool? hasDownload,
    @JsonKey(name: 'Note', includeIfNull: false) String? note,
    @JsonKey(name: 'CreatedOn', includeIfNull: false) DateTime? createdOn,
    @JsonKey(name: 'ShipmentId', includeIfNull: false) String? shipmentId,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$ShipmentNoteImplCopyWithImpl<$Res>
    extends _$ShipmentNoteCopyWithImpl<$Res, _$ShipmentNoteImpl>
    implements _$$ShipmentNoteImplCopyWith<$Res> {
  __$$ShipmentNoteImplCopyWithImpl(
    _$ShipmentNoteImpl _value,
    $Res Function(_$ShipmentNoteImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ShipmentNote
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hasDownload = freezed,
    Object? note = freezed,
    Object? createdOn = freezed,
    Object? shipmentId = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$ShipmentNoteImpl(
        hasDownload:
            freezed == hasDownload
                ? _value.hasDownload
                : hasDownload // ignore: cast_nullable_to_non_nullable
                    as bool?,
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
        shipmentId:
            freezed == shipmentId
                ? _value.shipmentId
                : shipmentId // ignore: cast_nullable_to_non_nullable
                    as String?,
        id:
            freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String?,
        userFields:
            freezed == userFields
                ? _value._userFields
                : userFields // ignore: cast_nullable_to_non_nullable
                    as List<UserField>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ShipmentNoteImpl implements _ShipmentNote {
  _$ShipmentNoteImpl({
    @JsonKey(name: 'HasDownload', includeIfNull: false)
    this.hasDownload = false,
    @JsonKey(name: 'Note', includeIfNull: false) this.note,
    @JsonKey(name: 'CreatedOn', includeIfNull: false) this.createdOn,
    @JsonKey(name: 'ShipmentId', includeIfNull: false) this.shipmentId,
    @JsonKey(name: 'Id', includeIfNull: false) this.id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _userFields = userFields;

  factory _$ShipmentNoteImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShipmentNoteImplFromJson(json);

  @override
  @JsonKey(name: 'HasDownload', includeIfNull: false)
  final bool? hasDownload;
  @override
  @JsonKey(name: 'Note', includeIfNull: false)
  final String? note;
  @override
  @JsonKey(name: 'CreatedOn', includeIfNull: false)
  final DateTime? createdOn;
  @override
  @JsonKey(name: 'ShipmentId', includeIfNull: false)
  final String? shipmentId;
  @override
  @JsonKey(name: 'Id', includeIfNull: false)
  final String? id;
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
  String toString() {
    return 'ShipmentNote(hasDownload: $hasDownload, note: $note, createdOn: $createdOn, shipmentId: $shipmentId, id: $id, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShipmentNoteImpl &&
            (identical(other.hasDownload, hasDownload) ||
                other.hasDownload == hasDownload) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.createdOn, createdOn) ||
                other.createdOn == createdOn) &&
            (identical(other.shipmentId, shipmentId) ||
                other.shipmentId == shipmentId) &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality().equals(
              other._userFields,
              _userFields,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    hasDownload,
    note,
    createdOn,
    shipmentId,
    id,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of ShipmentNote
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShipmentNoteImplCopyWith<_$ShipmentNoteImpl> get copyWith =>
      __$$ShipmentNoteImplCopyWithImpl<_$ShipmentNoteImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ShipmentNoteImplToJson(this);
  }
}

abstract class _ShipmentNote implements ShipmentNote {
  factory _ShipmentNote({
    @JsonKey(name: 'HasDownload', includeIfNull: false) final bool? hasDownload,
    @JsonKey(name: 'Note', includeIfNull: false) final String? note,
    @JsonKey(name: 'CreatedOn', includeIfNull: false) final DateTime? createdOn,
    @JsonKey(name: 'ShipmentId', includeIfNull: false) final String? shipmentId,
    @JsonKey(name: 'Id', includeIfNull: false) final String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$ShipmentNoteImpl;

  factory _ShipmentNote.fromJson(Map<String, dynamic> json) =
      _$ShipmentNoteImpl.fromJson;

  @override
  @JsonKey(name: 'HasDownload', includeIfNull: false)
  bool? get hasDownload;
  @override
  @JsonKey(name: 'Note', includeIfNull: false)
  String? get note;
  @override
  @JsonKey(name: 'CreatedOn', includeIfNull: false)
  DateTime? get createdOn;
  @override
  @JsonKey(name: 'ShipmentId', includeIfNull: false)
  String? get shipmentId;
  @override
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of ShipmentNote
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShipmentNoteImplCopyWith<_$ShipmentNoteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
