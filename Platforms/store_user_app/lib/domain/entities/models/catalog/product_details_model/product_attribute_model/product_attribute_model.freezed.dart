// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_attribute_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ProductAttributeModel _$ProductAttributeModelFromJson(
  Map<String, dynamic> json,
) {
  return _ProductAttributeModel.fromJson(json);
}

/// @nodoc
mixin _$ProductAttributeModel {
  @JsonKey(name: 'ProductId', includeIfNull: false)
  String? get productId => throw _privateConstructorUsedError;
  @JsonKey(name: 'ProductAttributeId', includeIfNull: false)
  String? get productAttributeId => throw _privateConstructorUsedError;
  @JsonKey(name: 'Name', includeIfNull: false)
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'Description', includeIfNull: false)
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'TextPrompt', includeIfNull: false)
  String? get textPrompt => throw _privateConstructorUsedError;
  @JsonKey(name: 'IsRequired', includeIfNull: false)
  bool? get isRequired => throw _privateConstructorUsedError;
  @JsonKey(name: 'DefaultValue', includeIfNull: false)
  String? get defaultValue => throw _privateConstructorUsedError;
  @JsonKey(name: 'SelectedDay', includeIfNull: false)
  int? get selectedDay => throw _privateConstructorUsedError;
  @JsonKey(name: 'SelectedMonth', includeIfNull: false)
  int? get selectedMonth => throw _privateConstructorUsedError;
  @JsonKey(name: 'SelectedYear', includeIfNull: false)
  int? get selectedYear => throw _privateConstructorUsedError;
  @JsonKey(name: 'HasCondition', includeIfNull: false)
  bool? get hasCondition => throw _privateConstructorUsedError;
  @JsonKey(name: 'AllowedFileExtensions', includeIfNull: false)
  List<String>? get allowedFileExtensions => throw _privateConstructorUsedError;
  @JsonKey(name: 'AttributeControlType', includeIfNull: false)
  AttributeControlType? get attributeControlType =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'Values', includeIfNull: false)
  List<ProductAttributeValueModel>? get values =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this ProductAttributeModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProductAttributeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductAttributeModelCopyWith<ProductAttributeModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductAttributeModelCopyWith<$Res> {
  factory $ProductAttributeModelCopyWith(
    ProductAttributeModel value,
    $Res Function(ProductAttributeModel) then,
  ) = _$ProductAttributeModelCopyWithImpl<$Res, ProductAttributeModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'ProductId', includeIfNull: false) String? productId,
    @JsonKey(name: 'ProductAttributeId', includeIfNull: false)
    String? productAttributeId,
    @JsonKey(name: 'Name', includeIfNull: false) String? name,
    @JsonKey(name: 'Description', includeIfNull: false) String? description,
    @JsonKey(name: 'TextPrompt', includeIfNull: false) String? textPrompt,
    @JsonKey(name: 'IsRequired', includeIfNull: false) bool? isRequired,
    @JsonKey(name: 'DefaultValue', includeIfNull: false) String? defaultValue,
    @JsonKey(name: 'SelectedDay', includeIfNull: false) int? selectedDay,
    @JsonKey(name: 'SelectedMonth', includeIfNull: false) int? selectedMonth,
    @JsonKey(name: 'SelectedYear', includeIfNull: false) int? selectedYear,
    @JsonKey(name: 'HasCondition', includeIfNull: false) bool? hasCondition,
    @JsonKey(name: 'AllowedFileExtensions', includeIfNull: false)
    List<String>? allowedFileExtensions,
    @JsonKey(name: 'AttributeControlType', includeIfNull: false)
    AttributeControlType? attributeControlType,
    @JsonKey(name: 'Values', includeIfNull: false)
    List<ProductAttributeValueModel>? values,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$ProductAttributeModelCopyWithImpl<
  $Res,
  $Val extends ProductAttributeModel
>
    implements $ProductAttributeModelCopyWith<$Res> {
  _$ProductAttributeModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductAttributeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = freezed,
    Object? productAttributeId = freezed,
    Object? name = freezed,
    Object? description = freezed,
    Object? textPrompt = freezed,
    Object? isRequired = freezed,
    Object? defaultValue = freezed,
    Object? selectedDay = freezed,
    Object? selectedMonth = freezed,
    Object? selectedYear = freezed,
    Object? hasCondition = freezed,
    Object? allowedFileExtensions = freezed,
    Object? attributeControlType = freezed,
    Object? values = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            productId:
                freezed == productId
                    ? _value.productId
                    : productId // ignore: cast_nullable_to_non_nullable
                        as String?,
            productAttributeId:
                freezed == productAttributeId
                    ? _value.productAttributeId
                    : productAttributeId // ignore: cast_nullable_to_non_nullable
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
            textPrompt:
                freezed == textPrompt
                    ? _value.textPrompt
                    : textPrompt // ignore: cast_nullable_to_non_nullable
                        as String?,
            isRequired:
                freezed == isRequired
                    ? _value.isRequired
                    : isRequired // ignore: cast_nullable_to_non_nullable
                        as bool?,
            defaultValue:
                freezed == defaultValue
                    ? _value.defaultValue
                    : defaultValue // ignore: cast_nullable_to_non_nullable
                        as String?,
            selectedDay:
                freezed == selectedDay
                    ? _value.selectedDay
                    : selectedDay // ignore: cast_nullable_to_non_nullable
                        as int?,
            selectedMonth:
                freezed == selectedMonth
                    ? _value.selectedMonth
                    : selectedMonth // ignore: cast_nullable_to_non_nullable
                        as int?,
            selectedYear:
                freezed == selectedYear
                    ? _value.selectedYear
                    : selectedYear // ignore: cast_nullable_to_non_nullable
                        as int?,
            hasCondition:
                freezed == hasCondition
                    ? _value.hasCondition
                    : hasCondition // ignore: cast_nullable_to_non_nullable
                        as bool?,
            allowedFileExtensions:
                freezed == allowedFileExtensions
                    ? _value.allowedFileExtensions
                    : allowedFileExtensions // ignore: cast_nullable_to_non_nullable
                        as List<String>?,
            attributeControlType:
                freezed == attributeControlType
                    ? _value.attributeControlType
                    : attributeControlType // ignore: cast_nullable_to_non_nullable
                        as AttributeControlType?,
            values:
                freezed == values
                    ? _value.values
                    : values // ignore: cast_nullable_to_non_nullable
                        as List<ProductAttributeValueModel>?,
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
abstract class _$$ProductAttributeModelImplCopyWith<$Res>
    implements $ProductAttributeModelCopyWith<$Res> {
  factory _$$ProductAttributeModelImplCopyWith(
    _$ProductAttributeModelImpl value,
    $Res Function(_$ProductAttributeModelImpl) then,
  ) = __$$ProductAttributeModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'ProductId', includeIfNull: false) String? productId,
    @JsonKey(name: 'ProductAttributeId', includeIfNull: false)
    String? productAttributeId,
    @JsonKey(name: 'Name', includeIfNull: false) String? name,
    @JsonKey(name: 'Description', includeIfNull: false) String? description,
    @JsonKey(name: 'TextPrompt', includeIfNull: false) String? textPrompt,
    @JsonKey(name: 'IsRequired', includeIfNull: false) bool? isRequired,
    @JsonKey(name: 'DefaultValue', includeIfNull: false) String? defaultValue,
    @JsonKey(name: 'SelectedDay', includeIfNull: false) int? selectedDay,
    @JsonKey(name: 'SelectedMonth', includeIfNull: false) int? selectedMonth,
    @JsonKey(name: 'SelectedYear', includeIfNull: false) int? selectedYear,
    @JsonKey(name: 'HasCondition', includeIfNull: false) bool? hasCondition,
    @JsonKey(name: 'AllowedFileExtensions', includeIfNull: false)
    List<String>? allowedFileExtensions,
    @JsonKey(name: 'AttributeControlType', includeIfNull: false)
    AttributeControlType? attributeControlType,
    @JsonKey(name: 'Values', includeIfNull: false)
    List<ProductAttributeValueModel>? values,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$ProductAttributeModelImplCopyWithImpl<$Res>
    extends
        _$ProductAttributeModelCopyWithImpl<$Res, _$ProductAttributeModelImpl>
    implements _$$ProductAttributeModelImplCopyWith<$Res> {
  __$$ProductAttributeModelImplCopyWithImpl(
    _$ProductAttributeModelImpl _value,
    $Res Function(_$ProductAttributeModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductAttributeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = freezed,
    Object? productAttributeId = freezed,
    Object? name = freezed,
    Object? description = freezed,
    Object? textPrompt = freezed,
    Object? isRequired = freezed,
    Object? defaultValue = freezed,
    Object? selectedDay = freezed,
    Object? selectedMonth = freezed,
    Object? selectedYear = freezed,
    Object? hasCondition = freezed,
    Object? allowedFileExtensions = freezed,
    Object? attributeControlType = freezed,
    Object? values = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$ProductAttributeModelImpl(
        productId:
            freezed == productId
                ? _value.productId
                : productId // ignore: cast_nullable_to_non_nullable
                    as String?,
        productAttributeId:
            freezed == productAttributeId
                ? _value.productAttributeId
                : productAttributeId // ignore: cast_nullable_to_non_nullable
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
        textPrompt:
            freezed == textPrompt
                ? _value.textPrompt
                : textPrompt // ignore: cast_nullable_to_non_nullable
                    as String?,
        isRequired:
            freezed == isRequired
                ? _value.isRequired
                : isRequired // ignore: cast_nullable_to_non_nullable
                    as bool?,
        defaultValue:
            freezed == defaultValue
                ? _value.defaultValue
                : defaultValue // ignore: cast_nullable_to_non_nullable
                    as String?,
        selectedDay:
            freezed == selectedDay
                ? _value.selectedDay
                : selectedDay // ignore: cast_nullable_to_non_nullable
                    as int?,
        selectedMonth:
            freezed == selectedMonth
                ? _value.selectedMonth
                : selectedMonth // ignore: cast_nullable_to_non_nullable
                    as int?,
        selectedYear:
            freezed == selectedYear
                ? _value.selectedYear
                : selectedYear // ignore: cast_nullable_to_non_nullable
                    as int?,
        hasCondition:
            freezed == hasCondition
                ? _value.hasCondition
                : hasCondition // ignore: cast_nullable_to_non_nullable
                    as bool?,
        allowedFileExtensions:
            freezed == allowedFileExtensions
                ? _value._allowedFileExtensions
                : allowedFileExtensions // ignore: cast_nullable_to_non_nullable
                    as List<String>?,
        attributeControlType:
            freezed == attributeControlType
                ? _value.attributeControlType
                : attributeControlType // ignore: cast_nullable_to_non_nullable
                    as AttributeControlType?,
        values:
            freezed == values
                ? _value._values
                : values // ignore: cast_nullable_to_non_nullable
                    as List<ProductAttributeValueModel>?,
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
class _$ProductAttributeModelImpl implements _ProductAttributeModel {
  _$ProductAttributeModelImpl({
    @JsonKey(name: 'ProductId', includeIfNull: false) this.productId,
    @JsonKey(name: 'ProductAttributeId', includeIfNull: false)
    this.productAttributeId,
    @JsonKey(name: 'Name', includeIfNull: false) this.name,
    @JsonKey(name: 'Description', includeIfNull: false) this.description,
    @JsonKey(name: 'TextPrompt', includeIfNull: false) this.textPrompt,
    @JsonKey(name: 'IsRequired', includeIfNull: false) this.isRequired = false,
    @JsonKey(name: 'DefaultValue', includeIfNull: false) this.defaultValue,
    @JsonKey(name: 'SelectedDay', includeIfNull: false) this.selectedDay = null,
    @JsonKey(name: 'SelectedMonth', includeIfNull: false)
    this.selectedMonth = null,
    @JsonKey(name: 'SelectedYear', includeIfNull: false)
    this.selectedYear = null,
    @JsonKey(name: 'HasCondition', includeIfNull: false)
    this.hasCondition = false,
    @JsonKey(name: 'AllowedFileExtensions', includeIfNull: false)
    final List<String>? allowedFileExtensions = const [],
    @JsonKey(name: 'AttributeControlType', includeIfNull: false)
    this.attributeControlType = AttributeControlType.dropdownList,
    @JsonKey(name: 'Values', includeIfNull: false)
    final List<ProductAttributeValueModel>? values = const [],
    @JsonKey(name: 'Id', includeIfNull: false) this.id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _allowedFileExtensions = allowedFileExtensions,
       _values = values,
       _userFields = userFields;

  factory _$ProductAttributeModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductAttributeModelImplFromJson(json);

  @override
  @JsonKey(name: 'ProductId', includeIfNull: false)
  final String? productId;
  @override
  @JsonKey(name: 'ProductAttributeId', includeIfNull: false)
  final String? productAttributeId;
  @override
  @JsonKey(name: 'Name', includeIfNull: false)
  final String? name;
  @override
  @JsonKey(name: 'Description', includeIfNull: false)
  final String? description;
  @override
  @JsonKey(name: 'TextPrompt', includeIfNull: false)
  final String? textPrompt;
  @override
  @JsonKey(name: 'IsRequired', includeIfNull: false)
  final bool? isRequired;
  @override
  @JsonKey(name: 'DefaultValue', includeIfNull: false)
  final String? defaultValue;
  @override
  @JsonKey(name: 'SelectedDay', includeIfNull: false)
  final int? selectedDay;
  @override
  @JsonKey(name: 'SelectedMonth', includeIfNull: false)
  final int? selectedMonth;
  @override
  @JsonKey(name: 'SelectedYear', includeIfNull: false)
  final int? selectedYear;
  @override
  @JsonKey(name: 'HasCondition', includeIfNull: false)
  final bool? hasCondition;
  final List<String>? _allowedFileExtensions;
  @override
  @JsonKey(name: 'AllowedFileExtensions', includeIfNull: false)
  List<String>? get allowedFileExtensions {
    final value = _allowedFileExtensions;
    if (value == null) return null;
    if (_allowedFileExtensions is EqualUnmodifiableListView)
      return _allowedFileExtensions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'AttributeControlType', includeIfNull: false)
  final AttributeControlType? attributeControlType;
  final List<ProductAttributeValueModel>? _values;
  @override
  @JsonKey(name: 'Values', includeIfNull: false)
  List<ProductAttributeValueModel>? get values {
    final value = _values;
    if (value == null) return null;
    if (_values is EqualUnmodifiableListView) return _values;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

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
    return 'ProductAttributeModel(productId: $productId, productAttributeId: $productAttributeId, name: $name, description: $description, textPrompt: $textPrompt, isRequired: $isRequired, defaultValue: $defaultValue, selectedDay: $selectedDay, selectedMonth: $selectedMonth, selectedYear: $selectedYear, hasCondition: $hasCondition, allowedFileExtensions: $allowedFileExtensions, attributeControlType: $attributeControlType, values: $values, id: $id, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductAttributeModelImpl &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.productAttributeId, productAttributeId) ||
                other.productAttributeId == productAttributeId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.textPrompt, textPrompt) ||
                other.textPrompt == textPrompt) &&
            (identical(other.isRequired, isRequired) ||
                other.isRequired == isRequired) &&
            (identical(other.defaultValue, defaultValue) ||
                other.defaultValue == defaultValue) &&
            (identical(other.selectedDay, selectedDay) ||
                other.selectedDay == selectedDay) &&
            (identical(other.selectedMonth, selectedMonth) ||
                other.selectedMonth == selectedMonth) &&
            (identical(other.selectedYear, selectedYear) ||
                other.selectedYear == selectedYear) &&
            (identical(other.hasCondition, hasCondition) ||
                other.hasCondition == hasCondition) &&
            const DeepCollectionEquality().equals(
              other._allowedFileExtensions,
              _allowedFileExtensions,
            ) &&
            (identical(other.attributeControlType, attributeControlType) ||
                other.attributeControlType == attributeControlType) &&
            const DeepCollectionEquality().equals(other._values, _values) &&
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
    productId,
    productAttributeId,
    name,
    description,
    textPrompt,
    isRequired,
    defaultValue,
    selectedDay,
    selectedMonth,
    selectedYear,
    hasCondition,
    const DeepCollectionEquality().hash(_allowedFileExtensions),
    attributeControlType,
    const DeepCollectionEquality().hash(_values),
    id,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of ProductAttributeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductAttributeModelImplCopyWith<_$ProductAttributeModelImpl>
  get copyWith =>
      __$$ProductAttributeModelImplCopyWithImpl<_$ProductAttributeModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductAttributeModelImplToJson(this);
  }
}

abstract class _ProductAttributeModel implements ProductAttributeModel {
  factory _ProductAttributeModel({
    @JsonKey(name: 'ProductId', includeIfNull: false) final String? productId,
    @JsonKey(name: 'ProductAttributeId', includeIfNull: false)
    final String? productAttributeId,
    @JsonKey(name: 'Name', includeIfNull: false) final String? name,
    @JsonKey(name: 'Description', includeIfNull: false)
    final String? description,
    @JsonKey(name: 'TextPrompt', includeIfNull: false) final String? textPrompt,
    @JsonKey(name: 'IsRequired', includeIfNull: false) final bool? isRequired,
    @JsonKey(name: 'DefaultValue', includeIfNull: false)
    final String? defaultValue,
    @JsonKey(name: 'SelectedDay', includeIfNull: false) final int? selectedDay,
    @JsonKey(name: 'SelectedMonth', includeIfNull: false)
    final int? selectedMonth,
    @JsonKey(name: 'SelectedYear', includeIfNull: false)
    final int? selectedYear,
    @JsonKey(name: 'HasCondition', includeIfNull: false)
    final bool? hasCondition,
    @JsonKey(name: 'AllowedFileExtensions', includeIfNull: false)
    final List<String>? allowedFileExtensions,
    @JsonKey(name: 'AttributeControlType', includeIfNull: false)
    final AttributeControlType? attributeControlType,
    @JsonKey(name: 'Values', includeIfNull: false)
    final List<ProductAttributeValueModel>? values,
    @JsonKey(name: 'Id', includeIfNull: false) final String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$ProductAttributeModelImpl;

  factory _ProductAttributeModel.fromJson(Map<String, dynamic> json) =
      _$ProductAttributeModelImpl.fromJson;

  @override
  @JsonKey(name: 'ProductId', includeIfNull: false)
  String? get productId;
  @override
  @JsonKey(name: 'ProductAttributeId', includeIfNull: false)
  String? get productAttributeId;
  @override
  @JsonKey(name: 'Name', includeIfNull: false)
  String? get name;
  @override
  @JsonKey(name: 'Description', includeIfNull: false)
  String? get description;
  @override
  @JsonKey(name: 'TextPrompt', includeIfNull: false)
  String? get textPrompt;
  @override
  @JsonKey(name: 'IsRequired', includeIfNull: false)
  bool? get isRequired;
  @override
  @JsonKey(name: 'DefaultValue', includeIfNull: false)
  String? get defaultValue;
  @override
  @JsonKey(name: 'SelectedDay', includeIfNull: false)
  int? get selectedDay;
  @override
  @JsonKey(name: 'SelectedMonth', includeIfNull: false)
  int? get selectedMonth;
  @override
  @JsonKey(name: 'SelectedYear', includeIfNull: false)
  int? get selectedYear;
  @override
  @JsonKey(name: 'HasCondition', includeIfNull: false)
  bool? get hasCondition;
  @override
  @JsonKey(name: 'AllowedFileExtensions', includeIfNull: false)
  List<String>? get allowedFileExtensions;
  @override
  @JsonKey(name: 'AttributeControlType', includeIfNull: false)
  AttributeControlType? get attributeControlType;
  @override
  @JsonKey(name: 'Values', includeIfNull: false)
  List<ProductAttributeValueModel>? get values;
  @override
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of ProductAttributeModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductAttributeModelImplCopyWith<_$ProductAttributeModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
