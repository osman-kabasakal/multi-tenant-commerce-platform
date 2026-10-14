// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer_product_review_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CustomerProductReviewModel _$CustomerProductReviewModelFromJson(
  Map<String, dynamic> json,
) {
  return _CustomerProductReviewModel.fromJson(json);
}

/// @nodoc
mixin _$CustomerProductReviewModel {
  @JsonKey(name: 'ProductId', includeIfNull: false)
  String? get productId => throw _privateConstructorUsedError;
  @JsonKey(name: 'ProductName', includeIfNull: false)
  String? get productName => throw _privateConstructorUsedError;
  @JsonKey(name: 'ProductSeName', includeIfNull: false)
  String? get productSeName => throw _privateConstructorUsedError;
  @JsonKey(name: 'StoreName', includeIfNull: false)
  String? get storeName => throw _privateConstructorUsedError;
  @JsonKey(name: 'Title', includeIfNull: false)
  String? get title => throw _privateConstructorUsedError;
  @JsonKey(name: 'ReviewText', includeIfNull: false)
  String? get reviewText => throw _privateConstructorUsedError;
  @JsonKey(name: 'ReplyText', includeIfNull: false)
  String? get replyText => throw _privateConstructorUsedError;
  @JsonKey(name: 'Signature', includeIfNull: false)
  String? get signature => throw _privateConstructorUsedError;
  @JsonKey(name: 'Rating', includeIfNull: false)
  int? get rating => throw _privateConstructorUsedError;
  @JsonKey(name: 'IsApproved', includeIfNull: false)
  bool? get isApproved => throw _privateConstructorUsedError;
  @JsonKey(name: 'CreatedOn', includeIfNull: false)
  DateTime? get createdOn => throw _privateConstructorUsedError;
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this CustomerProductReviewModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CustomerProductReviewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CustomerProductReviewModelCopyWith<CustomerProductReviewModel>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomerProductReviewModelCopyWith<$Res> {
  factory $CustomerProductReviewModelCopyWith(
    CustomerProductReviewModel value,
    $Res Function(CustomerProductReviewModel) then,
  ) =
      _$CustomerProductReviewModelCopyWithImpl<
        $Res,
        CustomerProductReviewModel
      >;
  @useResult
  $Res call({
    @JsonKey(name: 'ProductId', includeIfNull: false) String? productId,
    @JsonKey(name: 'ProductName', includeIfNull: false) String? productName,
    @JsonKey(name: 'ProductSeName', includeIfNull: false) String? productSeName,
    @JsonKey(name: 'StoreName', includeIfNull: false) String? storeName,
    @JsonKey(name: 'Title', includeIfNull: false) String? title,
    @JsonKey(name: 'ReviewText', includeIfNull: false) String? reviewText,
    @JsonKey(name: 'ReplyText', includeIfNull: false) String? replyText,
    @JsonKey(name: 'Signature', includeIfNull: false) String? signature,
    @JsonKey(name: 'Rating', includeIfNull: false) int? rating,
    @JsonKey(name: 'IsApproved', includeIfNull: false) bool? isApproved,
    @JsonKey(name: 'CreatedOn', includeIfNull: false) DateTime? createdOn,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$CustomerProductReviewModelCopyWithImpl<
  $Res,
  $Val extends CustomerProductReviewModel
>
    implements $CustomerProductReviewModelCopyWith<$Res> {
  _$CustomerProductReviewModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CustomerProductReviewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = freezed,
    Object? productName = freezed,
    Object? productSeName = freezed,
    Object? storeName = freezed,
    Object? title = freezed,
    Object? reviewText = freezed,
    Object? replyText = freezed,
    Object? signature = freezed,
    Object? rating = freezed,
    Object? isApproved = freezed,
    Object? createdOn = freezed,
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
            productName:
                freezed == productName
                    ? _value.productName
                    : productName // ignore: cast_nullable_to_non_nullable
                        as String?,
            productSeName:
                freezed == productSeName
                    ? _value.productSeName
                    : productSeName // ignore: cast_nullable_to_non_nullable
                        as String?,
            storeName:
                freezed == storeName
                    ? _value.storeName
                    : storeName // ignore: cast_nullable_to_non_nullable
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
            replyText:
                freezed == replyText
                    ? _value.replyText
                    : replyText // ignore: cast_nullable_to_non_nullable
                        as String?,
            signature:
                freezed == signature
                    ? _value.signature
                    : signature // ignore: cast_nullable_to_non_nullable
                        as String?,
            rating:
                freezed == rating
                    ? _value.rating
                    : rating // ignore: cast_nullable_to_non_nullable
                        as int?,
            isApproved:
                freezed == isApproved
                    ? _value.isApproved
                    : isApproved // ignore: cast_nullable_to_non_nullable
                        as bool?,
            createdOn:
                freezed == createdOn
                    ? _value.createdOn
                    : createdOn // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
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
abstract class _$$CustomerProductReviewModelImplCopyWith<$Res>
    implements $CustomerProductReviewModelCopyWith<$Res> {
  factory _$$CustomerProductReviewModelImplCopyWith(
    _$CustomerProductReviewModelImpl value,
    $Res Function(_$CustomerProductReviewModelImpl) then,
  ) = __$$CustomerProductReviewModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'ProductId', includeIfNull: false) String? productId,
    @JsonKey(name: 'ProductName', includeIfNull: false) String? productName,
    @JsonKey(name: 'ProductSeName', includeIfNull: false) String? productSeName,
    @JsonKey(name: 'StoreName', includeIfNull: false) String? storeName,
    @JsonKey(name: 'Title', includeIfNull: false) String? title,
    @JsonKey(name: 'ReviewText', includeIfNull: false) String? reviewText,
    @JsonKey(name: 'ReplyText', includeIfNull: false) String? replyText,
    @JsonKey(name: 'Signature', includeIfNull: false) String? signature,
    @JsonKey(name: 'Rating', includeIfNull: false) int? rating,
    @JsonKey(name: 'IsApproved', includeIfNull: false) bool? isApproved,
    @JsonKey(name: 'CreatedOn', includeIfNull: false) DateTime? createdOn,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$CustomerProductReviewModelImplCopyWithImpl<$Res>
    extends
        _$CustomerProductReviewModelCopyWithImpl<
          $Res,
          _$CustomerProductReviewModelImpl
        >
    implements _$$CustomerProductReviewModelImplCopyWith<$Res> {
  __$$CustomerProductReviewModelImplCopyWithImpl(
    _$CustomerProductReviewModelImpl _value,
    $Res Function(_$CustomerProductReviewModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CustomerProductReviewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = freezed,
    Object? productName = freezed,
    Object? productSeName = freezed,
    Object? storeName = freezed,
    Object? title = freezed,
    Object? reviewText = freezed,
    Object? replyText = freezed,
    Object? signature = freezed,
    Object? rating = freezed,
    Object? isApproved = freezed,
    Object? createdOn = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$CustomerProductReviewModelImpl(
        productId:
            freezed == productId
                ? _value.productId
                : productId // ignore: cast_nullable_to_non_nullable
                    as String?,
        productName:
            freezed == productName
                ? _value.productName
                : productName // ignore: cast_nullable_to_non_nullable
                    as String?,
        productSeName:
            freezed == productSeName
                ? _value.productSeName
                : productSeName // ignore: cast_nullable_to_non_nullable
                    as String?,
        storeName:
            freezed == storeName
                ? _value.storeName
                : storeName // ignore: cast_nullable_to_non_nullable
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
        replyText:
            freezed == replyText
                ? _value.replyText
                : replyText // ignore: cast_nullable_to_non_nullable
                    as String?,
        signature:
            freezed == signature
                ? _value.signature
                : signature // ignore: cast_nullable_to_non_nullable
                    as String?,
        rating:
            freezed == rating
                ? _value.rating
                : rating // ignore: cast_nullable_to_non_nullable
                    as int?,
        isApproved:
            freezed == isApproved
                ? _value.isApproved
                : isApproved // ignore: cast_nullable_to_non_nullable
                    as bool?,
        createdOn:
            freezed == createdOn
                ? _value.createdOn
                : createdOn // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
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
class _$CustomerProductReviewModelImpl implements _CustomerProductReviewModel {
  _$CustomerProductReviewModelImpl({
    @JsonKey(name: 'ProductId', includeIfNull: false) this.productId,
    @JsonKey(name: 'ProductName', includeIfNull: false) this.productName,
    @JsonKey(name: 'ProductSeName', includeIfNull: false) this.productSeName,
    @JsonKey(name: 'StoreName', includeIfNull: false) this.storeName,
    @JsonKey(name: 'Title', includeIfNull: false) this.title,
    @JsonKey(name: 'ReviewText', includeIfNull: false) this.reviewText,
    @JsonKey(name: 'ReplyText', includeIfNull: false) this.replyText,
    @JsonKey(name: 'Signature', includeIfNull: false) this.signature,
    @JsonKey(name: 'Rating', includeIfNull: false) this.rating,
    @JsonKey(name: 'IsApproved', includeIfNull: false) this.isApproved = false,
    @JsonKey(name: 'CreatedOn', includeIfNull: false) this.createdOn,
    @JsonKey(name: 'Id', includeIfNull: false) this.id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _userFields = userFields;

  factory _$CustomerProductReviewModelImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$CustomerProductReviewModelImplFromJson(json);

  @override
  @JsonKey(name: 'ProductId', includeIfNull: false)
  final String? productId;
  @override
  @JsonKey(name: 'ProductName', includeIfNull: false)
  final String? productName;
  @override
  @JsonKey(name: 'ProductSeName', includeIfNull: false)
  final String? productSeName;
  @override
  @JsonKey(name: 'StoreName', includeIfNull: false)
  final String? storeName;
  @override
  @JsonKey(name: 'Title', includeIfNull: false)
  final String? title;
  @override
  @JsonKey(name: 'ReviewText', includeIfNull: false)
  final String? reviewText;
  @override
  @JsonKey(name: 'ReplyText', includeIfNull: false)
  final String? replyText;
  @override
  @JsonKey(name: 'Signature', includeIfNull: false)
  final String? signature;
  @override
  @JsonKey(name: 'Rating', includeIfNull: false)
  final int? rating;
  @override
  @JsonKey(name: 'IsApproved', includeIfNull: false)
  final bool? isApproved;
  @override
  @JsonKey(name: 'CreatedOn', includeIfNull: false)
  final DateTime? createdOn;
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
    return 'CustomerProductReviewModel(productId: $productId, productName: $productName, productSeName: $productSeName, storeName: $storeName, title: $title, reviewText: $reviewText, replyText: $replyText, signature: $signature, rating: $rating, isApproved: $isApproved, createdOn: $createdOn, id: $id, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomerProductReviewModelImpl &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.productSeName, productSeName) ||
                other.productSeName == productSeName) &&
            (identical(other.storeName, storeName) ||
                other.storeName == storeName) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.reviewText, reviewText) ||
                other.reviewText == reviewText) &&
            (identical(other.replyText, replyText) ||
                other.replyText == replyText) &&
            (identical(other.signature, signature) ||
                other.signature == signature) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.isApproved, isApproved) ||
                other.isApproved == isApproved) &&
            (identical(other.createdOn, createdOn) ||
                other.createdOn == createdOn) &&
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
    productName,
    productSeName,
    storeName,
    title,
    reviewText,
    replyText,
    signature,
    rating,
    isApproved,
    createdOn,
    id,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of CustomerProductReviewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomerProductReviewModelImplCopyWith<_$CustomerProductReviewModelImpl>
  get copyWith => __$$CustomerProductReviewModelImplCopyWithImpl<
    _$CustomerProductReviewModelImpl
  >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CustomerProductReviewModelImplToJson(this);
  }
}

abstract class _CustomerProductReviewModel
    implements CustomerProductReviewModel {
  factory _CustomerProductReviewModel({
    @JsonKey(name: 'ProductId', includeIfNull: false) final String? productId,
    @JsonKey(name: 'ProductName', includeIfNull: false)
    final String? productName,
    @JsonKey(name: 'ProductSeName', includeIfNull: false)
    final String? productSeName,
    @JsonKey(name: 'StoreName', includeIfNull: false) final String? storeName,
    @JsonKey(name: 'Title', includeIfNull: false) final String? title,
    @JsonKey(name: 'ReviewText', includeIfNull: false) final String? reviewText,
    @JsonKey(name: 'ReplyText', includeIfNull: false) final String? replyText,
    @JsonKey(name: 'Signature', includeIfNull: false) final String? signature,
    @JsonKey(name: 'Rating', includeIfNull: false) final int? rating,
    @JsonKey(name: 'IsApproved', includeIfNull: false) final bool? isApproved,
    @JsonKey(name: 'CreatedOn', includeIfNull: false) final DateTime? createdOn,
    @JsonKey(name: 'Id', includeIfNull: false) final String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$CustomerProductReviewModelImpl;

  factory _CustomerProductReviewModel.fromJson(Map<String, dynamic> json) =
      _$CustomerProductReviewModelImpl.fromJson;

  @override
  @JsonKey(name: 'ProductId', includeIfNull: false)
  String? get productId;
  @override
  @JsonKey(name: 'ProductName', includeIfNull: false)
  String? get productName;
  @override
  @JsonKey(name: 'ProductSeName', includeIfNull: false)
  String? get productSeName;
  @override
  @JsonKey(name: 'StoreName', includeIfNull: false)
  String? get storeName;
  @override
  @JsonKey(name: 'Title', includeIfNull: false)
  String? get title;
  @override
  @JsonKey(name: 'ReviewText', includeIfNull: false)
  String? get reviewText;
  @override
  @JsonKey(name: 'ReplyText', includeIfNull: false)
  String? get replyText;
  @override
  @JsonKey(name: 'Signature', includeIfNull: false)
  String? get signature;
  @override
  @JsonKey(name: 'Rating', includeIfNull: false)
  int? get rating;
  @override
  @JsonKey(name: 'IsApproved', includeIfNull: false)
  bool? get isApproved;
  @override
  @JsonKey(name: 'CreatedOn', includeIfNull: false)
  DateTime? get createdOn;
  @override
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of CustomerProductReviewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CustomerProductReviewModelImplCopyWith<_$CustomerProductReviewModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
