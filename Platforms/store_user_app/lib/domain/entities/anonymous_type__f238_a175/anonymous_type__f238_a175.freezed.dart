// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'anonymous_type__f238_a175.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AnonymousType_F238A175 _$AnonymousType_F238A175FromJson(
  Map<String, dynamic> json,
) {
  return _AnonymousType_F238A175.fromJson(json);
}

/// @nodoc
mixin _$AnonymousType_F238A175 {
  @JsonKey(name: 'update_section', includeIfNull: false)
  UpdateSectionJsonModel? get update_section =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'goto_section')
  String? get goToSection => throw _privateConstructorUsedError;
  @JsonKey(name: 'wrong_shipping_address', includeIfNull: false)
  bool? get wrong_shipping_address => throw _privateConstructorUsedError;
  @JsonKey(name: 'model_state', includeIfNull: false)
  List<String> get model_state => throw _privateConstructorUsedError;
  @JsonKey(name: 'error')
  int? get error => throw _privateConstructorUsedError;
  @JsonKey(name: 'message')
  String? get message => throw _privateConstructorUsedError;

  /// Serializes this AnonymousType_F238A175 to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AnonymousType_F238A175
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnonymousType_F238A175CopyWith<AnonymousType_F238A175> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnonymousType_F238A175CopyWith<$Res> {
  factory $AnonymousType_F238A175CopyWith(
    AnonymousType_F238A175 value,
    $Res Function(AnonymousType_F238A175) then,
  ) = _$AnonymousType_F238A175CopyWithImpl<$Res, AnonymousType_F238A175>;
  @useResult
  $Res call({
    @JsonKey(name: 'update_section', includeIfNull: false)
    UpdateSectionJsonModel? update_section,
    @JsonKey(name: 'goto_section') String? goToSection,
    @JsonKey(name: 'wrong_shipping_address', includeIfNull: false)
    bool? wrong_shipping_address,
    @JsonKey(name: 'model_state', includeIfNull: false)
    List<String> model_state,
    @JsonKey(name: 'error') int? error,
    @JsonKey(name: 'message') String? message,
  });

  $UpdateSectionJsonModelCopyWith<$Res>? get update_section;
}

/// @nodoc
class _$AnonymousType_F238A175CopyWithImpl<
  $Res,
  $Val extends AnonymousType_F238A175
>
    implements $AnonymousType_F238A175CopyWith<$Res> {
  _$AnonymousType_F238A175CopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AnonymousType_F238A175
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? update_section = freezed,
    Object? goToSection = freezed,
    Object? wrong_shipping_address = freezed,
    Object? model_state = null,
    Object? error = freezed,
    Object? message = freezed,
  }) {
    return _then(
      _value.copyWith(
            update_section:
                freezed == update_section
                    ? _value.update_section
                    : update_section // ignore: cast_nullable_to_non_nullable
                        as UpdateSectionJsonModel?,
            goToSection:
                freezed == goToSection
                    ? _value.goToSection
                    : goToSection // ignore: cast_nullable_to_non_nullable
                        as String?,
            wrong_shipping_address:
                freezed == wrong_shipping_address
                    ? _value.wrong_shipping_address
                    : wrong_shipping_address // ignore: cast_nullable_to_non_nullable
                        as bool?,
            model_state:
                null == model_state
                    ? _value.model_state
                    : model_state // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            error:
                freezed == error
                    ? _value.error
                    : error // ignore: cast_nullable_to_non_nullable
                        as int?,
            message:
                freezed == message
                    ? _value.message
                    : message // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of AnonymousType_F238A175
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UpdateSectionJsonModelCopyWith<$Res>? get update_section {
    if (_value.update_section == null) {
      return null;
    }

    return $UpdateSectionJsonModelCopyWith<$Res>(_value.update_section!, (
      value,
    ) {
      return _then(_value.copyWith(update_section: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AnonymousType_F238A175ImplCopyWith<$Res>
    implements $AnonymousType_F238A175CopyWith<$Res> {
  factory _$$AnonymousType_F238A175ImplCopyWith(
    _$AnonymousType_F238A175Impl value,
    $Res Function(_$AnonymousType_F238A175Impl) then,
  ) = __$$AnonymousType_F238A175ImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'update_section', includeIfNull: false)
    UpdateSectionJsonModel? update_section,
    @JsonKey(name: 'goto_section') String? goToSection,
    @JsonKey(name: 'wrong_shipping_address', includeIfNull: false)
    bool? wrong_shipping_address,
    @JsonKey(name: 'model_state', includeIfNull: false)
    List<String> model_state,
    @JsonKey(name: 'error') int? error,
    @JsonKey(name: 'message') String? message,
  });

  @override
  $UpdateSectionJsonModelCopyWith<$Res>? get update_section;
}

/// @nodoc
class __$$AnonymousType_F238A175ImplCopyWithImpl<$Res>
    extends
        _$AnonymousType_F238A175CopyWithImpl<$Res, _$AnonymousType_F238A175Impl>
    implements _$$AnonymousType_F238A175ImplCopyWith<$Res> {
  __$$AnonymousType_F238A175ImplCopyWithImpl(
    _$AnonymousType_F238A175Impl _value,
    $Res Function(_$AnonymousType_F238A175Impl) _then,
  ) : super(_value, _then);

  /// Create a copy of AnonymousType_F238A175
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? update_section = freezed,
    Object? goToSection = freezed,
    Object? wrong_shipping_address = freezed,
    Object? model_state = null,
    Object? error = freezed,
    Object? message = freezed,
  }) {
    return _then(
      _$AnonymousType_F238A175Impl(
        update_section:
            freezed == update_section
                ? _value.update_section
                : update_section // ignore: cast_nullable_to_non_nullable
                    as UpdateSectionJsonModel?,
        goToSection:
            freezed == goToSection
                ? _value.goToSection
                : goToSection // ignore: cast_nullable_to_non_nullable
                    as String?,
        wrong_shipping_address:
            freezed == wrong_shipping_address
                ? _value.wrong_shipping_address
                : wrong_shipping_address // ignore: cast_nullable_to_non_nullable
                    as bool?,
        model_state:
            null == model_state
                ? _value._model_state
                : model_state // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        error:
            freezed == error
                ? _value.error
                : error // ignore: cast_nullable_to_non_nullable
                    as int?,
        message:
            freezed == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AnonymousType_F238A175Impl implements _AnonymousType_F238A175 {
  _$AnonymousType_F238A175Impl({
    @JsonKey(name: 'update_section', includeIfNull: false) this.update_section,
    @JsonKey(name: 'goto_section') this.goToSection,
    @JsonKey(name: 'wrong_shipping_address', includeIfNull: false)
    this.wrong_shipping_address = false,
    @JsonKey(name: 'model_state', includeIfNull: false)
    final List<String> model_state = const [],
    @JsonKey(name: 'error') this.error,
    @JsonKey(name: 'message') this.message,
  }) : _model_state = model_state;

  factory _$AnonymousType_F238A175Impl.fromJson(Map<String, dynamic> json) =>
      _$$AnonymousType_F238A175ImplFromJson(json);

  @override
  @JsonKey(name: 'update_section', includeIfNull: false)
  final UpdateSectionJsonModel? update_section;
  @override
  @JsonKey(name: 'goto_section')
  final String? goToSection;
  @override
  @JsonKey(name: 'wrong_shipping_address', includeIfNull: false)
  final bool? wrong_shipping_address;
  final List<String> _model_state;
  @override
  @JsonKey(name: 'model_state', includeIfNull: false)
  List<String> get model_state {
    if (_model_state is EqualUnmodifiableListView) return _model_state;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_model_state);
  }

  @override
  @JsonKey(name: 'error')
  final int? error;
  @override
  @JsonKey(name: 'message')
  final String? message;

  @override
  String toString() {
    return 'AnonymousType_F238A175(update_section: $update_section, goToSection: $goToSection, wrong_shipping_address: $wrong_shipping_address, model_state: $model_state, error: $error, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnonymousType_F238A175Impl &&
            (identical(other.update_section, update_section) ||
                other.update_section == update_section) &&
            (identical(other.goToSection, goToSection) ||
                other.goToSection == goToSection) &&
            (identical(other.wrong_shipping_address, wrong_shipping_address) ||
                other.wrong_shipping_address == wrong_shipping_address) &&
            const DeepCollectionEquality().equals(
              other._model_state,
              _model_state,
            ) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    update_section,
    goToSection,
    wrong_shipping_address,
    const DeepCollectionEquality().hash(_model_state),
    error,
    message,
  );

  /// Create a copy of AnonymousType_F238A175
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnonymousType_F238A175ImplCopyWith<_$AnonymousType_F238A175Impl>
  get copyWith =>
      __$$AnonymousType_F238A175ImplCopyWithImpl<_$AnonymousType_F238A175Impl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AnonymousType_F238A175ImplToJson(this);
  }
}

abstract class _AnonymousType_F238A175 implements AnonymousType_F238A175 {
  factory _AnonymousType_F238A175({
    @JsonKey(name: 'update_section', includeIfNull: false)
    final UpdateSectionJsonModel? update_section,
    @JsonKey(name: 'goto_section') final String? goToSection,
    @JsonKey(name: 'wrong_shipping_address', includeIfNull: false)
    final bool? wrong_shipping_address,
    @JsonKey(name: 'model_state', includeIfNull: false)
    final List<String> model_state,
    @JsonKey(name: 'error') final int? error,
    @JsonKey(name: 'message') final String? message,
  }) = _$AnonymousType_F238A175Impl;

  factory _AnonymousType_F238A175.fromJson(Map<String, dynamic> json) =
      _$AnonymousType_F238A175Impl.fromJson;

  @override
  @JsonKey(name: 'update_section', includeIfNull: false)
  UpdateSectionJsonModel? get update_section;
  @override
  @JsonKey(name: 'goto_section')
  String? get goToSection;
  @override
  @JsonKey(name: 'wrong_shipping_address', includeIfNull: false)
  bool? get wrong_shipping_address;
  @override
  @JsonKey(name: 'model_state', includeIfNull: false)
  List<String> get model_state;
  @override
  @JsonKey(name: 'error')
  int? get error;
  @override
  @JsonKey(name: 'message')
  String? get message;

  /// Create a copy of AnonymousType_F238A175
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnonymousType_F238A175ImplCopyWith<_$AnonymousType_F238A175Impl>
  get copyWith => throw _privateConstructorUsedError;
}
