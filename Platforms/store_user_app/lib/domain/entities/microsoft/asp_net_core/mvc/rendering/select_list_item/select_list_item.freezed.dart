// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'select_list_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SelectListItem _$SelectListItemFromJson(Map<String, dynamic> json) {
  return _SelectListItem.fromJson(json);
}

/// @nodoc
mixin _$SelectListItem {
  @JsonKey(name: 'Disabled', includeIfNull: false)
  bool? get disabled => throw _privateConstructorUsedError;
  @JsonKey(name: 'Group', includeIfNull: false)
  SelectListGroup? get group => throw _privateConstructorUsedError;
  @JsonKey(name: 'Selected', includeIfNull: false)
  bool? get selected => throw _privateConstructorUsedError;
  @JsonKey(name: 'Text', includeIfNull: false)
  String? get text => throw _privateConstructorUsedError;
  @JsonKey(name: 'Value', includeIfNull: false)
  String? get value => throw _privateConstructorUsedError;

  /// Serializes this SelectListItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SelectListItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SelectListItemCopyWith<SelectListItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SelectListItemCopyWith<$Res> {
  factory $SelectListItemCopyWith(
    SelectListItem value,
    $Res Function(SelectListItem) then,
  ) = _$SelectListItemCopyWithImpl<$Res, SelectListItem>;
  @useResult
  $Res call({
    @JsonKey(name: 'Disabled', includeIfNull: false) bool? disabled,
    @JsonKey(name: 'Group', includeIfNull: false) SelectListGroup? group,
    @JsonKey(name: 'Selected', includeIfNull: false) bool? selected,
    @JsonKey(name: 'Text', includeIfNull: false) String? text,
    @JsonKey(name: 'Value', includeIfNull: false) String? value,
  });

  $SelectListGroupCopyWith<$Res>? get group;
}

/// @nodoc
class _$SelectListItemCopyWithImpl<$Res, $Val extends SelectListItem>
    implements $SelectListItemCopyWith<$Res> {
  _$SelectListItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SelectListItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? disabled = freezed,
    Object? group = freezed,
    Object? selected = freezed,
    Object? text = freezed,
    Object? value = freezed,
  }) {
    return _then(
      _value.copyWith(
            disabled:
                freezed == disabled
                    ? _value.disabled
                    : disabled // ignore: cast_nullable_to_non_nullable
                        as bool?,
            group:
                freezed == group
                    ? _value.group
                    : group // ignore: cast_nullable_to_non_nullable
                        as SelectListGroup?,
            selected:
                freezed == selected
                    ? _value.selected
                    : selected // ignore: cast_nullable_to_non_nullable
                        as bool?,
            text:
                freezed == text
                    ? _value.text
                    : text // ignore: cast_nullable_to_non_nullable
                        as String?,
            value:
                freezed == value
                    ? _value.value
                    : value // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of SelectListItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SelectListGroupCopyWith<$Res>? get group {
    if (_value.group == null) {
      return null;
    }

    return $SelectListGroupCopyWith<$Res>(_value.group!, (value) {
      return _then(_value.copyWith(group: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SelectListItemImplCopyWith<$Res>
    implements $SelectListItemCopyWith<$Res> {
  factory _$$SelectListItemImplCopyWith(
    _$SelectListItemImpl value,
    $Res Function(_$SelectListItemImpl) then,
  ) = __$$SelectListItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'Disabled', includeIfNull: false) bool? disabled,
    @JsonKey(name: 'Group', includeIfNull: false) SelectListGroup? group,
    @JsonKey(name: 'Selected', includeIfNull: false) bool? selected,
    @JsonKey(name: 'Text', includeIfNull: false) String? text,
    @JsonKey(name: 'Value', includeIfNull: false) String? value,
  });

  @override
  $SelectListGroupCopyWith<$Res>? get group;
}

/// @nodoc
class __$$SelectListItemImplCopyWithImpl<$Res>
    extends _$SelectListItemCopyWithImpl<$Res, _$SelectListItemImpl>
    implements _$$SelectListItemImplCopyWith<$Res> {
  __$$SelectListItemImplCopyWithImpl(
    _$SelectListItemImpl _value,
    $Res Function(_$SelectListItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SelectListItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? disabled = freezed,
    Object? group = freezed,
    Object? selected = freezed,
    Object? text = freezed,
    Object? value = freezed,
  }) {
    return _then(
      _$SelectListItemImpl(
        disabled:
            freezed == disabled
                ? _value.disabled
                : disabled // ignore: cast_nullable_to_non_nullable
                    as bool?,
        group:
            freezed == group
                ? _value.group
                : group // ignore: cast_nullable_to_non_nullable
                    as SelectListGroup?,
        selected:
            freezed == selected
                ? _value.selected
                : selected // ignore: cast_nullable_to_non_nullable
                    as bool?,
        text:
            freezed == text
                ? _value.text
                : text // ignore: cast_nullable_to_non_nullable
                    as String?,
        value:
            freezed == value
                ? _value.value
                : value // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SelectListItemImpl implements _SelectListItem {
  _$SelectListItemImpl({
    @JsonKey(name: 'Disabled', includeIfNull: false) this.disabled = false,
    @JsonKey(name: 'Group', includeIfNull: false) this.group,
    @JsonKey(name: 'Selected', includeIfNull: false) this.selected = false,
    @JsonKey(name: 'Text', includeIfNull: false) this.text,
    @JsonKey(name: 'Value', includeIfNull: false) this.value,
  });

  factory _$SelectListItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$SelectListItemImplFromJson(json);

  @override
  @JsonKey(name: 'Disabled', includeIfNull: false)
  final bool? disabled;
  @override
  @JsonKey(name: 'Group', includeIfNull: false)
  final SelectListGroup? group;
  @override
  @JsonKey(name: 'Selected', includeIfNull: false)
  final bool? selected;
  @override
  @JsonKey(name: 'Text', includeIfNull: false)
  final String? text;
  @override
  @JsonKey(name: 'Value', includeIfNull: false)
  final String? value;

  @override
  String toString() {
    return 'SelectListItem(disabled: $disabled, group: $group, selected: $selected, text: $text, value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SelectListItemImpl &&
            (identical(other.disabled, disabled) ||
                other.disabled == disabled) &&
            (identical(other.group, group) || other.group == group) &&
            (identical(other.selected, selected) ||
                other.selected == selected) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, disabled, group, selected, text, value);

  /// Create a copy of SelectListItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SelectListItemImplCopyWith<_$SelectListItemImpl> get copyWith =>
      __$$SelectListItemImplCopyWithImpl<_$SelectListItemImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SelectListItemImplToJson(this);
  }
}

abstract class _SelectListItem implements SelectListItem {
  factory _SelectListItem({
    @JsonKey(name: 'Disabled', includeIfNull: false) final bool? disabled,
    @JsonKey(name: 'Group', includeIfNull: false) final SelectListGroup? group,
    @JsonKey(name: 'Selected', includeIfNull: false) final bool? selected,
    @JsonKey(name: 'Text', includeIfNull: false) final String? text,
    @JsonKey(name: 'Value', includeIfNull: false) final String? value,
  }) = _$SelectListItemImpl;

  factory _SelectListItem.fromJson(Map<String, dynamic> json) =
      _$SelectListItemImpl.fromJson;

  @override
  @JsonKey(name: 'Disabled', includeIfNull: false)
  bool? get disabled;
  @override
  @JsonKey(name: 'Group', includeIfNull: false)
  SelectListGroup? get group;
  @override
  @JsonKey(name: 'Selected', includeIfNull: false)
  bool? get selected;
  @override
  @JsonKey(name: 'Text', includeIfNull: false)
  String? get text;
  @override
  @JsonKey(name: 'Value', includeIfNull: false)
  String? get value;

  /// Create a copy of SelectListItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SelectListItemImplCopyWith<_$SelectListItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
