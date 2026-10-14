// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vendor_reviews_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

VendorReviewsModel _$VendorReviewsModelFromJson(Map<String, dynamic> json) {
  return _VendorReviewsModel.fromJson(json);
}

/// @nodoc
mixin _$VendorReviewsModel {
  @JsonKey(name: 'VendorId', includeIfNull: false)
  String? get vendorId => throw _privateConstructorUsedError;
  @JsonKey(name: 'VendorName', includeIfNull: false)
  String? get vendorName => throw _privateConstructorUsedError;
  @JsonKey(name: 'VendorSeName', includeIfNull: false)
  String? get vendorSeName => throw _privateConstructorUsedError;
  @JsonKey(name: 'Items', includeIfNull: false)
  List<VendorReviewModel>? get items => throw _privateConstructorUsedError;
  @JsonKey(name: 'AddVendorReview', includeIfNull: false)
  AddVendorReviewModel? get addVendorReview =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'VendorReviewOverview', includeIfNull: false)
  VendorReviewOverviewModel? get vendorReviewOverview =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'Captcha', includeIfNull: false)
  ICaptchaValidModel? get captcha => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this VendorReviewsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VendorReviewsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VendorReviewsModelCopyWith<VendorReviewsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VendorReviewsModelCopyWith<$Res> {
  factory $VendorReviewsModelCopyWith(
    VendorReviewsModel value,
    $Res Function(VendorReviewsModel) then,
  ) = _$VendorReviewsModelCopyWithImpl<$Res, VendorReviewsModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'VendorId', includeIfNull: false) String? vendorId,
    @JsonKey(name: 'VendorName', includeIfNull: false) String? vendorName,
    @JsonKey(name: 'VendorSeName', includeIfNull: false) String? vendorSeName,
    @JsonKey(name: 'Items', includeIfNull: false)
    List<VendorReviewModel>? items,
    @JsonKey(name: 'AddVendorReview', includeIfNull: false)
    AddVendorReviewModel? addVendorReview,
    @JsonKey(name: 'VendorReviewOverview', includeIfNull: false)
    VendorReviewOverviewModel? vendorReviewOverview,
    @JsonKey(name: 'Captcha', includeIfNull: false) ICaptchaValidModel? captcha,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  $AddVendorReviewModelCopyWith<$Res>? get addVendorReview;
  $VendorReviewOverviewModelCopyWith<$Res>? get vendorReviewOverview;
  $ICaptchaValidModelCopyWith<$Res>? get captcha;
}

/// @nodoc
class _$VendorReviewsModelCopyWithImpl<$Res, $Val extends VendorReviewsModel>
    implements $VendorReviewsModelCopyWith<$Res> {
  _$VendorReviewsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VendorReviewsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? vendorId = freezed,
    Object? vendorName = freezed,
    Object? vendorSeName = freezed,
    Object? items = freezed,
    Object? addVendorReview = freezed,
    Object? vendorReviewOverview = freezed,
    Object? captcha = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            vendorId:
                freezed == vendorId
                    ? _value.vendorId
                    : vendorId // ignore: cast_nullable_to_non_nullable
                        as String?,
            vendorName:
                freezed == vendorName
                    ? _value.vendorName
                    : vendorName // ignore: cast_nullable_to_non_nullable
                        as String?,
            vendorSeName:
                freezed == vendorSeName
                    ? _value.vendorSeName
                    : vendorSeName // ignore: cast_nullable_to_non_nullable
                        as String?,
            items:
                freezed == items
                    ? _value.items
                    : items // ignore: cast_nullable_to_non_nullable
                        as List<VendorReviewModel>?,
            addVendorReview:
                freezed == addVendorReview
                    ? _value.addVendorReview
                    : addVendorReview // ignore: cast_nullable_to_non_nullable
                        as AddVendorReviewModel?,
            vendorReviewOverview:
                freezed == vendorReviewOverview
                    ? _value.vendorReviewOverview
                    : vendorReviewOverview // ignore: cast_nullable_to_non_nullable
                        as VendorReviewOverviewModel?,
            captcha:
                freezed == captcha
                    ? _value.captcha
                    : captcha // ignore: cast_nullable_to_non_nullable
                        as ICaptchaValidModel?,
            userFields:
                freezed == userFields
                    ? _value.userFields
                    : userFields // ignore: cast_nullable_to_non_nullable
                        as List<UserField>?,
          )
          as $Val,
    );
  }

  /// Create a copy of VendorReviewsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AddVendorReviewModelCopyWith<$Res>? get addVendorReview {
    if (_value.addVendorReview == null) {
      return null;
    }

    return $AddVendorReviewModelCopyWith<$Res>(_value.addVendorReview!, (
      value,
    ) {
      return _then(_value.copyWith(addVendorReview: value) as $Val);
    });
  }

  /// Create a copy of VendorReviewsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VendorReviewOverviewModelCopyWith<$Res>? get vendorReviewOverview {
    if (_value.vendorReviewOverview == null) {
      return null;
    }

    return $VendorReviewOverviewModelCopyWith<$Res>(
      _value.vendorReviewOverview!,
      (value) {
        return _then(_value.copyWith(vendorReviewOverview: value) as $Val);
      },
    );
  }

  /// Create a copy of VendorReviewsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ICaptchaValidModelCopyWith<$Res>? get captcha {
    if (_value.captcha == null) {
      return null;
    }

    return $ICaptchaValidModelCopyWith<$Res>(_value.captcha!, (value) {
      return _then(_value.copyWith(captcha: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$VendorReviewsModelImplCopyWith<$Res>
    implements $VendorReviewsModelCopyWith<$Res> {
  factory _$$VendorReviewsModelImplCopyWith(
    _$VendorReviewsModelImpl value,
    $Res Function(_$VendorReviewsModelImpl) then,
  ) = __$$VendorReviewsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'VendorId', includeIfNull: false) String? vendorId,
    @JsonKey(name: 'VendorName', includeIfNull: false) String? vendorName,
    @JsonKey(name: 'VendorSeName', includeIfNull: false) String? vendorSeName,
    @JsonKey(name: 'Items', includeIfNull: false)
    List<VendorReviewModel>? items,
    @JsonKey(name: 'AddVendorReview', includeIfNull: false)
    AddVendorReviewModel? addVendorReview,
    @JsonKey(name: 'VendorReviewOverview', includeIfNull: false)
    VendorReviewOverviewModel? vendorReviewOverview,
    @JsonKey(name: 'Captcha', includeIfNull: false) ICaptchaValidModel? captcha,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  @override
  $AddVendorReviewModelCopyWith<$Res>? get addVendorReview;
  @override
  $VendorReviewOverviewModelCopyWith<$Res>? get vendorReviewOverview;
  @override
  $ICaptchaValidModelCopyWith<$Res>? get captcha;
}

/// @nodoc
class __$$VendorReviewsModelImplCopyWithImpl<$Res>
    extends _$VendorReviewsModelCopyWithImpl<$Res, _$VendorReviewsModelImpl>
    implements _$$VendorReviewsModelImplCopyWith<$Res> {
  __$$VendorReviewsModelImplCopyWithImpl(
    _$VendorReviewsModelImpl _value,
    $Res Function(_$VendorReviewsModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VendorReviewsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? vendorId = freezed,
    Object? vendorName = freezed,
    Object? vendorSeName = freezed,
    Object? items = freezed,
    Object? addVendorReview = freezed,
    Object? vendorReviewOverview = freezed,
    Object? captcha = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$VendorReviewsModelImpl(
        vendorId:
            freezed == vendorId
                ? _value.vendorId
                : vendorId // ignore: cast_nullable_to_non_nullable
                    as String?,
        vendorName:
            freezed == vendorName
                ? _value.vendorName
                : vendorName // ignore: cast_nullable_to_non_nullable
                    as String?,
        vendorSeName:
            freezed == vendorSeName
                ? _value.vendorSeName
                : vendorSeName // ignore: cast_nullable_to_non_nullable
                    as String?,
        items:
            freezed == items
                ? _value._items
                : items // ignore: cast_nullable_to_non_nullable
                    as List<VendorReviewModel>?,
        addVendorReview:
            freezed == addVendorReview
                ? _value.addVendorReview
                : addVendorReview // ignore: cast_nullable_to_non_nullable
                    as AddVendorReviewModel?,
        vendorReviewOverview:
            freezed == vendorReviewOverview
                ? _value.vendorReviewOverview
                : vendorReviewOverview // ignore: cast_nullable_to_non_nullable
                    as VendorReviewOverviewModel?,
        captcha:
            freezed == captcha
                ? _value.captcha
                : captcha // ignore: cast_nullable_to_non_nullable
                    as ICaptchaValidModel?,
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
class _$VendorReviewsModelImpl implements _VendorReviewsModel {
  _$VendorReviewsModelImpl({
    @JsonKey(name: 'VendorId', includeIfNull: false) this.vendorId,
    @JsonKey(name: 'VendorName', includeIfNull: false) this.vendorName,
    @JsonKey(name: 'VendorSeName', includeIfNull: false) this.vendorSeName,
    @JsonKey(name: 'Items', includeIfNull: false)
    final List<VendorReviewModel>? items = const [],
    @JsonKey(name: 'AddVendorReview', includeIfNull: false)
    this.addVendorReview,
    @JsonKey(name: 'VendorReviewOverview', includeIfNull: false)
    this.vendorReviewOverview,
    @JsonKey(name: 'Captcha', includeIfNull: false) this.captcha,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _items = items,
       _userFields = userFields;

  factory _$VendorReviewsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$VendorReviewsModelImplFromJson(json);

  @override
  @JsonKey(name: 'VendorId', includeIfNull: false)
  final String? vendorId;
  @override
  @JsonKey(name: 'VendorName', includeIfNull: false)
  final String? vendorName;
  @override
  @JsonKey(name: 'VendorSeName', includeIfNull: false)
  final String? vendorSeName;
  final List<VendorReviewModel>? _items;
  @override
  @JsonKey(name: 'Items', includeIfNull: false)
  List<VendorReviewModel>? get items {
    final value = _items;
    if (value == null) return null;
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'AddVendorReview', includeIfNull: false)
  final AddVendorReviewModel? addVendorReview;
  @override
  @JsonKey(name: 'VendorReviewOverview', includeIfNull: false)
  final VendorReviewOverviewModel? vendorReviewOverview;
  @override
  @JsonKey(name: 'Captcha', includeIfNull: false)
  final ICaptchaValidModel? captcha;
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
    return 'VendorReviewsModel(vendorId: $vendorId, vendorName: $vendorName, vendorSeName: $vendorSeName, items: $items, addVendorReview: $addVendorReview, vendorReviewOverview: $vendorReviewOverview, captcha: $captcha, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VendorReviewsModelImpl &&
            (identical(other.vendorId, vendorId) ||
                other.vendorId == vendorId) &&
            (identical(other.vendorName, vendorName) ||
                other.vendorName == vendorName) &&
            (identical(other.vendorSeName, vendorSeName) ||
                other.vendorSeName == vendorSeName) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.addVendorReview, addVendorReview) ||
                other.addVendorReview == addVendorReview) &&
            (identical(other.vendorReviewOverview, vendorReviewOverview) ||
                other.vendorReviewOverview == vendorReviewOverview) &&
            (identical(other.captcha, captcha) || other.captcha == captcha) &&
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
    vendorName,
    vendorSeName,
    const DeepCollectionEquality().hash(_items),
    addVendorReview,
    vendorReviewOverview,
    captcha,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of VendorReviewsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VendorReviewsModelImplCopyWith<_$VendorReviewsModelImpl> get copyWith =>
      __$$VendorReviewsModelImplCopyWithImpl<_$VendorReviewsModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$VendorReviewsModelImplToJson(this);
  }
}

abstract class _VendorReviewsModel implements VendorReviewsModel {
  factory _VendorReviewsModel({
    @JsonKey(name: 'VendorId', includeIfNull: false) final String? vendorId,
    @JsonKey(name: 'VendorName', includeIfNull: false) final String? vendorName,
    @JsonKey(name: 'VendorSeName', includeIfNull: false)
    final String? vendorSeName,
    @JsonKey(name: 'Items', includeIfNull: false)
    final List<VendorReviewModel>? items,
    @JsonKey(name: 'AddVendorReview', includeIfNull: false)
    final AddVendorReviewModel? addVendorReview,
    @JsonKey(name: 'VendorReviewOverview', includeIfNull: false)
    final VendorReviewOverviewModel? vendorReviewOverview,
    @JsonKey(name: 'Captcha', includeIfNull: false)
    final ICaptchaValidModel? captcha,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$VendorReviewsModelImpl;

  factory _VendorReviewsModel.fromJson(Map<String, dynamic> json) =
      _$VendorReviewsModelImpl.fromJson;

  @override
  @JsonKey(name: 'VendorId', includeIfNull: false)
  String? get vendorId;
  @override
  @JsonKey(name: 'VendorName', includeIfNull: false)
  String? get vendorName;
  @override
  @JsonKey(name: 'VendorSeName', includeIfNull: false)
  String? get vendorSeName;
  @override
  @JsonKey(name: 'Items', includeIfNull: false)
  List<VendorReviewModel>? get items;
  @override
  @JsonKey(name: 'AddVendorReview', includeIfNull: false)
  AddVendorReviewModel? get addVendorReview;
  @override
  @JsonKey(name: 'VendorReviewOverview', includeIfNull: false)
  VendorReviewOverviewModel? get vendorReviewOverview;
  @override
  @JsonKey(name: 'Captcha', includeIfNull: false)
  ICaptchaValidModel? get captcha;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of VendorReviewsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VendorReviewsModelImplCopyWith<_$VendorReviewsModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
