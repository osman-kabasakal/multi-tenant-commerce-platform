// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'legal_text_message_template_component_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

LegalTextMessageTemplateComponentModel
_$LegalTextMessageTemplateComponentModelFromJson(Map<String, dynamic> json) {
  return _LegalTextMessageTemplateComponentModel.fromJson(json);
}

/// @nodoc
mixin _$LegalTextMessageTemplateComponentModel {
  @JsonKey(name: 'Name', includeIfNull: false)
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'TemplateText', includeIfNull: false)
  String? get templateText => throw _privateConstructorUsedError;
  @JsonKey(name: 'Order', includeIfNull: false)
  int? get order => throw _privateConstructorUsedError;
  @JsonKey(name: 'Category', includeIfNull: false)
  String? get category => throw _privateConstructorUsedError;
  @JsonKey(name: 'IsRequired', includeIfNull: false)
  bool? get isRequired => throw _privateConstructorUsedError;
  @JsonKey(name: 'IsActive', includeIfNull: false)
  bool? get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this LegalTextMessageTemplateComponentModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LegalTextMessageTemplateComponentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LegalTextMessageTemplateComponentModelCopyWith<
    LegalTextMessageTemplateComponentModel
  >
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LegalTextMessageTemplateComponentModelCopyWith<$Res> {
  factory $LegalTextMessageTemplateComponentModelCopyWith(
    LegalTextMessageTemplateComponentModel value,
    $Res Function(LegalTextMessageTemplateComponentModel) then,
  ) =
      _$LegalTextMessageTemplateComponentModelCopyWithImpl<
        $Res,
        LegalTextMessageTemplateComponentModel
      >;
  @useResult
  $Res call({
    @JsonKey(name: 'Name', includeIfNull: false) String? name,
    @JsonKey(name: 'TemplateText', includeIfNull: false) String? templateText,
    @JsonKey(name: 'Order', includeIfNull: false) int? order,
    @JsonKey(name: 'Category', includeIfNull: false) String? category,
    @JsonKey(name: 'IsRequired', includeIfNull: false) bool? isRequired,
    @JsonKey(name: 'IsActive', includeIfNull: false) bool? isActive,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$LegalTextMessageTemplateComponentModelCopyWithImpl<
  $Res,
  $Val extends LegalTextMessageTemplateComponentModel
>
    implements $LegalTextMessageTemplateComponentModelCopyWith<$Res> {
  _$LegalTextMessageTemplateComponentModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LegalTextMessageTemplateComponentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? templateText = freezed,
    Object? order = freezed,
    Object? category = freezed,
    Object? isRequired = freezed,
    Object? isActive = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            name:
                freezed == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String?,
            templateText:
                freezed == templateText
                    ? _value.templateText
                    : templateText // ignore: cast_nullable_to_non_nullable
                        as String?,
            order:
                freezed == order
                    ? _value.order
                    : order // ignore: cast_nullable_to_non_nullable
                        as int?,
            category:
                freezed == category
                    ? _value.category
                    : category // ignore: cast_nullable_to_non_nullable
                        as String?,
            isRequired:
                freezed == isRequired
                    ? _value.isRequired
                    : isRequired // ignore: cast_nullable_to_non_nullable
                        as bool?,
            isActive:
                freezed == isActive
                    ? _value.isActive
                    : isActive // ignore: cast_nullable_to_non_nullable
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
abstract class _$$LegalTextMessageTemplateComponentModelImplCopyWith<$Res>
    implements $LegalTextMessageTemplateComponentModelCopyWith<$Res> {
  factory _$$LegalTextMessageTemplateComponentModelImplCopyWith(
    _$LegalTextMessageTemplateComponentModelImpl value,
    $Res Function(_$LegalTextMessageTemplateComponentModelImpl) then,
  ) = __$$LegalTextMessageTemplateComponentModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'Name', includeIfNull: false) String? name,
    @JsonKey(name: 'TemplateText', includeIfNull: false) String? templateText,
    @JsonKey(name: 'Order', includeIfNull: false) int? order,
    @JsonKey(name: 'Category', includeIfNull: false) String? category,
    @JsonKey(name: 'IsRequired', includeIfNull: false) bool? isRequired,
    @JsonKey(name: 'IsActive', includeIfNull: false) bool? isActive,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$LegalTextMessageTemplateComponentModelImplCopyWithImpl<$Res>
    extends
        _$LegalTextMessageTemplateComponentModelCopyWithImpl<
          $Res,
          _$LegalTextMessageTemplateComponentModelImpl
        >
    implements _$$LegalTextMessageTemplateComponentModelImplCopyWith<$Res> {
  __$$LegalTextMessageTemplateComponentModelImplCopyWithImpl(
    _$LegalTextMessageTemplateComponentModelImpl _value,
    $Res Function(_$LegalTextMessageTemplateComponentModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LegalTextMessageTemplateComponentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? templateText = freezed,
    Object? order = freezed,
    Object? category = freezed,
    Object? isRequired = freezed,
    Object? isActive = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$LegalTextMessageTemplateComponentModelImpl(
        name:
            freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String?,
        templateText:
            freezed == templateText
                ? _value.templateText
                : templateText // ignore: cast_nullable_to_non_nullable
                    as String?,
        order:
            freezed == order
                ? _value.order
                : order // ignore: cast_nullable_to_non_nullable
                    as int?,
        category:
            freezed == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                    as String?,
        isRequired:
            freezed == isRequired
                ? _value.isRequired
                : isRequired // ignore: cast_nullable_to_non_nullable
                    as bool?,
        isActive:
            freezed == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
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
class _$LegalTextMessageTemplateComponentModelImpl
    implements _LegalTextMessageTemplateComponentModel {
  _$LegalTextMessageTemplateComponentModelImpl({
    @JsonKey(name: 'Name', includeIfNull: false) this.name,
    @JsonKey(name: 'TemplateText', includeIfNull: false) this.templateText,
    @JsonKey(name: 'Order', includeIfNull: false) this.order,
    @JsonKey(name: 'Category', includeIfNull: false) this.category,
    @JsonKey(name: 'IsRequired', includeIfNull: false) this.isRequired = false,
    @JsonKey(name: 'IsActive', includeIfNull: false) this.isActive = false,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _userFields = userFields;

  factory _$LegalTextMessageTemplateComponentModelImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$LegalTextMessageTemplateComponentModelImplFromJson(json);

  @override
  @JsonKey(name: 'Name', includeIfNull: false)
  final String? name;
  @override
  @JsonKey(name: 'TemplateText', includeIfNull: false)
  final String? templateText;
  @override
  @JsonKey(name: 'Order', includeIfNull: false)
  final int? order;
  @override
  @JsonKey(name: 'Category', includeIfNull: false)
  final String? category;
  @override
  @JsonKey(name: 'IsRequired', includeIfNull: false)
  final bool? isRequired;
  @override
  @JsonKey(name: 'IsActive', includeIfNull: false)
  final bool? isActive;
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
    return 'LegalTextMessageTemplateComponentModel(name: $name, templateText: $templateText, order: $order, category: $category, isRequired: $isRequired, isActive: $isActive, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LegalTextMessageTemplateComponentModelImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.templateText, templateText) ||
                other.templateText == templateText) &&
            (identical(other.order, order) || other.order == order) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.isRequired, isRequired) ||
                other.isRequired == isRequired) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            const DeepCollectionEquality().equals(
              other._userFields,
              _userFields,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    name,
    templateText,
    order,
    category,
    isRequired,
    isActive,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of LegalTextMessageTemplateComponentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LegalTextMessageTemplateComponentModelImplCopyWith<
    _$LegalTextMessageTemplateComponentModelImpl
  >
  get copyWith => __$$LegalTextMessageTemplateComponentModelImplCopyWithImpl<
    _$LegalTextMessageTemplateComponentModelImpl
  >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LegalTextMessageTemplateComponentModelImplToJson(this);
  }
}

abstract class _LegalTextMessageTemplateComponentModel
    implements LegalTextMessageTemplateComponentModel {
  factory _LegalTextMessageTemplateComponentModel({
    @JsonKey(name: 'Name', includeIfNull: false) final String? name,
    @JsonKey(name: 'TemplateText', includeIfNull: false)
    final String? templateText,
    @JsonKey(name: 'Order', includeIfNull: false) final int? order,
    @JsonKey(name: 'Category', includeIfNull: false) final String? category,
    @JsonKey(name: 'IsRequired', includeIfNull: false) final bool? isRequired,
    @JsonKey(name: 'IsActive', includeIfNull: false) final bool? isActive,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$LegalTextMessageTemplateComponentModelImpl;

  factory _LegalTextMessageTemplateComponentModel.fromJson(
    Map<String, dynamic> json,
  ) = _$LegalTextMessageTemplateComponentModelImpl.fromJson;

  @override
  @JsonKey(name: 'Name', includeIfNull: false)
  String? get name;
  @override
  @JsonKey(name: 'TemplateText', includeIfNull: false)
  String? get templateText;
  @override
  @JsonKey(name: 'Order', includeIfNull: false)
  int? get order;
  @override
  @JsonKey(name: 'Category', includeIfNull: false)
  String? get category;
  @override
  @JsonKey(name: 'IsRequired', includeIfNull: false)
  bool? get isRequired;
  @override
  @JsonKey(name: 'IsActive', includeIfNull: false)
  bool? get isActive;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of LegalTextMessageTemplateComponentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LegalTextMessageTemplateComponentModelImplCopyWith<
    _$LegalTextMessageTemplateComponentModelImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}
