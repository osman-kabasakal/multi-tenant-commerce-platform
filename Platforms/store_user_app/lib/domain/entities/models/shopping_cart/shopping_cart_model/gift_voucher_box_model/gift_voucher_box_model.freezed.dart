// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gift_voucher_box_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

GiftVoucherBoxModel _$GiftVoucherBoxModelFromJson(Map<String, dynamic> json) {
  return _GiftVoucherBoxModel.fromJson(json);
}

/// @nodoc
mixin _$GiftVoucherBoxModel {
  @JsonKey(name: 'Display', includeIfNull: false)
  bool? get display => throw _privateConstructorUsedError;
  @JsonKey(name: 'Message', includeIfNull: false)
  String? get message => throw _privateConstructorUsedError;
  @JsonKey(name: 'IsApplied', includeIfNull: false)
  bool? get isApplied => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this GiftVoucherBoxModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GiftVoucherBoxModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GiftVoucherBoxModelCopyWith<GiftVoucherBoxModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GiftVoucherBoxModelCopyWith<$Res> {
  factory $GiftVoucherBoxModelCopyWith(
    GiftVoucherBoxModel value,
    $Res Function(GiftVoucherBoxModel) then,
  ) = _$GiftVoucherBoxModelCopyWithImpl<$Res, GiftVoucherBoxModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'Display', includeIfNull: false) bool? display,
    @JsonKey(name: 'Message', includeIfNull: false) String? message,
    @JsonKey(name: 'IsApplied', includeIfNull: false) bool? isApplied,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$GiftVoucherBoxModelCopyWithImpl<$Res, $Val extends GiftVoucherBoxModel>
    implements $GiftVoucherBoxModelCopyWith<$Res> {
  _$GiftVoucherBoxModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GiftVoucherBoxModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? display = freezed,
    Object? message = freezed,
    Object? isApplied = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            display:
                freezed == display
                    ? _value.display
                    : display // ignore: cast_nullable_to_non_nullable
                        as bool?,
            message:
                freezed == message
                    ? _value.message
                    : message // ignore: cast_nullable_to_non_nullable
                        as String?,
            isApplied:
                freezed == isApplied
                    ? _value.isApplied
                    : isApplied // ignore: cast_nullable_to_non_nullable
                        as bool?,
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
abstract class _$$GiftVoucherBoxModelImplCopyWith<$Res>
    implements $GiftVoucherBoxModelCopyWith<$Res> {
  factory _$$GiftVoucherBoxModelImplCopyWith(
    _$GiftVoucherBoxModelImpl value,
    $Res Function(_$GiftVoucherBoxModelImpl) then,
  ) = __$$GiftVoucherBoxModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'Display', includeIfNull: false) bool? display,
    @JsonKey(name: 'Message', includeIfNull: false) String? message,
    @JsonKey(name: 'IsApplied', includeIfNull: false) bool? isApplied,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$GiftVoucherBoxModelImplCopyWithImpl<$Res>
    extends _$GiftVoucherBoxModelCopyWithImpl<$Res, _$GiftVoucherBoxModelImpl>
    implements _$$GiftVoucherBoxModelImplCopyWith<$Res> {
  __$$GiftVoucherBoxModelImplCopyWithImpl(
    _$GiftVoucherBoxModelImpl _value,
    $Res Function(_$GiftVoucherBoxModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GiftVoucherBoxModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? display = freezed,
    Object? message = freezed,
    Object? isApplied = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$GiftVoucherBoxModelImpl(
        display:
            freezed == display
                ? _value.display
                : display // ignore: cast_nullable_to_non_nullable
                    as bool?,
        message:
            freezed == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                    as String?,
        isApplied:
            freezed == isApplied
                ? _value.isApplied
                : isApplied // ignore: cast_nullable_to_non_nullable
                    as bool?,
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
class _$GiftVoucherBoxModelImpl implements _GiftVoucherBoxModel {
  _$GiftVoucherBoxModelImpl({
    @JsonKey(name: 'Display', includeIfNull: false) this.display = false,
    @JsonKey(name: 'Message', includeIfNull: false) this.message,
    @JsonKey(name: 'IsApplied', includeIfNull: false) this.isApplied = false,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _userFields = userFields;

  factory _$GiftVoucherBoxModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$GiftVoucherBoxModelImplFromJson(json);

  @override
  @JsonKey(name: 'Display', includeIfNull: false)
  final bool? display;
  @override
  @JsonKey(name: 'Message', includeIfNull: false)
  final String? message;
  @override
  @JsonKey(name: 'IsApplied', includeIfNull: false)
  final bool? isApplied;
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
    return 'GiftVoucherBoxModel(display: $display, message: $message, isApplied: $isApplied, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GiftVoucherBoxModelImpl &&
            (identical(other.display, display) || other.display == display) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.isApplied, isApplied) ||
                other.isApplied == isApplied) &&
            const DeepCollectionEquality().equals(
              other._userFields,
              _userFields,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    display,
    message,
    isApplied,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of GiftVoucherBoxModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GiftVoucherBoxModelImplCopyWith<_$GiftVoucherBoxModelImpl> get copyWith =>
      __$$GiftVoucherBoxModelImplCopyWithImpl<_$GiftVoucherBoxModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$GiftVoucherBoxModelImplToJson(this);
  }
}

abstract class _GiftVoucherBoxModel implements GiftVoucherBoxModel {
  factory _GiftVoucherBoxModel({
    @JsonKey(name: 'Display', includeIfNull: false) final bool? display,
    @JsonKey(name: 'Message', includeIfNull: false) final String? message,
    @JsonKey(name: 'IsApplied', includeIfNull: false) final bool? isApplied,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$GiftVoucherBoxModelImpl;

  factory _GiftVoucherBoxModel.fromJson(Map<String, dynamic> json) =
      _$GiftVoucherBoxModelImpl.fromJson;

  @override
  @JsonKey(name: 'Display', includeIfNull: false)
  bool? get display;
  @override
  @JsonKey(name: 'Message', includeIfNull: false)
  String? get message;
  @override
  @JsonKey(name: 'IsApplied', includeIfNull: false)
  bool? get isApplied;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of GiftVoucherBoxModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GiftVoucherBoxModelImplCopyWith<_$GiftVoucherBoxModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
