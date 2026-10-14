// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_note.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

OrderNote _$OrderNoteFromJson(Map<String, dynamic> json) {
  return _OrderNote.fromJson(json);
}

/// @nodoc
mixin _$OrderNote {
  @JsonKey(name: 'HasDownload', includeIfNull: false)
  bool? get hasDownload => throw _privateConstructorUsedError;
  @JsonKey(name: 'Note', includeIfNull: false)
  String? get note => throw _privateConstructorUsedError;
  @JsonKey(name: 'CreatedOn', includeIfNull: false)
  DateTime? get createdOn => throw _privateConstructorUsedError;
  @JsonKey(name: 'OrderId', includeIfNull: false)
  String? get orderId => throw _privateConstructorUsedError;
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this OrderNote to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderNote
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderNoteCopyWith<OrderNote> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderNoteCopyWith<$Res> {
  factory $OrderNoteCopyWith(OrderNote value, $Res Function(OrderNote) then) =
      _$OrderNoteCopyWithImpl<$Res, OrderNote>;
  @useResult
  $Res call({
    @JsonKey(name: 'HasDownload', includeIfNull: false) bool? hasDownload,
    @JsonKey(name: 'Note', includeIfNull: false) String? note,
    @JsonKey(name: 'CreatedOn', includeIfNull: false) DateTime? createdOn,
    @JsonKey(name: 'OrderId', includeIfNull: false) String? orderId,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$OrderNoteCopyWithImpl<$Res, $Val extends OrderNote>
    implements $OrderNoteCopyWith<$Res> {
  _$OrderNoteCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderNote
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hasDownload = freezed,
    Object? note = freezed,
    Object? createdOn = freezed,
    Object? orderId = freezed,
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
            orderId:
                freezed == orderId
                    ? _value.orderId
                    : orderId // ignore: cast_nullable_to_non_nullable
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
abstract class _$$OrderNoteImplCopyWith<$Res>
    implements $OrderNoteCopyWith<$Res> {
  factory _$$OrderNoteImplCopyWith(
    _$OrderNoteImpl value,
    $Res Function(_$OrderNoteImpl) then,
  ) = __$$OrderNoteImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'HasDownload', includeIfNull: false) bool? hasDownload,
    @JsonKey(name: 'Note', includeIfNull: false) String? note,
    @JsonKey(name: 'CreatedOn', includeIfNull: false) DateTime? createdOn,
    @JsonKey(name: 'OrderId', includeIfNull: false) String? orderId,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$OrderNoteImplCopyWithImpl<$Res>
    extends _$OrderNoteCopyWithImpl<$Res, _$OrderNoteImpl>
    implements _$$OrderNoteImplCopyWith<$Res> {
  __$$OrderNoteImplCopyWithImpl(
    _$OrderNoteImpl _value,
    $Res Function(_$OrderNoteImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderNote
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hasDownload = freezed,
    Object? note = freezed,
    Object? createdOn = freezed,
    Object? orderId = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$OrderNoteImpl(
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
        orderId:
            freezed == orderId
                ? _value.orderId
                : orderId // ignore: cast_nullable_to_non_nullable
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
class _$OrderNoteImpl implements _OrderNote {
  _$OrderNoteImpl({
    @JsonKey(name: 'HasDownload', includeIfNull: false)
    this.hasDownload = false,
    @JsonKey(name: 'Note', includeIfNull: false) this.note,
    @JsonKey(name: 'CreatedOn', includeIfNull: false) this.createdOn,
    @JsonKey(name: 'OrderId', includeIfNull: false) this.orderId,
    @JsonKey(name: 'Id', includeIfNull: false) this.id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _userFields = userFields;

  factory _$OrderNoteImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderNoteImplFromJson(json);

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
  @JsonKey(name: 'OrderId', includeIfNull: false)
  final String? orderId;
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
    return 'OrderNote(hasDownload: $hasDownload, note: $note, createdOn: $createdOn, orderId: $orderId, id: $id, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderNoteImpl &&
            (identical(other.hasDownload, hasDownload) ||
                other.hasDownload == hasDownload) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.createdOn, createdOn) ||
                other.createdOn == createdOn) &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
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
    orderId,
    id,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of OrderNote
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderNoteImplCopyWith<_$OrderNoteImpl> get copyWith =>
      __$$OrderNoteImplCopyWithImpl<_$OrderNoteImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderNoteImplToJson(this);
  }
}

abstract class _OrderNote implements OrderNote {
  factory _OrderNote({
    @JsonKey(name: 'HasDownload', includeIfNull: false) final bool? hasDownload,
    @JsonKey(name: 'Note', includeIfNull: false) final String? note,
    @JsonKey(name: 'CreatedOn', includeIfNull: false) final DateTime? createdOn,
    @JsonKey(name: 'OrderId', includeIfNull: false) final String? orderId,
    @JsonKey(name: 'Id', includeIfNull: false) final String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$OrderNoteImpl;

  factory _OrderNote.fromJson(Map<String, dynamic> json) =
      _$OrderNoteImpl.fromJson;

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
  @JsonKey(name: 'OrderId', includeIfNull: false)
  String? get orderId;
  @override
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of OrderNote
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderNoteImplCopyWith<_$OrderNoteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
