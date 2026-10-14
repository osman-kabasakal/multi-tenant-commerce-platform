// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'newsletter_simple_category.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

NewsletterSimpleCategory _$NewsletterSimpleCategoryFromJson(
  Map<String, dynamic> json,
) {
  return _NewsletterSimpleCategory.fromJson(json);
}

/// @nodoc
mixin _$NewsletterSimpleCategory {
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'Name', includeIfNull: false)
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'Description', includeIfNull: false)
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'Selected', includeIfNull: false)
  bool? get selected => throw _privateConstructorUsedError;

  /// Serializes this NewsletterSimpleCategory to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NewsletterSimpleCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NewsletterSimpleCategoryCopyWith<NewsletterSimpleCategory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NewsletterSimpleCategoryCopyWith<$Res> {
  factory $NewsletterSimpleCategoryCopyWith(
    NewsletterSimpleCategory value,
    $Res Function(NewsletterSimpleCategory) then,
  ) = _$NewsletterSimpleCategoryCopyWithImpl<$Res, NewsletterSimpleCategory>;
  @useResult
  $Res call({
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'Name', includeIfNull: false) String? name,
    @JsonKey(name: 'Description', includeIfNull: false) String? description,
    @JsonKey(name: 'Selected', includeIfNull: false) bool? selected,
  });
}

/// @nodoc
class _$NewsletterSimpleCategoryCopyWithImpl<
  $Res,
  $Val extends NewsletterSimpleCategory
>
    implements $NewsletterSimpleCategoryCopyWith<$Res> {
  _$NewsletterSimpleCategoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NewsletterSimpleCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? description = freezed,
    Object? selected = freezed,
  }) {
    return _then(
      _value.copyWith(
            id:
                freezed == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String?,
            name:
                freezed == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String?,
            description:
                freezed == description
                    ? _value.description
                    : description // ignore: cast_nullable_to_non_nullable
                        as String?,
            selected:
                freezed == selected
                    ? _value.selected
                    : selected // ignore: cast_nullable_to_non_nullable
                        as bool?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$NewsletterSimpleCategoryImplCopyWith<$Res>
    implements $NewsletterSimpleCategoryCopyWith<$Res> {
  factory _$$NewsletterSimpleCategoryImplCopyWith(
    _$NewsletterSimpleCategoryImpl value,
    $Res Function(_$NewsletterSimpleCategoryImpl) then,
  ) = __$$NewsletterSimpleCategoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'Name', includeIfNull: false) String? name,
    @JsonKey(name: 'Description', includeIfNull: false) String? description,
    @JsonKey(name: 'Selected', includeIfNull: false) bool? selected,
  });
}

/// @nodoc
class __$$NewsletterSimpleCategoryImplCopyWithImpl<$Res>
    extends
        _$NewsletterSimpleCategoryCopyWithImpl<
          $Res,
          _$NewsletterSimpleCategoryImpl
        >
    implements _$$NewsletterSimpleCategoryImplCopyWith<$Res> {
  __$$NewsletterSimpleCategoryImplCopyWithImpl(
    _$NewsletterSimpleCategoryImpl _value,
    $Res Function(_$NewsletterSimpleCategoryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NewsletterSimpleCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? description = freezed,
    Object? selected = freezed,
  }) {
    return _then(
      _$NewsletterSimpleCategoryImpl(
        id:
            freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String?,
        name:
            freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String?,
        description:
            freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                    as String?,
        selected:
            freezed == selected
                ? _value.selected
                : selected // ignore: cast_nullable_to_non_nullable
                    as bool?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$NewsletterSimpleCategoryImpl implements _NewsletterSimpleCategory {
  _$NewsletterSimpleCategoryImpl({
    @JsonKey(name: 'Id', includeIfNull: false) this.id,
    @JsonKey(name: 'Name', includeIfNull: false) this.name,
    @JsonKey(name: 'Description', includeIfNull: false) this.description,
    @JsonKey(name: 'Selected', includeIfNull: false) this.selected = false,
  });

  factory _$NewsletterSimpleCategoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$NewsletterSimpleCategoryImplFromJson(json);

  @override
  @JsonKey(name: 'Id', includeIfNull: false)
  final String? id;
  @override
  @JsonKey(name: 'Name', includeIfNull: false)
  final String? name;
  @override
  @JsonKey(name: 'Description', includeIfNull: false)
  final String? description;
  @override
  @JsonKey(name: 'Selected', includeIfNull: false)
  final bool? selected;

  @override
  String toString() {
    return 'NewsletterSimpleCategory(id: $id, name: $name, description: $description, selected: $selected)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NewsletterSimpleCategoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.selected, selected) ||
                other.selected == selected));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, description, selected);

  /// Create a copy of NewsletterSimpleCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NewsletterSimpleCategoryImplCopyWith<_$NewsletterSimpleCategoryImpl>
  get copyWith => __$$NewsletterSimpleCategoryImplCopyWithImpl<
    _$NewsletterSimpleCategoryImpl
  >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NewsletterSimpleCategoryImplToJson(this);
  }
}

abstract class _NewsletterSimpleCategory implements NewsletterSimpleCategory {
  factory _NewsletterSimpleCategory({
    @JsonKey(name: 'Id', includeIfNull: false) final String? id,
    @JsonKey(name: 'Name', includeIfNull: false) final String? name,
    @JsonKey(name: 'Description', includeIfNull: false)
    final String? description,
    @JsonKey(name: 'Selected', includeIfNull: false) final bool? selected,
  }) = _$NewsletterSimpleCategoryImpl;

  factory _NewsletterSimpleCategory.fromJson(Map<String, dynamic> json) =
      _$NewsletterSimpleCategoryImpl.fromJson;

  @override
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id;
  @override
  @JsonKey(name: 'Name', includeIfNull: false)
  String? get name;
  @override
  @JsonKey(name: 'Description', includeIfNull: false)
  String? get description;
  @override
  @JsonKey(name: 'Selected', includeIfNull: false)
  bool? get selected;

  /// Create a copy of NewsletterSimpleCategory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NewsletterSimpleCategoryImplCopyWith<_$NewsletterSimpleCategoryImpl>
  get copyWith => throw _privateConstructorUsedError;
}
