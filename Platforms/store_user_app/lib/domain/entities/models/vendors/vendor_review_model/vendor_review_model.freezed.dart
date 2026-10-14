// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vendor_review_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

VendorReviewModel _$VendorReviewModelFromJson(Map<String, dynamic> json) {
  return _VendorReviewModel.fromJson(json);
}

/// @nodoc
mixin _$VendorReviewModel {
  @JsonKey(name: 'CustomerId', includeIfNull: false)
  String? get customerId => throw _privateConstructorUsedError;
  @JsonKey(name: 'CustomerName', includeIfNull: false)
  String? get customerName => throw _privateConstructorUsedError;
  @JsonKey(name: 'Title', includeIfNull: false)
  String? get title => throw _privateConstructorUsedError;
  @JsonKey(name: 'ReviewText', includeIfNull: false)
  String? get reviewText => throw _privateConstructorUsedError;
  @JsonKey(name: 'Rating', includeIfNull: false)
  int? get rating => throw _privateConstructorUsedError;
  @JsonKey(name: 'Helpfulness', includeIfNull: false)
  VendorReviewHelpfulnessModel? get helpfulness =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'WrittenOnStr', includeIfNull: false)
  String? get writtenOnStr => throw _privateConstructorUsedError;
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this VendorReviewModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VendorReviewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VendorReviewModelCopyWith<VendorReviewModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VendorReviewModelCopyWith<$Res> {
  factory $VendorReviewModelCopyWith(
    VendorReviewModel value,
    $Res Function(VendorReviewModel) then,
  ) = _$VendorReviewModelCopyWithImpl<$Res, VendorReviewModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'CustomerId', includeIfNull: false) String? customerId,
    @JsonKey(name: 'CustomerName', includeIfNull: false) String? customerName,
    @JsonKey(name: 'Title', includeIfNull: false) String? title,
    @JsonKey(name: 'ReviewText', includeIfNull: false) String? reviewText,
    @JsonKey(name: 'Rating', includeIfNull: false) int? rating,
    @JsonKey(name: 'Helpfulness', includeIfNull: false)
    VendorReviewHelpfulnessModel? helpfulness,
    @JsonKey(name: 'WrittenOnStr', includeIfNull: false) String? writtenOnStr,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  $VendorReviewHelpfulnessModelCopyWith<$Res>? get helpfulness;
}

/// @nodoc
class _$VendorReviewModelCopyWithImpl<$Res, $Val extends VendorReviewModel>
    implements $VendorReviewModelCopyWith<$Res> {
  _$VendorReviewModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VendorReviewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? customerId = freezed,
    Object? customerName = freezed,
    Object? title = freezed,
    Object? reviewText = freezed,
    Object? rating = freezed,
    Object? helpfulness = freezed,
    Object? writtenOnStr = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            customerId:
                freezed == customerId
                    ? _value.customerId
                    : customerId // ignore: cast_nullable_to_non_nullable
                        as String?,
            customerName:
                freezed == customerName
                    ? _value.customerName
                    : customerName // ignore: cast_nullable_to_non_nullable
                        as String?,
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
            helpfulness:
                freezed == helpfulness
                    ? _value.helpfulness
                    : helpfulness // ignore: cast_nullable_to_non_nullable
                        as VendorReviewHelpfulnessModel?,
            writtenOnStr:
                freezed == writtenOnStr
                    ? _value.writtenOnStr
                    : writtenOnStr // ignore: cast_nullable_to_non_nullable
                        as String?,
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

  /// Create a copy of VendorReviewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VendorReviewHelpfulnessModelCopyWith<$Res>? get helpfulness {
    if (_value.helpfulness == null) {
      return null;
    }

    return $VendorReviewHelpfulnessModelCopyWith<$Res>(_value.helpfulness!, (
      value,
    ) {
      return _then(_value.copyWith(helpfulness: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$VendorReviewModelImplCopyWith<$Res>
    implements $VendorReviewModelCopyWith<$Res> {
  factory _$$VendorReviewModelImplCopyWith(
    _$VendorReviewModelImpl value,
    $Res Function(_$VendorReviewModelImpl) then,
  ) = __$$VendorReviewModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'CustomerId', includeIfNull: false) String? customerId,
    @JsonKey(name: 'CustomerName', includeIfNull: false) String? customerName,
    @JsonKey(name: 'Title', includeIfNull: false) String? title,
    @JsonKey(name: 'ReviewText', includeIfNull: false) String? reviewText,
    @JsonKey(name: 'Rating', includeIfNull: false) int? rating,
    @JsonKey(name: 'Helpfulness', includeIfNull: false)
    VendorReviewHelpfulnessModel? helpfulness,
    @JsonKey(name: 'WrittenOnStr', includeIfNull: false) String? writtenOnStr,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  @override
  $VendorReviewHelpfulnessModelCopyWith<$Res>? get helpfulness;
}

/// @nodoc
class __$$VendorReviewModelImplCopyWithImpl<$Res>
    extends _$VendorReviewModelCopyWithImpl<$Res, _$VendorReviewModelImpl>
    implements _$$VendorReviewModelImplCopyWith<$Res> {
  __$$VendorReviewModelImplCopyWithImpl(
    _$VendorReviewModelImpl _value,
    $Res Function(_$VendorReviewModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VendorReviewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? customerId = freezed,
    Object? customerName = freezed,
    Object? title = freezed,
    Object? reviewText = freezed,
    Object? rating = freezed,
    Object? helpfulness = freezed,
    Object? writtenOnStr = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$VendorReviewModelImpl(
        customerId:
            freezed == customerId
                ? _value.customerId
                : customerId // ignore: cast_nullable_to_non_nullable
                    as String?,
        customerName:
            freezed == customerName
                ? _value.customerName
                : customerName // ignore: cast_nullable_to_non_nullable
                    as String?,
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
        helpfulness:
            freezed == helpfulness
                ? _value.helpfulness
                : helpfulness // ignore: cast_nullable_to_non_nullable
                    as VendorReviewHelpfulnessModel?,
        writtenOnStr:
            freezed == writtenOnStr
                ? _value.writtenOnStr
                : writtenOnStr // ignore: cast_nullable_to_non_nullable
                    as String?,
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
class _$VendorReviewModelImpl implements _VendorReviewModel {
  _$VendorReviewModelImpl({
    @JsonKey(name: 'CustomerId', includeIfNull: false) this.customerId,
    @JsonKey(name: 'CustomerName', includeIfNull: false) this.customerName,
    @JsonKey(name: 'Title', includeIfNull: false) this.title,
    @JsonKey(name: 'ReviewText', includeIfNull: false) this.reviewText,
    @JsonKey(name: 'Rating', includeIfNull: false) this.rating,
    @JsonKey(name: 'Helpfulness', includeIfNull: false) this.helpfulness,
    @JsonKey(name: 'WrittenOnStr', includeIfNull: false) this.writtenOnStr,
    @JsonKey(name: 'Id', includeIfNull: false) this.id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _userFields = userFields;

  factory _$VendorReviewModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$VendorReviewModelImplFromJson(json);

  @override
  @JsonKey(name: 'CustomerId', includeIfNull: false)
  final String? customerId;
  @override
  @JsonKey(name: 'CustomerName', includeIfNull: false)
  final String? customerName;
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
  @JsonKey(name: 'Helpfulness', includeIfNull: false)
  final VendorReviewHelpfulnessModel? helpfulness;
  @override
  @JsonKey(name: 'WrittenOnStr', includeIfNull: false)
  final String? writtenOnStr;
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
    return 'VendorReviewModel(customerId: $customerId, customerName: $customerName, title: $title, reviewText: $reviewText, rating: $rating, helpfulness: $helpfulness, writtenOnStr: $writtenOnStr, id: $id, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VendorReviewModelImpl &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.reviewText, reviewText) ||
                other.reviewText == reviewText) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.helpfulness, helpfulness) ||
                other.helpfulness == helpfulness) &&
            (identical(other.writtenOnStr, writtenOnStr) ||
                other.writtenOnStr == writtenOnStr) &&
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
    customerId,
    customerName,
    title,
    reviewText,
    rating,
    helpfulness,
    writtenOnStr,
    id,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of VendorReviewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VendorReviewModelImplCopyWith<_$VendorReviewModelImpl> get copyWith =>
      __$$VendorReviewModelImplCopyWithImpl<_$VendorReviewModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$VendorReviewModelImplToJson(this);
  }
}

abstract class _VendorReviewModel implements VendorReviewModel {
  factory _VendorReviewModel({
    @JsonKey(name: 'CustomerId', includeIfNull: false) final String? customerId,
    @JsonKey(name: 'CustomerName', includeIfNull: false)
    final String? customerName,
    @JsonKey(name: 'Title', includeIfNull: false) final String? title,
    @JsonKey(name: 'ReviewText', includeIfNull: false) final String? reviewText,
    @JsonKey(name: 'Rating', includeIfNull: false) final int? rating,
    @JsonKey(name: 'Helpfulness', includeIfNull: false)
    final VendorReviewHelpfulnessModel? helpfulness,
    @JsonKey(name: 'WrittenOnStr', includeIfNull: false)
    final String? writtenOnStr,
    @JsonKey(name: 'Id', includeIfNull: false) final String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$VendorReviewModelImpl;

  factory _VendorReviewModel.fromJson(Map<String, dynamic> json) =
      _$VendorReviewModelImpl.fromJson;

  @override
  @JsonKey(name: 'CustomerId', includeIfNull: false)
  String? get customerId;
  @override
  @JsonKey(name: 'CustomerName', includeIfNull: false)
  String? get customerName;
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
  @JsonKey(name: 'Helpfulness', includeIfNull: false)
  VendorReviewHelpfulnessModel? get helpfulness;
  @override
  @JsonKey(name: 'WrittenOnStr', includeIfNull: false)
  String? get writtenOnStr;
  @override
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of VendorReviewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VendorReviewModelImplCopyWith<_$VendorReviewModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
