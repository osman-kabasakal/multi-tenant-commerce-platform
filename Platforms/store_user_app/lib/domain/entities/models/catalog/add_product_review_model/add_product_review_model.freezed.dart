// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'add_product_review_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AddProductReviewModel _$AddProductReviewModelFromJson(
  Map<String, dynamic> json,
) {
  return _AddProductReviewModel.fromJson(json);
}

/// @nodoc
mixin _$AddProductReviewModel {
  @JsonKey(name: 'Title', includeIfNull: false)
  String? get title => throw _privateConstructorUsedError;
  @JsonKey(name: 'ReviewText', includeIfNull: false)
  String? get reviewText => throw _privateConstructorUsedError;
  @JsonKey(name: 'Rating', includeIfNull: false)
  int? get rating => throw _privateConstructorUsedError;
  @JsonKey(name: 'DisplayCaptcha', includeIfNull: false)
  bool? get displayCaptcha => throw _privateConstructorUsedError;
  @JsonKey(name: 'CanCurrentCustomerLeaveReview', includeIfNull: false)
  bool? get canCurrentCustomerLeaveReview => throw _privateConstructorUsedError;
  @JsonKey(name: 'SuccessfullyAdded', includeIfNull: false)
  bool? get successfullyAdded => throw _privateConstructorUsedError;
  @JsonKey(name: 'Result', includeIfNull: false)
  String? get result => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this AddProductReviewModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AddProductReviewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AddProductReviewModelCopyWith<AddProductReviewModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddProductReviewModelCopyWith<$Res> {
  factory $AddProductReviewModelCopyWith(
    AddProductReviewModel value,
    $Res Function(AddProductReviewModel) then,
  ) = _$AddProductReviewModelCopyWithImpl<$Res, AddProductReviewModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'Title', includeIfNull: false) String? title,
    @JsonKey(name: 'ReviewText', includeIfNull: false) String? reviewText,
    @JsonKey(name: 'Rating', includeIfNull: false) int? rating,
    @JsonKey(name: 'DisplayCaptcha', includeIfNull: false) bool? displayCaptcha,
    @JsonKey(name: 'CanCurrentCustomerLeaveReview', includeIfNull: false)
    bool? canCurrentCustomerLeaveReview,
    @JsonKey(name: 'SuccessfullyAdded', includeIfNull: false)
    bool? successfullyAdded,
    @JsonKey(name: 'Result', includeIfNull: false) String? result,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$AddProductReviewModelCopyWithImpl<
  $Res,
  $Val extends AddProductReviewModel
>
    implements $AddProductReviewModelCopyWith<$Res> {
  _$AddProductReviewModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AddProductReviewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = freezed,
    Object? reviewText = freezed,
    Object? rating = freezed,
    Object? displayCaptcha = freezed,
    Object? canCurrentCustomerLeaveReview = freezed,
    Object? successfullyAdded = freezed,
    Object? result = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            title:
                freezed == title
                    ? _value.title
                    : title // ignore: cast_nullable_to_non_nullable
                        as String?,
            reviewText:
                freezed == reviewText
                    ? _value.reviewText
                    : reviewText // ignore: cast_nullable_to_non_nullable
                        as String?,
            rating:
                freezed == rating
                    ? _value.rating
                    : rating // ignore: cast_nullable_to_non_nullable
                        as int?,
            displayCaptcha:
                freezed == displayCaptcha
                    ? _value.displayCaptcha
                    : displayCaptcha // ignore: cast_nullable_to_non_nullable
                        as bool?,
            canCurrentCustomerLeaveReview:
                freezed == canCurrentCustomerLeaveReview
                    ? _value.canCurrentCustomerLeaveReview
                    : canCurrentCustomerLeaveReview // ignore: cast_nullable_to_non_nullable
                        as bool?,
            successfullyAdded:
                freezed == successfullyAdded
                    ? _value.successfullyAdded
                    : successfullyAdded // ignore: cast_nullable_to_non_nullable
                        as bool?,
            result:
                freezed == result
                    ? _value.result
                    : result // ignore: cast_nullable_to_non_nullable
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
abstract class _$$AddProductReviewModelImplCopyWith<$Res>
    implements $AddProductReviewModelCopyWith<$Res> {
  factory _$$AddProductReviewModelImplCopyWith(
    _$AddProductReviewModelImpl value,
    $Res Function(_$AddProductReviewModelImpl) then,
  ) = __$$AddProductReviewModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'Title', includeIfNull: false) String? title,
    @JsonKey(name: 'ReviewText', includeIfNull: false) String? reviewText,
    @JsonKey(name: 'Rating', includeIfNull: false) int? rating,
    @JsonKey(name: 'DisplayCaptcha', includeIfNull: false) bool? displayCaptcha,
    @JsonKey(name: 'CanCurrentCustomerLeaveReview', includeIfNull: false)
    bool? canCurrentCustomerLeaveReview,
    @JsonKey(name: 'SuccessfullyAdded', includeIfNull: false)
    bool? successfullyAdded,
    @JsonKey(name: 'Result', includeIfNull: false) String? result,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$AddProductReviewModelImplCopyWithImpl<$Res>
    extends
        _$AddProductReviewModelCopyWithImpl<$Res, _$AddProductReviewModelImpl>
    implements _$$AddProductReviewModelImplCopyWith<$Res> {
  __$$AddProductReviewModelImplCopyWithImpl(
    _$AddProductReviewModelImpl _value,
    $Res Function(_$AddProductReviewModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AddProductReviewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = freezed,
    Object? reviewText = freezed,
    Object? rating = freezed,
    Object? displayCaptcha = freezed,
    Object? canCurrentCustomerLeaveReview = freezed,
    Object? successfullyAdded = freezed,
    Object? result = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$AddProductReviewModelImpl(
        title:
            freezed == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                    as String?,
        reviewText:
            freezed == reviewText
                ? _value.reviewText
                : reviewText // ignore: cast_nullable_to_non_nullable
                    as String?,
        rating:
            freezed == rating
                ? _value.rating
                : rating // ignore: cast_nullable_to_non_nullable
                    as int?,
        displayCaptcha:
            freezed == displayCaptcha
                ? _value.displayCaptcha
                : displayCaptcha // ignore: cast_nullable_to_non_nullable
                    as bool?,
        canCurrentCustomerLeaveReview:
            freezed == canCurrentCustomerLeaveReview
                ? _value.canCurrentCustomerLeaveReview
                : canCurrentCustomerLeaveReview // ignore: cast_nullable_to_non_nullable
                    as bool?,
        successfullyAdded:
            freezed == successfullyAdded
                ? _value.successfullyAdded
                : successfullyAdded // ignore: cast_nullable_to_non_nullable
                    as bool?,
        result:
            freezed == result
                ? _value.result
                : result // ignore: cast_nullable_to_non_nullable
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
class _$AddProductReviewModelImpl implements _AddProductReviewModel {
  _$AddProductReviewModelImpl({
    @JsonKey(name: 'Title', includeIfNull: false) this.title,
    @JsonKey(name: 'ReviewText', includeIfNull: false) this.reviewText,
    @JsonKey(name: 'Rating', includeIfNull: false) this.rating,
    @JsonKey(name: 'DisplayCaptcha', includeIfNull: false)
    this.displayCaptcha = false,
    @JsonKey(name: 'CanCurrentCustomerLeaveReview', includeIfNull: false)
    this.canCurrentCustomerLeaveReview = false,
    @JsonKey(name: 'SuccessfullyAdded', includeIfNull: false)
    this.successfullyAdded = false,
    @JsonKey(name: 'Result', includeIfNull: false) this.result,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _userFields = userFields;

  factory _$AddProductReviewModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AddProductReviewModelImplFromJson(json);

  @override
  @JsonKey(name: 'Title', includeIfNull: false)
  final String? title;
  @override
  @JsonKey(name: 'ReviewText', includeIfNull: false)
  final String? reviewText;
  @override
  @JsonKey(name: 'Rating', includeIfNull: false)
  final int? rating;
  @override
  @JsonKey(name: 'DisplayCaptcha', includeIfNull: false)
  final bool? displayCaptcha;
  @override
  @JsonKey(name: 'CanCurrentCustomerLeaveReview', includeIfNull: false)
  final bool? canCurrentCustomerLeaveReview;
  @override
  @JsonKey(name: 'SuccessfullyAdded', includeIfNull: false)
  final bool? successfullyAdded;
  @override
  @JsonKey(name: 'Result', includeIfNull: false)
  final String? result;
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
    return 'AddProductReviewModel(title: $title, reviewText: $reviewText, rating: $rating, displayCaptcha: $displayCaptcha, canCurrentCustomerLeaveReview: $canCurrentCustomerLeaveReview, successfullyAdded: $successfullyAdded, result: $result, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddProductReviewModelImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.reviewText, reviewText) ||
                other.reviewText == reviewText) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.displayCaptcha, displayCaptcha) ||
                other.displayCaptcha == displayCaptcha) &&
            (identical(
                  other.canCurrentCustomerLeaveReview,
                  canCurrentCustomerLeaveReview,
                ) ||
                other.canCurrentCustomerLeaveReview ==
                    canCurrentCustomerLeaveReview) &&
            (identical(other.successfullyAdded, successfullyAdded) ||
                other.successfullyAdded == successfullyAdded) &&
            (identical(other.result, result) || other.result == result) &&
            const DeepCollectionEquality().equals(
              other._userFields,
              _userFields,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    title,
    reviewText,
    rating,
    displayCaptcha,
    canCurrentCustomerLeaveReview,
    successfullyAdded,
    result,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of AddProductReviewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AddProductReviewModelImplCopyWith<_$AddProductReviewModelImpl>
  get copyWith =>
      __$$AddProductReviewModelImplCopyWithImpl<_$AddProductReviewModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AddProductReviewModelImplToJson(this);
  }
}

abstract class _AddProductReviewModel implements AddProductReviewModel {
  factory _AddProductReviewModel({
    @JsonKey(name: 'Title', includeIfNull: false) final String? title,
    @JsonKey(name: 'ReviewText', includeIfNull: false) final String? reviewText,
    @JsonKey(name: 'Rating', includeIfNull: false) final int? rating,
    @JsonKey(name: 'DisplayCaptcha', includeIfNull: false)
    final bool? displayCaptcha,
    @JsonKey(name: 'CanCurrentCustomerLeaveReview', includeIfNull: false)
    final bool? canCurrentCustomerLeaveReview,
    @JsonKey(name: 'SuccessfullyAdded', includeIfNull: false)
    final bool? successfullyAdded,
    @JsonKey(name: 'Result', includeIfNull: false) final String? result,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$AddProductReviewModelImpl;

  factory _AddProductReviewModel.fromJson(Map<String, dynamic> json) =
      _$AddProductReviewModelImpl.fromJson;

  @override
  @JsonKey(name: 'Title', includeIfNull: false)
  String? get title;
  @override
  @JsonKey(name: 'ReviewText', includeIfNull: false)
  String? get reviewText;
  @override
  @JsonKey(name: 'Rating', includeIfNull: false)
  int? get rating;
  @override
  @JsonKey(name: 'DisplayCaptcha', includeIfNull: false)
  bool? get displayCaptcha;
  @override
  @JsonKey(name: 'CanCurrentCustomerLeaveReview', includeIfNull: false)
  bool? get canCurrentCustomerLeaveReview;
  @override
  @JsonKey(name: 'SuccessfullyAdded', includeIfNull: false)
  bool? get successfullyAdded;
  @override
  @JsonKey(name: 'Result', includeIfNull: false)
  String? get result;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of AddProductReviewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AddProductReviewModelImplCopyWith<_$AddProductReviewModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
