// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vendor_review_overview_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

VendorReviewOverviewModel _$VendorReviewOverviewModelFromJson(
  Map<String, dynamic> json,
) {
  return _VendorReviewOverviewModel.fromJson(json);
}

/// @nodoc
mixin _$VendorReviewOverviewModel {
  @JsonKey(name: 'VendorId', includeIfNull: false)
  String? get vendorId => throw _privateConstructorUsedError;
  @JsonKey(name: 'RatingSum', includeIfNull: false)
  int? get ratingSum => throw _privateConstructorUsedError;
  @JsonKey(name: 'TotalReviews', includeIfNull: false)
  int? get totalReviews => throw _privateConstructorUsedError;
  @JsonKey(name: 'AllowCustomerReviews', includeIfNull: false)
  bool? get allowCustomerReviews => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this VendorReviewOverviewModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VendorReviewOverviewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VendorReviewOverviewModelCopyWith<VendorReviewOverviewModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VendorReviewOverviewModelCopyWith<$Res> {
  factory $VendorReviewOverviewModelCopyWith(
    VendorReviewOverviewModel value,
    $Res Function(VendorReviewOverviewModel) then,
  ) = _$VendorReviewOverviewModelCopyWithImpl<$Res, VendorReviewOverviewModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'VendorId', includeIfNull: false) String? vendorId,
    @JsonKey(name: 'RatingSum', includeIfNull: false) int? ratingSum,
    @JsonKey(name: 'TotalReviews', includeIfNull: false) int? totalReviews,
    @JsonKey(name: 'AllowCustomerReviews', includeIfNull: false)
    bool? allowCustomerReviews,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$VendorReviewOverviewModelCopyWithImpl<
  $Res,
  $Val extends VendorReviewOverviewModel
>
    implements $VendorReviewOverviewModelCopyWith<$Res> {
  _$VendorReviewOverviewModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VendorReviewOverviewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? vendorId = freezed,
    Object? ratingSum = freezed,
    Object? totalReviews = freezed,
    Object? allowCustomerReviews = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            vendorId:
                freezed == vendorId
                    ? _value.vendorId
                    : vendorId // ignore: cast_nullable_to_non_nullable
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
abstract class _$$VendorReviewOverviewModelImplCopyWith<$Res>
    implements $VendorReviewOverviewModelCopyWith<$Res> {
  factory _$$VendorReviewOverviewModelImplCopyWith(
    _$VendorReviewOverviewModelImpl value,
    $Res Function(_$VendorReviewOverviewModelImpl) then,
  ) = __$$VendorReviewOverviewModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'VendorId', includeIfNull: false) String? vendorId,
    @JsonKey(name: 'RatingSum', includeIfNull: false) int? ratingSum,
    @JsonKey(name: 'TotalReviews', includeIfNull: false) int? totalReviews,
    @JsonKey(name: 'AllowCustomerReviews', includeIfNull: false)
    bool? allowCustomerReviews,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$VendorReviewOverviewModelImplCopyWithImpl<$Res>
    extends
        _$VendorReviewOverviewModelCopyWithImpl<
          $Res,
          _$VendorReviewOverviewModelImpl
        >
    implements _$$VendorReviewOverviewModelImplCopyWith<$Res> {
  __$$VendorReviewOverviewModelImplCopyWithImpl(
    _$VendorReviewOverviewModelImpl _value,
    $Res Function(_$VendorReviewOverviewModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VendorReviewOverviewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? vendorId = freezed,
    Object? ratingSum = freezed,
    Object? totalReviews = freezed,
    Object? allowCustomerReviews = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$VendorReviewOverviewModelImpl(
        vendorId:
            freezed == vendorId
                ? _value.vendorId
                : vendorId // ignore: cast_nullable_to_non_nullable
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
class _$VendorReviewOverviewModelImpl implements _VendorReviewOverviewModel {
  _$VendorReviewOverviewModelImpl({
    @JsonKey(name: 'VendorId', includeIfNull: false) this.vendorId,
    @JsonKey(name: 'RatingSum', includeIfNull: false) this.ratingSum,
    @JsonKey(name: 'TotalReviews', includeIfNull: false) this.totalReviews,
    @JsonKey(name: 'AllowCustomerReviews', includeIfNull: false)
    this.allowCustomerReviews = false,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _userFields = userFields;

  factory _$VendorReviewOverviewModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$VendorReviewOverviewModelImplFromJson(json);

  @override
  @JsonKey(name: 'VendorId', includeIfNull: false)
  final String? vendorId;
  @override
  @JsonKey(name: 'RatingSum', includeIfNull: false)
  final int? ratingSum;
  @override
  @JsonKey(name: 'TotalReviews', includeIfNull: false)
  final int? totalReviews;
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
    return 'VendorReviewOverviewModel(vendorId: $vendorId, ratingSum: $ratingSum, totalReviews: $totalReviews, allowCustomerReviews: $allowCustomerReviews, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VendorReviewOverviewModelImpl &&
            (identical(other.vendorId, vendorId) ||
                other.vendorId == vendorId) &&
            (identical(other.ratingSum, ratingSum) ||
                other.ratingSum == ratingSum) &&
            (identical(other.totalReviews, totalReviews) ||
                other.totalReviews == totalReviews) &&
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
    vendorId,
    ratingSum,
    totalReviews,
    allowCustomerReviews,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of VendorReviewOverviewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VendorReviewOverviewModelImplCopyWith<_$VendorReviewOverviewModelImpl>
  get copyWith => __$$VendorReviewOverviewModelImplCopyWithImpl<
    _$VendorReviewOverviewModelImpl
  >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VendorReviewOverviewModelImplToJson(this);
  }
}

abstract class _VendorReviewOverviewModel implements VendorReviewOverviewModel {
  factory _VendorReviewOverviewModel({
    @JsonKey(name: 'VendorId', includeIfNull: false) final String? vendorId,
    @JsonKey(name: 'RatingSum', includeIfNull: false) final int? ratingSum,
    @JsonKey(name: 'TotalReviews', includeIfNull: false)
    final int? totalReviews,
    @JsonKey(name: 'AllowCustomerReviews', includeIfNull: false)
    final bool? allowCustomerReviews,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$VendorReviewOverviewModelImpl;

  factory _VendorReviewOverviewModel.fromJson(Map<String, dynamic> json) =
      _$VendorReviewOverviewModelImpl.fromJson;

  @override
  @JsonKey(name: 'VendorId', includeIfNull: false)
  String? get vendorId;
  @override
  @JsonKey(name: 'RatingSum', includeIfNull: false)
  int? get ratingSum;
  @override
  @JsonKey(name: 'TotalReviews', includeIfNull: false)
  int? get totalReviews;
  @override
  @JsonKey(name: 'AllowCustomerReviews', includeIfNull: false)
  bool? get allowCustomerReviews;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of VendorReviewOverviewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VendorReviewOverviewModelImplCopyWith<_$VendorReviewOverviewModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
