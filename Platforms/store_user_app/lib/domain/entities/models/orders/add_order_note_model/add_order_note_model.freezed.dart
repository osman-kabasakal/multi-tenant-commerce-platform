// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'add_order_note_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AddOrderNoteModel _$AddOrderNoteModelFromJson(Map<String, dynamic> json) {
  return _AddOrderNoteModel.fromJson(json);
}

/// @nodoc
mixin _$AddOrderNoteModel {
  @JsonKey(name: 'OrderId', includeIfNull: false)
  String? get orderId => throw _privateConstructorUsedError;
  @JsonKey(name: 'Note', includeIfNull: false)
  String? get note => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this AddOrderNoteModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AddOrderNoteModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AddOrderNoteModelCopyWith<AddOrderNoteModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddOrderNoteModelCopyWith<$Res> {
  factory $AddOrderNoteModelCopyWith(
    AddOrderNoteModel value,
    $Res Function(AddOrderNoteModel) then,
  ) = _$AddOrderNoteModelCopyWithImpl<$Res, AddOrderNoteModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'OrderId', includeIfNull: false) String? orderId,
    @JsonKey(name: 'Note', includeIfNull: false) String? note,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$AddOrderNoteModelCopyWithImpl<$Res, $Val extends AddOrderNoteModel>
    implements $AddOrderNoteModelCopyWith<$Res> {
  _$AddOrderNoteModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AddOrderNoteModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderId = freezed,
    Object? note = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            orderId:
                freezed == orderId
                    ? _value.orderId
                    : orderId // ignore: cast_nullable_to_non_nullable
                        as String?,
            note:
                freezed == note
                    ? _value.note
                    : note // ignore: cast_nullable_to_non_nullable
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
abstract class _$$AddOrderNoteModelImplCopyWith<$Res>
    implements $AddOrderNoteModelCopyWith<$Res> {
  factory _$$AddOrderNoteModelImplCopyWith(
    _$AddOrderNoteModelImpl value,
    $Res Function(_$AddOrderNoteModelImpl) then,
  ) = __$$AddOrderNoteModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'OrderId', includeIfNull: false) String? orderId,
    @JsonKey(name: 'Note', includeIfNull: false) String? note,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$AddOrderNoteModelImplCopyWithImpl<$Res>
    extends _$AddOrderNoteModelCopyWithImpl<$Res, _$AddOrderNoteModelImpl>
    implements _$$AddOrderNoteModelImplCopyWith<$Res> {
  __$$AddOrderNoteModelImplCopyWithImpl(
    _$AddOrderNoteModelImpl _value,
    $Res Function(_$AddOrderNoteModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AddOrderNoteModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderId = freezed,
    Object? note = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$AddOrderNoteModelImpl(
        orderId:
            freezed == orderId
                ? _value.orderId
                : orderId // ignore: cast_nullable_to_non_nullable
                    as String?,
        note:
            freezed == note
                ? _value.note
                : note // ignore: cast_nullable_to_non_nullable
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
class _$AddOrderNoteModelImpl implements _AddOrderNoteModel {
  _$AddOrderNoteModelImpl({
    @JsonKey(name: 'OrderId', includeIfNull: false) this.orderId,
    @JsonKey(name: 'Note', includeIfNull: false) this.note,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _userFields = userFields;

  factory _$AddOrderNoteModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AddOrderNoteModelImplFromJson(json);

  @override
  @JsonKey(name: 'OrderId', includeIfNull: false)
  final String? orderId;
  @override
  @JsonKey(name: 'Note', includeIfNull: false)
  final String? note;
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
    return 'AddOrderNoteModel(orderId: $orderId, note: $note, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddOrderNoteModelImpl &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.note, note) || other.note == note) &&
            const DeepCollectionEquality().equals(
              other._userFields,
              _userFields,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    orderId,
    note,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of AddOrderNoteModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AddOrderNoteModelImplCopyWith<_$AddOrderNoteModelImpl> get copyWith =>
      __$$AddOrderNoteModelImplCopyWithImpl<_$AddOrderNoteModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AddOrderNoteModelImplToJson(this);
  }
}

abstract class _AddOrderNoteModel implements AddOrderNoteModel {
  factory _AddOrderNoteModel({
    @JsonKey(name: 'OrderId', includeIfNull: false) final String? orderId,
    @JsonKey(name: 'Note', includeIfNull: false) final String? note,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$AddOrderNoteModelImpl;

  factory _AddOrderNoteModel.fromJson(Map<String, dynamic> json) =
      _$AddOrderNoteModelImpl.fromJson;

  @override
  @JsonKey(name: 'OrderId', includeIfNull: false)
  String? get orderId;
  @override
  @JsonKey(name: 'Note', includeIfNull: false)
  String? get note;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of AddOrderNoteModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AddOrderNoteModelImplCopyWith<_$AddOrderNoteModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
