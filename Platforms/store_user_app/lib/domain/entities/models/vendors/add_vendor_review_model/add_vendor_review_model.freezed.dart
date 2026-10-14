// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'add_vendor_review_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AddVendorReviewModel _$AddVendorReviewModelFromJson(Map<String, dynamic> json) {
  return _AddVendorReviewModel.fromJson(json);
}

/// @nodoc
mixin _$AddVendorReviewModel {
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
  @JsonKey(name: 'NotAllowAnonymousUsersToReviewVendor', includeIfNull: false)
  bool? get notAllowAnonymousUsersToReviewVendor =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this AddVendorReviewModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AddVendorReviewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AddVendorReviewModelCopyWith<AddVendorReviewModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddVendorReviewModelCopyWith<$Res> {
  factory $AddVendorReviewModelCopyWith(
    AddVendorReviewModel value,
    $Res Function(AddVendorReviewModel) then,
  ) = _$AddVendorReviewModelCopyWithImpl<$Res, AddVendorReviewModel>;
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
    @JsonKey(name: 'NotAllowAnonymousUsersToReviewVendor', includeIfNull: false)
    bool? notAllowAnonymousUsersToReviewVendor,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$AddVendorReviewModelCopyWithImpl<
  $Res,
  $Val extends AddVendorReviewModel
>
    implements $AddVendorReviewModelCopyWith<$Res> {
  _$AddVendorReviewModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AddVendorReviewModel
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
    Object? notAllowAnonymousUsersToReviewVendor = freezed,
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
            notAllowAnonymousUsersToReviewVendor:
                freezed == notAllowAnonymousUsersToReviewVendor
                    ? _value.notAllowAnonymousUsersToReviewVendor
                    : notAllowAnonymousUsersToReviewVendor // ignore: cast_nullable_to_non_nullable
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
abstract class _$$AddVendorReviewModelImplCopyWith<$Res>
    implements $AddVendorReviewModelCopyWith<$Res> {
  factory _$$AddVendorReviewModelImplCopyWith(
    _$AddVendorReviewModelImpl value,
    $Res Function(_$AddVendorReviewModelImpl) then,
  ) = __$$AddVendorReviewModelImplCopyWithImpl<$Res>;
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
    @JsonKey(name: 'NotAllowAnonymousUsersToReviewVendor', includeIfNull: false)
    bool? notAllowAnonymousUsersToReviewVendor,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$AddVendorReviewModelImplCopyWithImpl<$Res>
    extends _$AddVendorReviewModelCopyWithImpl<$Res, _$AddVendorReviewModelImpl>
    implements _$$AddVendorReviewModelImplCopyWith<$Res> {
  __$$AddVendorReviewModelImplCopyWithImpl(
    _$AddVendorReviewModelImpl _value,
    $Res Function(_$AddVendorReviewModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AddVendorReviewModel
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
    Object? notAllowAnonymousUsersToReviewVendor = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$AddVendorReviewModelImpl(
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
        notAllowAnonymousUsersToReviewVendor:
            freezed == notAllowAnonymousUsersToReviewVendor
                ? _value.notAllowAnonymousUsersToReviewVendor
                : notAllowAnonymousUsersToReviewVendor // ignore: cast_nullable_to_non_nullable
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
class _$AddVendorReviewModelImpl implements _AddVendorReviewModel {
  _$AddVendorReviewModelImpl({
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
    @JsonKey(name: 'NotAllowAnonymousUsersToReviewVendor', includeIfNull: false)
    this.notAllowAnonymousUsersToReviewVendor = false,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _userFields = userFields;

  factory _$AddVendorReviewModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AddVendorReviewModelImplFromJson(json);

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
  @override
  @JsonKey(name: 'NotAllowAnonymousUsersToReviewVendor', includeIfNull: false)
  final bool? notAllowAnonymousUsersToReviewVendor;
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
    return 'AddVendorReviewModel(title: $title, reviewText: $reviewText, rating: $rating, displayCaptcha: $displayCaptcha, canCurrentCustomerLeaveReview: $canCurrentCustomerLeaveReview, successfullyAdded: $successfullyAdded, result: $result, notAllowAnonymousUsersToReviewVendor: $notAllowAnonymousUsersToReviewVendor, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddVendorReviewModelImpl &&
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
            (identical(
                  other.notAllowAnonymousUsersToReviewVendor,
                  notAllowAnonymousUsersToReviewVendor,
                ) ||
                other.notAllowAnonymousUsersToReviewVendor ==
                    notAllowAnonymousUsersToReviewVendor) &&
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
    notAllowAnonymousUsersToReviewVendor,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of AddVendorReviewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AddVendorReviewModelImplCopyWith<_$AddVendorReviewModelImpl>
  get copyWith =>
      __$$AddVendorReviewModelImplCopyWithImpl<_$AddVendorReviewModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AddVendorReviewModelImplToJson(this);
  }
}

abstract class _AddVendorReviewModel implements AddVendorReviewModel {
  factory _AddVendorReviewModel({
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
    @JsonKey(name: 'NotAllowAnonymousUsersToReviewVendor', includeIfNull: false)
    final bool? notAllowAnonymousUsersToReviewVendor,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$AddVendorReviewModelImpl;

  factory _AddVendorReviewModel.fromJson(Map<String, dynamic> json) =
      _$AddVendorReviewModelImpl.fromJson;

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
  @JsonKey(name: 'NotAllowAnonymousUsersToReviewVendor', includeIfNull: false)
  bool? get notAllowAnonymousUsersToReviewVendor;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of AddVendorReviewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AddVendorReviewModelImplCopyWith<_$AddVendorReviewModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
