// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'specification_filter_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SpecificationFilterModel _$SpecificationFilterModelFromJson(
  Map<String, dynamic> json,
) {
  return _SpecificationFilterModel.fromJson(json);
}

/// @nodoc
mixin _$SpecificationFilterModel {
  @JsonKey(name: 'Enabled', includeIfNull: false)
  bool? get enabled => throw _privateConstructorUsedError;
  @JsonKey(name: 'AlreadyFilteredItems', includeIfNull: false)
  List<SpecificationFilterItem>? get alreadyFilteredItems =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'NotFilteredItems', includeIfNull: false)
  List<SpecificationFilterItem>? get notFilteredItems =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'RemoveFilterUrl', includeIfNull: false)
  String? get removeFilterUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this SpecificationFilterModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SpecificationFilterModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SpecificationFilterModelCopyWith<SpecificationFilterModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpecificationFilterModelCopyWith<$Res> {
  factory $SpecificationFilterModelCopyWith(
    SpecificationFilterModel value,
    $Res Function(SpecificationFilterModel) then,
  ) = _$SpecificationFilterModelCopyWithImpl<$Res, SpecificationFilterModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'Enabled', includeIfNull: false) bool? enabled,
    @JsonKey(name: 'AlreadyFilteredItems', includeIfNull: false)
    List<SpecificationFilterItem>? alreadyFilteredItems,
    @JsonKey(name: 'NotFilteredItems', includeIfNull: false)
    List<SpecificationFilterItem>? notFilteredItems,
    @JsonKey(name: 'RemoveFilterUrl', includeIfNull: false)
    String? removeFilterUrl,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$SpecificationFilterModelCopyWithImpl<
  $Res,
  $Val extends SpecificationFilterModel
>
    implements $SpecificationFilterModelCopyWith<$Res> {
  _$SpecificationFilterModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SpecificationFilterModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enabled = freezed,
    Object? alreadyFilteredItems = freezed,
    Object? notFilteredItems = freezed,
    Object? removeFilterUrl = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            enabled:
                freezed == enabled
                    ? _value.enabled
                    : enabled // ignore: cast_nullable_to_non_nullable
                        as bool?,
            alreadyFilteredItems:
                freezed == alreadyFilteredItems
                    ? _value.alreadyFilteredItems
                    : alreadyFilteredItems // ignore: cast_nullable_to_non_nullable
                        as List<SpecificationFilterItem>?,
            notFilteredItems:
                freezed == notFilteredItems
                    ? _value.notFilteredItems
                    : notFilteredItems // ignore: cast_nullable_to_non_nullable
                        as List<SpecificationFilterItem>?,
            removeFilterUrl:
                freezed == removeFilterUrl
                    ? _value.removeFilterUrl
                    : removeFilterUrl // ignore: cast_nullable_to_non_nullable
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
abstract class _$$SpecificationFilterModelImplCopyWith<$Res>
    implements $SpecificationFilterModelCopyWith<$Res> {
  factory _$$SpecificationFilterModelImplCopyWith(
    _$SpecificationFilterModelImpl value,
    $Res Function(_$SpecificationFilterModelImpl) then,
  ) = __$$SpecificationFilterModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'Enabled', includeIfNull: false) bool? enabled,
    @JsonKey(name: 'AlreadyFilteredItems', includeIfNull: false)
    List<SpecificationFilterItem>? alreadyFilteredItems,
    @JsonKey(name: 'NotFilteredItems', includeIfNull: false)
    List<SpecificationFilterItem>? notFilteredItems,
    @JsonKey(name: 'RemoveFilterUrl', includeIfNull: false)
    String? removeFilterUrl,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$SpecificationFilterModelImplCopyWithImpl<$Res>
    extends
        _$SpecificationFilterModelCopyWithImpl<
          $Res,
          _$SpecificationFilterModelImpl
        >
    implements _$$SpecificationFilterModelImplCopyWith<$Res> {
  __$$SpecificationFilterModelImplCopyWithImpl(
    _$SpecificationFilterModelImpl _value,
    $Res Function(_$SpecificationFilterModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SpecificationFilterModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enabled = freezed,
    Object? alreadyFilteredItems = freezed,
    Object? notFilteredItems = freezed,
    Object? removeFilterUrl = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$SpecificationFilterModelImpl(
        enabled:
            freezed == enabled
                ? _value.enabled
                : enabled // ignore: cast_nullable_to_non_nullable
                    as bool?,
        alreadyFilteredItems:
            freezed == alreadyFilteredItems
                ? _value._alreadyFilteredItems
                : alreadyFilteredItems // ignore: cast_nullable_to_non_nullable
                    as List<SpecificationFilterItem>?,
        notFilteredItems:
            freezed == notFilteredItems
                ? _value._notFilteredItems
                : notFilteredItems // ignore: cast_nullable_to_non_nullable
                    as List<SpecificationFilterItem>?,
        removeFilterUrl:
            freezed == removeFilterUrl
                ? _value.removeFilterUrl
                : removeFilterUrl // ignore: cast_nullable_to_non_nullable
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
class _$SpecificationFilterModelImpl implements _SpecificationFilterModel {
  _$SpecificationFilterModelImpl({
    @JsonKey(name: 'Enabled', includeIfNull: false) this.enabled = false,
    @JsonKey(name: 'AlreadyFilteredItems', includeIfNull: false)
    final List<SpecificationFilterItem>? alreadyFilteredItems = const [],
    @JsonKey(name: 'NotFilteredItems', includeIfNull: false)
    final List<SpecificationFilterItem>? notFilteredItems = const [],
    @JsonKey(name: 'RemoveFilterUrl', includeIfNull: false)
    this.removeFilterUrl,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _alreadyFilteredItems = alreadyFilteredItems,
       _notFilteredItems = notFilteredItems,
       _userFields = userFields;

  factory _$SpecificationFilterModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SpecificationFilterModelImplFromJson(json);

  @override
  @JsonKey(name: 'Enabled', includeIfNull: false)
  final bool? enabled;
  final List<SpecificationFilterItem>? _alreadyFilteredItems;
  @override
  @JsonKey(name: 'AlreadyFilteredItems', includeIfNull: false)
  List<SpecificationFilterItem>? get alreadyFilteredItems {
    final value = _alreadyFilteredItems;
    if (value == null) return null;
    if (_alreadyFilteredItems is EqualUnmodifiableListView)
      return _alreadyFilteredItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<SpecificationFilterItem>? _notFilteredItems;
  @override
  @JsonKey(name: 'NotFilteredItems', includeIfNull: false)
  List<SpecificationFilterItem>? get notFilteredItems {
    final value = _notFilteredItems;
    if (value == null) return null;
    if (_notFilteredItems is EqualUnmodifiableListView)
      return _notFilteredItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'RemoveFilterUrl', includeIfNull: false)
  final String? removeFilterUrl;
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
    return 'SpecificationFilterModel(enabled: $enabled, alreadyFilteredItems: $alreadyFilteredItems, notFilteredItems: $notFilteredItems, removeFilterUrl: $removeFilterUrl, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpecificationFilterModelImpl &&
            (identical(other.enabled, enabled) || other.enabled == enabled) &&
            const DeepCollectionEquality().equals(
              other._alreadyFilteredItems,
              _alreadyFilteredItems,
            ) &&
            const DeepCollectionEquality().equals(
              other._notFilteredItems,
              _notFilteredItems,
            ) &&
            (identical(other.removeFilterUrl, removeFilterUrl) ||
                other.removeFilterUrl == removeFilterUrl) &&
            const DeepCollectionEquality().equals(
              other._userFields,
              _userFields,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    enabled,
    const DeepCollectionEquality().hash(_alreadyFilteredItems),
    const DeepCollectionEquality().hash(_notFilteredItems),
    removeFilterUrl,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of SpecificationFilterModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SpecificationFilterModelImplCopyWith<_$SpecificationFilterModelImpl>
  get copyWith => __$$SpecificationFilterModelImplCopyWithImpl<
    _$SpecificationFilterModelImpl
  >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SpecificationFilterModelImplToJson(this);
  }
}

abstract class _SpecificationFilterModel implements SpecificationFilterModel {
  factory _SpecificationFilterModel({
    @JsonKey(name: 'Enabled', includeIfNull: false) final bool? enabled,
    @JsonKey(name: 'AlreadyFilteredItems', includeIfNull: false)
    final List<SpecificationFilterItem>? alreadyFilteredItems,
    @JsonKey(name: 'NotFilteredItems', includeIfNull: false)
    final List<SpecificationFilterItem>? notFilteredItems,
    @JsonKey(name: 'RemoveFilterUrl', includeIfNull: false)
    final String? removeFilterUrl,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$SpecificationFilterModelImpl;

  factory _SpecificationFilterModel.fromJson(Map<String, dynamic> json) =
      _$SpecificationFilterModelImpl.fromJson;

  @override
  @JsonKey(name: 'Enabled', includeIfNull: false)
  bool? get enabled;
  @override
  @JsonKey(name: 'AlreadyFilteredItems', includeIfNull: false)
  List<SpecificationFilterItem>? get alreadyFilteredItems;
  @override
  @JsonKey(name: 'NotFilteredItems', includeIfNull: false)
  List<SpecificationFilterItem>? get notFilteredItems;
  @override
  @JsonKey(name: 'RemoveFilterUrl', includeIfNull: false)
  String? get removeFilterUrl;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of SpecificationFilterModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SpecificationFilterModelImplCopyWith<_$SpecificationFilterModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
