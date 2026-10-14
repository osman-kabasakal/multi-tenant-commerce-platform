// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_auto_complete_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SearchAutoCompleteModel _$SearchAutoCompleteModelFromJson(
  Map<String, dynamic> json,
) {
  return _SearchAutoCompleteModel.fromJson(json);
}

/// @nodoc
mixin _$SearchAutoCompleteModel {
  @JsonKey(name: 'SearchType', includeIfNull: false)
  String? get searchType => throw _privateConstructorUsedError;
  @JsonKey(name: 'Label', includeIfNull: false)
  String? get label => throw _privateConstructorUsedError;
  @JsonKey(name: 'Url', includeIfNull: false)
  String? get url => throw _privateConstructorUsedError;
  @JsonKey(name: 'Desc', includeIfNull: false)
  String? get desc => throw _privateConstructorUsedError;
  @JsonKey(name: 'Price', includeIfNull: false)
  String? get price => throw _privateConstructorUsedError;
  @JsonKey(name: 'PriceWithDiscount', includeIfNull: false)
  String? get priceWithDiscount => throw _privateConstructorUsedError;
  @JsonKey(name: 'AllowCustomerReviews', includeIfNull: false)
  bool? get allowCustomerReviews => throw _privateConstructorUsedError;
  @JsonKey(name: 'Rating', includeIfNull: false)
  double? get rating => throw _privateConstructorUsedError;
  @JsonKey(name: 'PictureUrl', includeIfNull: false)
  String? get pictureUrl => throw _privateConstructorUsedError;

  /// Serializes this SearchAutoCompleteModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SearchAutoCompleteModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SearchAutoCompleteModelCopyWith<SearchAutoCompleteModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchAutoCompleteModelCopyWith<$Res> {
  factory $SearchAutoCompleteModelCopyWith(
    SearchAutoCompleteModel value,
    $Res Function(SearchAutoCompleteModel) then,
  ) = _$SearchAutoCompleteModelCopyWithImpl<$Res, SearchAutoCompleteModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'SearchType', includeIfNull: false) String? searchType,
    @JsonKey(name: 'Label', includeIfNull: false) String? label,
    @JsonKey(name: 'Url', includeIfNull: false) String? url,
    @JsonKey(name: 'Desc', includeIfNull: false) String? desc,
    @JsonKey(name: 'Price', includeIfNull: false) String? price,
    @JsonKey(name: 'PriceWithDiscount', includeIfNull: false)
    String? priceWithDiscount,
    @JsonKey(name: 'AllowCustomerReviews', includeIfNull: false)
    bool? allowCustomerReviews,
    @JsonKey(name: 'Rating', includeIfNull: false) double? rating,
    @JsonKey(name: 'PictureUrl', includeIfNull: false) String? pictureUrl,
  });
}

/// @nodoc
class _$SearchAutoCompleteModelCopyWithImpl<
  $Res,
  $Val extends SearchAutoCompleteModel
>
    implements $SearchAutoCompleteModelCopyWith<$Res> {
  _$SearchAutoCompleteModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SearchAutoCompleteModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? searchType = freezed,
    Object? label = freezed,
    Object? url = freezed,
    Object? desc = freezed,
    Object? price = freezed,
    Object? priceWithDiscount = freezed,
    Object? allowCustomerReviews = freezed,
    Object? rating = freezed,
    Object? pictureUrl = freezed,
  }) {
    return _then(
      _value.copyWith(
            searchType:
                freezed == searchType
                    ? _value.searchType
                    : searchType // ignore: cast_nullable_to_non_nullable
                        as String?,
            label:
                freezed == label
                    ? _value.label
                    : label // ignore: cast_nullable_to_non_nullable
                        as String?,
            url:
                freezed == url
                    ? _value.url
                    : url // ignore: cast_nullable_to_non_nullable
                        as String?,
            desc:
                freezed == desc
                    ? _value.desc
                    : desc // ignore: cast_nullable_to_non_nullable
                        as String?,
            price:
                freezed == price
                    ? _value.price
                    : price // ignore: cast_nullable_to_non_nullable
                        as String?,
            priceWithDiscount:
                freezed == priceWithDiscount
                    ? _value.priceWithDiscount
                    : priceWithDiscount // ignore: cast_nullable_to_non_nullable
                        as String?,
            allowCustomerReviews:
                freezed == allowCustomerReviews
                    ? _value.allowCustomerReviews
                    : allowCustomerReviews // ignore: cast_nullable_to_non_nullable
                        as bool?,
            rating:
                freezed == rating
                    ? _value.rating
                    : rating // ignore: cast_nullable_to_non_nullable
                        as double?,
            pictureUrl:
                freezed == pictureUrl
                    ? _value.pictureUrl
                    : pictureUrl // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SearchAutoCompleteModelImplCopyWith<$Res>
    implements $SearchAutoCompleteModelCopyWith<$Res> {
  factory _$$SearchAutoCompleteModelImplCopyWith(
    _$SearchAutoCompleteModelImpl value,
    $Res Function(_$SearchAutoCompleteModelImpl) then,
  ) = __$$SearchAutoCompleteModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'SearchType', includeIfNull: false) String? searchType,
    @JsonKey(name: 'Label', includeIfNull: false) String? label,
    @JsonKey(name: 'Url', includeIfNull: false) String? url,
    @JsonKey(name: 'Desc', includeIfNull: false) String? desc,
    @JsonKey(name: 'Price', includeIfNull: false) String? price,
    @JsonKey(name: 'PriceWithDiscount', includeIfNull: false)
    String? priceWithDiscount,
    @JsonKey(name: 'AllowCustomerReviews', includeIfNull: false)
    bool? allowCustomerReviews,
    @JsonKey(name: 'Rating', includeIfNull: false) double? rating,
    @JsonKey(name: 'PictureUrl', includeIfNull: false) String? pictureUrl,
  });
}

/// @nodoc
class __$$SearchAutoCompleteModelImplCopyWithImpl<$Res>
    extends
        _$SearchAutoCompleteModelCopyWithImpl<
          $Res,
          _$SearchAutoCompleteModelImpl
        >
    implements _$$SearchAutoCompleteModelImplCopyWith<$Res> {
  __$$SearchAutoCompleteModelImplCopyWithImpl(
    _$SearchAutoCompleteModelImpl _value,
    $Res Function(_$SearchAutoCompleteModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SearchAutoCompleteModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? searchType = freezed,
    Object? label = freezed,
    Object? url = freezed,
    Object? desc = freezed,
    Object? price = freezed,
    Object? priceWithDiscount = freezed,
    Object? allowCustomerReviews = freezed,
    Object? rating = freezed,
    Object? pictureUrl = freezed,
  }) {
    return _then(
      _$SearchAutoCompleteModelImpl(
        searchType:
            freezed == searchType
                ? _value.searchType
                : searchType // ignore: cast_nullable_to_non_nullable
                    as String?,
        label:
            freezed == label
                ? _value.label
                : label // ignore: cast_nullable_to_non_nullable
                    as String?,
        url:
            freezed == url
                ? _value.url
                : url // ignore: cast_nullable_to_non_nullable
                    as String?,
        desc:
            freezed == desc
                ? _value.desc
                : desc // ignore: cast_nullable_to_non_nullable
                    as String?,
        price:
            freezed == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                    as String?,
        priceWithDiscount:
            freezed == priceWithDiscount
                ? _value.priceWithDiscount
                : priceWithDiscount // ignore: cast_nullable_to_non_nullable
                    as String?,
        allowCustomerReviews:
            freezed == allowCustomerReviews
                ? _value.allowCustomerReviews
                : allowCustomerReviews // ignore: cast_nullable_to_non_nullable
                    as bool?,
        rating:
            freezed == rating
                ? _value.rating
                : rating // ignore: cast_nullable_to_non_nullable
                    as double?,
        pictureUrl:
            freezed == pictureUrl
                ? _value.pictureUrl
                : pictureUrl // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SearchAutoCompleteModelImpl implements _SearchAutoCompleteModel {
  _$SearchAutoCompleteModelImpl({
    @JsonKey(name: 'SearchType', includeIfNull: false) this.searchType,
    @JsonKey(name: 'Label', includeIfNull: false) this.label,
    @JsonKey(name: 'Url', includeIfNull: false) this.url,
    @JsonKey(name: 'Desc', includeIfNull: false) this.desc,
    @JsonKey(name: 'Price', includeIfNull: false) this.price,
    @JsonKey(name: 'PriceWithDiscount', includeIfNull: false)
    this.priceWithDiscount,
    @JsonKey(name: 'AllowCustomerReviews', includeIfNull: false)
    this.allowCustomerReviews = false,
    @JsonKey(name: 'Rating', includeIfNull: false) this.rating,
    @JsonKey(name: 'PictureUrl', includeIfNull: false) this.pictureUrl,
  });

  factory _$SearchAutoCompleteModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SearchAutoCompleteModelImplFromJson(json);

  @override
  @JsonKey(name: 'SearchType', includeIfNull: false)
  final String? searchType;
  @override
  @JsonKey(name: 'Label', includeIfNull: false)
  final String? label;
  @override
  @JsonKey(name: 'Url', includeIfNull: false)
  final String? url;
  @override
  @JsonKey(name: 'Desc', includeIfNull: false)
  final String? desc;
  @override
  @JsonKey(name: 'Price', includeIfNull: false)
  final String? price;
  @override
  @JsonKey(name: 'PriceWithDiscount', includeIfNull: false)
  final String? priceWithDiscount;
  @override
  @JsonKey(name: 'AllowCustomerReviews', includeIfNull: false)
  final bool? allowCustomerReviews;
  @override
  @JsonKey(name: 'Rating', includeIfNull: false)
  final double? rating;
  @override
  @JsonKey(name: 'PictureUrl', includeIfNull: false)
  final String? pictureUrl;

  @override
  String toString() {
    return 'SearchAutoCompleteModel(searchType: $searchType, label: $label, url: $url, desc: $desc, price: $price, priceWithDiscount: $priceWithDiscount, allowCustomerReviews: $allowCustomerReviews, rating: $rating, pictureUrl: $pictureUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchAutoCompleteModelImpl &&
            (identical(other.searchType, searchType) ||
                other.searchType == searchType) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.desc, desc) || other.desc == desc) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.priceWithDiscount, priceWithDiscount) ||
                other.priceWithDiscount == priceWithDiscount) &&
            (identical(other.allowCustomerReviews, allowCustomerReviews) ||
                other.allowCustomerReviews == allowCustomerReviews) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.pictureUrl, pictureUrl) ||
                other.pictureUrl == pictureUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    searchType,
    label,
    url,
    desc,
    price,
    priceWithDiscount,
    allowCustomerReviews,
    rating,
    pictureUrl,
  );

  /// Create a copy of SearchAutoCompleteModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchAutoCompleteModelImplCopyWith<_$SearchAutoCompleteModelImpl>
  get copyWith => __$$SearchAutoCompleteModelImplCopyWithImpl<
    _$SearchAutoCompleteModelImpl
  >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SearchAutoCompleteModelImplToJson(this);
  }
}

abstract class _SearchAutoCompleteModel implements SearchAutoCompleteModel {
  factory _SearchAutoCompleteModel({
    @JsonKey(name: 'SearchType', includeIfNull: false) final String? searchType,
    @JsonKey(name: 'Label', includeIfNull: false) final String? label,
    @JsonKey(name: 'Url', includeIfNull: false) final String? url,
    @JsonKey(name: 'Desc', includeIfNull: false) final String? desc,
    @JsonKey(name: 'Price', includeIfNull: false) final String? price,
    @JsonKey(name: 'PriceWithDiscount', includeIfNull: false)
    final String? priceWithDiscount,
    @JsonKey(name: 'AllowCustomerReviews', includeIfNull: false)
    final bool? allowCustomerReviews,
    @JsonKey(name: 'Rating', includeIfNull: false) final double? rating,
    @JsonKey(name: 'PictureUrl', includeIfNull: false) final String? pictureUrl,
  }) = _$SearchAutoCompleteModelImpl;

  factory _SearchAutoCompleteModel.fromJson(Map<String, dynamic> json) =
      _$SearchAutoCompleteModelImpl.fromJson;

  @override
  @JsonKey(name: 'SearchType', includeIfNull: false)
  String? get searchType;
  @override
  @JsonKey(name: 'Label', includeIfNull: false)
  String? get label;
  @override
  @JsonKey(name: 'Url', includeIfNull: false)
  String? get url;
  @override
  @JsonKey(name: 'Desc', includeIfNull: false)
  String? get desc;
  @override
  @JsonKey(name: 'Price', includeIfNull: false)
  String? get price;
  @override
  @JsonKey(name: 'PriceWithDiscount', includeIfNull: false)
  String? get priceWithDiscount;
  @override
  @JsonKey(name: 'AllowCustomerReviews', includeIfNull: false)
  bool? get allowCustomerReviews;
  @override
  @JsonKey(name: 'Rating', includeIfNull: false)
  double? get rating;
  @override
  @JsonKey(name: 'PictureUrl', includeIfNull: false)
  String? get pictureUrl;

  /// Create a copy of SearchAutoCompleteModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SearchAutoCompleteModelImplCopyWith<_$SearchAutoCompleteModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
