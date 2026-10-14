// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_review_helpfulness_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ProductReviewHelpfulnessModel _$ProductReviewHelpfulnessModelFromJson(
  Map<String, dynamic> json,
) {
  return _ProductReviewHelpfulnessModel.fromJson(json);
}

/// @nodoc
mixin _$ProductReviewHelpfulnessModel {
  @JsonKey(name: 'ProductReviewId', includeIfNull: false)
  String? get productReviewId => throw _privateConstructorUsedError;
  @JsonKey(name: 'ProductId', includeIfNull: false)
  String? get productId => throw _privateConstructorUsedError;
  @JsonKey(name: 'HelpfulYesTotal', includeIfNull: false)
  int? get helpfulYesTotal => throw _privateConstructorUsedError;
  @JsonKey(name: 'HelpfulNoTotal', includeIfNull: false)
  int? get helpfulNoTotal => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this ProductReviewHelpfulnessModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProductReviewHelpfulnessModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductReviewHelpfulnessModelCopyWith<ProductReviewHelpfulnessModel>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductReviewHelpfulnessModelCopyWith<$Res> {
  factory $ProductReviewHelpfulnessModelCopyWith(
    ProductReviewHelpfulnessModel value,
    $Res Function(ProductReviewHelpfulnessModel) then,
  ) =
      _$ProductReviewHelpfulnessModelCopyWithImpl<
        $Res,
        ProductReviewHelpfulnessModel
      >;
  @useResult
  $Res call({
    @JsonKey(name: 'ProductReviewId', includeIfNull: false)
    String? productReviewId,
    @JsonKey(name: 'ProductId', includeIfNull: false) String? productId,
    @JsonKey(name: 'HelpfulYesTotal', includeIfNull: false)
    int? helpfulYesTotal,
    @JsonKey(name: 'HelpfulNoTotal', includeIfNull: false) int? helpfulNoTotal,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$ProductReviewHelpfulnessModelCopyWithImpl<
  $Res,
  $Val extends ProductReviewHelpfulnessModel
>
    implements $ProductReviewHelpfulnessModelCopyWith<$Res> {
  _$ProductReviewHelpfulnessModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductReviewHelpfulnessModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productReviewId = freezed,
    Object? productId = freezed,
    Object? helpfulYesTotal = freezed,
    Object? helpfulNoTotal = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            productReviewId:
                freezed == productReviewId
                    ? _value.productReviewId
                    : productReviewId // ignore: cast_nullable_to_non_nullable
                        as String?,
            productId:
                freezed == productId
                    ? _value.productId
                    : productId // ignore: cast_nullable_to_non_nullable
                        as String?,
            helpfulYesTotal:
                freezed == helpfulYesTotal
                    ? _value.helpfulYesTotal
                    : helpfulYesTotal // ignore: cast_nullable_to_non_nullable
                        as int?,
            helpfulNoTotal:
                freezed == helpfulNoTotal
                    ? _value.helpfulNoTotal
                    : helpfulNoTotal // ignore: cast_nullable_to_non_nullable
                        as int?,
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
abstract class _$$ProductReviewHelpfulnessModelImplCopyWith<$Res>
    implements $ProductReviewHelpfulnessModelCopyWith<$Res> {
  factory _$$ProductReviewHelpfulnessModelImplCopyWith(
    _$ProductReviewHelpfulnessModelImpl value,
    $Res Function(_$ProductReviewHelpfulnessModelImpl) then,
  ) = __$$ProductReviewHelpfulnessModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'ProductReviewId', includeIfNull: false)
    String? productReviewId,
    @JsonKey(name: 'ProductId', includeIfNull: false) String? productId,
    @JsonKey(name: 'HelpfulYesTotal', includeIfNull: false)
    int? helpfulYesTotal,
    @JsonKey(name: 'HelpfulNoTotal', includeIfNull: false) int? helpfulNoTotal,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$ProductReviewHelpfulnessModelImplCopyWithImpl<$Res>
    extends
        _$ProductReviewHelpfulnessModelCopyWithImpl<
          $Res,
          _$ProductReviewHelpfulnessModelImpl
        >
    implements _$$ProductReviewHelpfulnessModelImplCopyWith<$Res> {
  __$$ProductReviewHelpfulnessModelImplCopyWithImpl(
    _$ProductReviewHelpfulnessModelImpl _value,
    $Res Function(_$ProductReviewHelpfulnessModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductReviewHelpfulnessModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productReviewId = freezed,
    Object? productId = freezed,
    Object? helpfulYesTotal = freezed,
    Object? helpfulNoTotal = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$ProductReviewHelpfulnessModelImpl(
        productReviewId:
            freezed == productReviewId
                ? _value.productReviewId
                : productReviewId // ignore: cast_nullable_to_non_nullable
                    as String?,
        productId:
            freezed == productId
                ? _value.productId
                : productId // ignore: cast_nullable_to_non_nullable
                    as String?,
        helpfulYesTotal:
            freezed == helpfulYesTotal
                ? _value.helpfulYesTotal
                : helpfulYesTotal // ignore: cast_nullable_to_non_nullable
                    as int?,
        helpfulNoTotal:
            freezed == helpfulNoTotal
                ? _value.helpfulNoTotal
                : helpfulNoTotal // ignore: cast_nullable_to_non_nullable
                    as int?,
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
class _$ProductReviewHelpfulnessModelImpl
    implements _ProductReviewHelpfulnessModel {
  _$ProductReviewHelpfulnessModelImpl({
    @JsonKey(name: 'ProductReviewId', includeIfNull: false)
    this.productReviewId,
    @JsonKey(name: 'ProductId', includeIfNull: false) this.productId,
    @JsonKey(name: 'HelpfulYesTotal', includeIfNull: false)
    this.helpfulYesTotal,
    @JsonKey(name: 'HelpfulNoTotal', includeIfNull: false) this.helpfulNoTotal,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _userFields = userFields;

  factory _$ProductReviewHelpfulnessModelImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$ProductReviewHelpfulnessModelImplFromJson(json);

  @override
  @JsonKey(name: 'ProductReviewId', includeIfNull: false)
  final String? productReviewId;
  @override
  @JsonKey(name: 'ProductId', includeIfNull: false)
  final String? productId;
  @override
  @JsonKey(name: 'HelpfulYesTotal', includeIfNull: false)
  final int? helpfulYesTotal;
  @override
  @JsonKey(name: 'HelpfulNoTotal', includeIfNull: false)
  final int? helpfulNoTotal;
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
    return 'ProductReviewHelpfulnessModel(productReviewId: $productReviewId, productId: $productId, helpfulYesTotal: $helpfulYesTotal, helpfulNoTotal: $helpfulNoTotal, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductReviewHelpfulnessModelImpl &&
            (identical(other.productReviewId, productReviewId) ||
                other.productReviewId == productReviewId) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.helpfulYesTotal, helpfulYesTotal) ||
                other.helpfulYesTotal == helpfulYesTotal) &&
            (identical(other.helpfulNoTotal, helpfulNoTotal) ||
                other.helpfulNoTotal == helpfulNoTotal) &&
            const DeepCollectionEquality().equals(
              other._userFields,
              _userFields,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    productReviewId,
    productId,
    helpfulYesTotal,
    helpfulNoTotal,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of ProductReviewHelpfulnessModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductReviewHelpfulnessModelImplCopyWith<
    _$ProductReviewHelpfulnessModelImpl
  >
  get copyWith => __$$ProductReviewHelpfulnessModelImplCopyWithImpl<
    _$ProductReviewHelpfulnessModelImpl
  >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductReviewHelpfulnessModelImplToJson(this);
  }
}

abstract class _ProductReviewHelpfulnessModel
    implements ProductReviewHelpfulnessModel {
  factory _ProductReviewHelpfulnessModel({
    @JsonKey(name: 'ProductReviewId', includeIfNull: false)
    final String? productReviewId,
    @JsonKey(name: 'ProductId', includeIfNull: false) final String? productId,
    @JsonKey(name: 'HelpfulYesTotal', includeIfNull: false)
    final int? helpfulYesTotal,
    @JsonKey(name: 'HelpfulNoTotal', includeIfNull: false)
    final int? helpfulNoTotal,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$ProductReviewHelpfulnessModelImpl;

  factory _ProductReviewHelpfulnessModel.fromJson(Map<String, dynamic> json) =
      _$ProductReviewHelpfulnessModelImpl.fromJson;

  @override
  @JsonKey(name: 'ProductReviewId', includeIfNull: false)
  String? get productReviewId;
  @override
  @JsonKey(name: 'ProductId', includeIfNull: false)
  String? get productId;
  @override
  @JsonKey(name: 'HelpfulYesTotal', includeIfNull: false)
  int? get helpfulYesTotal;
  @override
  @JsonKey(name: 'HelpfulNoTotal', includeIfNull: false)
  int? get helpfulNoTotal;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of ProductReviewHelpfulnessModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductReviewHelpfulnessModelImplCopyWith<
    _$ProductReviewHelpfulnessModelImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}
