// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_review_overview_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ProductReviewOverviewModel _$ProductReviewOverviewModelFromJson(
  Map<String, dynamic> json,
) {
  return _ProductReviewOverviewModel.fromJson(json);
}

/// @nodoc
mixin _$ProductReviewOverviewModel {
  @JsonKey(name: 'ProductId', includeIfNull: false)
  String? get productId => throw _privateConstructorUsedError;
  @JsonKey(name: 'RatingSum', includeIfNull: false)
  int? get ratingSum => throw _privateConstructorUsedError;
  @JsonKey(name: 'TotalReviews', includeIfNull: false)
  int? get totalReviews => throw _privateConstructorUsedError;
  @JsonKey(name: 'AvgRating', includeIfNull: false)
  double? get avgRating => throw _privateConstructorUsedError;
  @JsonKey(name: 'AllowCustomerReviews', includeIfNull: false)
  bool? get allowCustomerReviews => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this ProductReviewOverviewModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProductReviewOverviewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductReviewOverviewModelCopyWith<ProductReviewOverviewModel>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductReviewOverviewModelCopyWith<$Res> {
  factory $ProductReviewOverviewModelCopyWith(
    ProductReviewOverviewModel value,
    $Res Function(ProductReviewOverviewModel) then,
  ) =
      _$ProductReviewOverviewModelCopyWithImpl<
        $Res,
        ProductReviewOverviewModel
      >;
  @useResult
  $Res call({
    @JsonKey(name: 'ProductId', includeIfNull: false) String? productId,
    @JsonKey(name: 'RatingSum', includeIfNull: false) int? ratingSum,
    @JsonKey(name: 'TotalReviews', includeIfNull: false) int? totalReviews,
    @JsonKey(name: 'AvgRating', includeIfNull: false) double? avgRating,
    @JsonKey(name: 'AllowCustomerReviews', includeIfNull: false)
    bool? allowCustomerReviews,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$ProductReviewOverviewModelCopyWithImpl<
  $Res,
  $Val extends ProductReviewOverviewModel
>
    implements $ProductReviewOverviewModelCopyWith<$Res> {
  _$ProductReviewOverviewModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductReviewOverviewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = freezed,
    Object? ratingSum = freezed,
    Object? totalReviews = freezed,
    Object? avgRating = freezed,
    Object? allowCustomerReviews = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            productId:
                freezed == productId
                    ? _value.productId
                    : productId // ignore: cast_nullable_to_non_nullable
                        as String?,
            ratingSum:
                freezed == ratingSum
                    ? _value.ratingSum
                    : ratingSum // ignore: cast_nullable_to_non_nullable
                        as int?,
            totalReviews:
                freezed == totalReviews
                    ? _value.totalReviews
                    : totalReviews // ignore: cast_nullable_to_non_nullable
                        as int?,
            avgRating:
                freezed == avgRating
                    ? _value.avgRating
                    : avgRating // ignore: cast_nullable_to_non_nullable
                        as double?,
            allowCustomerReviews:
                freezed == allowCustomerReviews
                    ? _value.allowCustomerReviews
                    : allowCustomerReviews // ignore: cast_nullable_to_non_nullable
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
abstract class _$$ProductReviewOverviewModelImplCopyWith<$Res>
    implements $ProductReviewOverviewModelCopyWith<$Res> {
  factory _$$ProductReviewOverviewModelImplCopyWith(
    _$ProductReviewOverviewModelImpl value,
    $Res Function(_$ProductReviewOverviewModelImpl) then,
  ) = __$$ProductReviewOverviewModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'ProductId', includeIfNull: false) String? productId,
    @JsonKey(name: 'RatingSum', includeIfNull: false) int? ratingSum,
    @JsonKey(name: 'TotalReviews', includeIfNull: false) int? totalReviews,
    @JsonKey(name: 'AvgRating', includeIfNull: false) double? avgRating,
    @JsonKey(name: 'AllowCustomerReviews', includeIfNull: false)
    bool? allowCustomerReviews,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$ProductReviewOverviewModelImplCopyWithImpl<$Res>
    extends
        _$ProductReviewOverviewModelCopyWithImpl<
          $Res,
          _$ProductReviewOverviewModelImpl
        >
    implements _$$ProductReviewOverviewModelImplCopyWith<$Res> {
  __$$ProductReviewOverviewModelImplCopyWithImpl(
    _$ProductReviewOverviewModelImpl _value,
    $Res Function(_$ProductReviewOverviewModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductReviewOverviewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = freezed,
    Object? ratingSum = freezed,
    Object? totalReviews = freezed,
    Object? avgRating = freezed,
    Object? allowCustomerReviews = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$ProductReviewOverviewModelImpl(
        productId:
            freezed == productId
                ? _value.productId
                : productId // ignore: cast_nullable_to_non_nullable
                    as String?,
        ratingSum:
            freezed == ratingSum
                ? _value.ratingSum
                : ratingSum // ignore: cast_nullable_to_non_nullable
                    as int?,
        totalReviews:
            freezed == totalReviews
                ? _value.totalReviews
                : totalReviews // ignore: cast_nullable_to_non_nullable
                    as int?,
        avgRating:
            freezed == avgRating
                ? _value.avgRating
                : avgRating // ignore: cast_nullable_to_non_nullable
                    as double?,
        allowCustomerReviews:
            freezed == allowCustomerReviews
                ? _value.allowCustomerReviews
                : allowCustomerReviews // ignore: cast_nullable_to_non_nullable
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
class _$ProductReviewOverviewModelImpl implements _ProductReviewOverviewModel {
  _$ProductReviewOverviewModelImpl({
    @JsonKey(name: 'ProductId', includeIfNull: false) this.productId,
    @JsonKey(name: 'RatingSum', includeIfNull: false) this.ratingSum,
    @JsonKey(name: 'TotalReviews', includeIfNull: false) this.totalReviews,
    @JsonKey(name: 'AvgRating', includeIfNull: false) this.avgRating,
    @JsonKey(name: 'AllowCustomerReviews', includeIfNull: false)
    this.allowCustomerReviews = false,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _userFields = userFields;

  factory _$ProductReviewOverviewModelImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$ProductReviewOverviewModelImplFromJson(json);

  @override
  @JsonKey(name: 'ProductId', includeIfNull: false)
  final String? productId;
  @override
  @JsonKey(name: 'RatingSum', includeIfNull: false)
  final int? ratingSum;
  @override
  @JsonKey(name: 'TotalReviews', includeIfNull: false)
  final int? totalReviews;
  @override
  @JsonKey(name: 'AvgRating', includeIfNull: false)
  final double? avgRating;
  @override
  @JsonKey(name: 'AllowCustomerReviews', includeIfNull: false)
  final bool? allowCustomerReviews;
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
    return 'ProductReviewOverviewModel(productId: $productId, ratingSum: $ratingSum, totalReviews: $totalReviews, avgRating: $avgRating, allowCustomerReviews: $allowCustomerReviews, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductReviewOverviewModelImpl &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.ratingSum, ratingSum) ||
                other.ratingSum == ratingSum) &&
            (identical(other.totalReviews, totalReviews) ||
                other.totalReviews == totalReviews) &&
            (identical(other.avgRating, avgRating) ||
                other.avgRating == avgRating) &&
            (identical(other.allowCustomerReviews, allowCustomerReviews) ||
                other.allowCustomerReviews == allowCustomerReviews) &&
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
    ratingSum,
    totalReviews,
    avgRating,
    allowCustomerReviews,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of ProductReviewOverviewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductReviewOverviewModelImplCopyWith<_$ProductReviewOverviewModelImpl>
  get copyWith => __$$ProductReviewOverviewModelImplCopyWithImpl<
    _$ProductReviewOverviewModelImpl
  >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductReviewOverviewModelImplToJson(this);
  }
}

abstract class _ProductReviewOverviewModel
    implements ProductReviewOverviewModel {
  factory _ProductReviewOverviewModel({
    @JsonKey(name: 'ProductId', includeIfNull: false) final String? productId,
    @JsonKey(name: 'RatingSum', includeIfNull: false) final int? ratingSum,
    @JsonKey(name: 'TotalReviews', includeIfNull: false)
    final int? totalReviews,
    @JsonKey(name: 'AvgRating', includeIfNull: false) final double? avgRating,
    @JsonKey(name: 'AllowCustomerReviews', includeIfNull: false)
    final bool? allowCustomerReviews,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$ProductReviewOverviewModelImpl;

  factory _ProductReviewOverviewModel.fromJson(Map<String, dynamic> json) =
      _$ProductReviewOverviewModelImpl.fromJson;

  @override
  @JsonKey(name: 'ProductId', includeIfNull: false)
  String? get productId;
  @override
  @JsonKey(name: 'RatingSum', includeIfNull: false)
  int? get ratingSum;
  @override
  @JsonKey(name: 'TotalReviews', includeIfNull: false)
  int? get totalReviews;
  @override
  @JsonKey(name: 'AvgRating', includeIfNull: false)
  double? get avgRating;
  @override
  @JsonKey(name: 'AllowCustomerReviews', includeIfNull: false)
  bool? get allowCustomerReviews;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of ProductReviewOverviewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductReviewOverviewModelImplCopyWith<_$ProductReviewOverviewModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
