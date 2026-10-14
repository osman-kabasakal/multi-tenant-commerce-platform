// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vendor_review_helpfulness_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

VendorReviewHelpfulnessModel _$VendorReviewHelpfulnessModelFromJson(
  Map<String, dynamic> json,
) {
  return _VendorReviewHelpfulnessModel.fromJson(json);
}

/// @nodoc
mixin _$VendorReviewHelpfulnessModel {
  @JsonKey(name: 'VendorReviewId', includeIfNull: false)
  String? get vendorReviewId => throw _privateConstructorUsedError;
  @JsonKey(name: 'VendorId', includeIfNull: false)
  String? get vendorId => throw _privateConstructorUsedError;
  @JsonKey(name: 'HelpfulYesTotal', includeIfNull: false)
  int? get helpfulYesTotal => throw _privateConstructorUsedError;
  @JsonKey(name: 'HelpfulNoTotal', includeIfNull: false)
  int? get helpfulNoTotal => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this VendorReviewHelpfulnessModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VendorReviewHelpfulnessModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VendorReviewHelpfulnessModelCopyWith<VendorReviewHelpfulnessModel>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VendorReviewHelpfulnessModelCopyWith<$Res> {
  factory $VendorReviewHelpfulnessModelCopyWith(
    VendorReviewHelpfulnessModel value,
    $Res Function(VendorReviewHelpfulnessModel) then,
  ) =
      _$VendorReviewHelpfulnessModelCopyWithImpl<
        $Res,
        VendorReviewHelpfulnessModel
      >;
  @useResult
  $Res call({
    @JsonKey(name: 'VendorReviewId', includeIfNull: false)
    String? vendorReviewId,
    @JsonKey(name: 'VendorId', includeIfNull: false) String? vendorId,
    @JsonKey(name: 'HelpfulYesTotal', includeIfNull: false)
    int? helpfulYesTotal,
    @JsonKey(name: 'HelpfulNoTotal', includeIfNull: false) int? helpfulNoTotal,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$VendorReviewHelpfulnessModelCopyWithImpl<
  $Res,
  $Val extends VendorReviewHelpfulnessModel
>
    implements $VendorReviewHelpfulnessModelCopyWith<$Res> {
  _$VendorReviewHelpfulnessModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VendorReviewHelpfulnessModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? vendorReviewId = freezed,
    Object? vendorId = freezed,
    Object? helpfulYesTotal = freezed,
    Object? helpfulNoTotal = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            vendorReviewId:
                freezed == vendorReviewId
                    ? _value.vendorReviewId
                    : vendorReviewId // ignore: cast_nullable_to_non_nullable
                        as String?,
            vendorId:
                freezed == vendorId
                    ? _value.vendorId
                    : vendorId // ignore: cast_nullable_to_non_nullable
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
abstract class _$$VendorReviewHelpfulnessModelImplCopyWith<$Res>
    implements $VendorReviewHelpfulnessModelCopyWith<$Res> {
  factory _$$VendorReviewHelpfulnessModelImplCopyWith(
    _$VendorReviewHelpfulnessModelImpl value,
    $Res Function(_$VendorReviewHelpfulnessModelImpl) then,
  ) = __$$VendorReviewHelpfulnessModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'VendorReviewId', includeIfNull: false)
    String? vendorReviewId,
    @JsonKey(name: 'VendorId', includeIfNull: false) String? vendorId,
    @JsonKey(name: 'HelpfulYesTotal', includeIfNull: false)
    int? helpfulYesTotal,
    @JsonKey(name: 'HelpfulNoTotal', includeIfNull: false) int? helpfulNoTotal,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$VendorReviewHelpfulnessModelImplCopyWithImpl<$Res>
    extends
        _$VendorReviewHelpfulnessModelCopyWithImpl<
          $Res,
          _$VendorReviewHelpfulnessModelImpl
        >
    implements _$$VendorReviewHelpfulnessModelImplCopyWith<$Res> {
  __$$VendorReviewHelpfulnessModelImplCopyWithImpl(
    _$VendorReviewHelpfulnessModelImpl _value,
    $Res Function(_$VendorReviewHelpfulnessModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VendorReviewHelpfulnessModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? vendorReviewId = freezed,
    Object? vendorId = freezed,
    Object? helpfulYesTotal = freezed,
    Object? helpfulNoTotal = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$VendorReviewHelpfulnessModelImpl(
        vendorReviewId:
            freezed == vendorReviewId
                ? _value.vendorReviewId
                : vendorReviewId // ignore: cast_nullable_to_non_nullable
                    as String?,
        vendorId:
            freezed == vendorId
                ? _value.vendorId
                : vendorId // ignore: cast_nullable_to_non_nullable
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
class _$VendorReviewHelpfulnessModelImpl
    implements _VendorReviewHelpfulnessModel {
  _$VendorReviewHelpfulnessModelImpl({
    @JsonKey(name: 'VendorReviewId', includeIfNull: false) this.vendorReviewId,
    @JsonKey(name: 'VendorId', includeIfNull: false) this.vendorId,
    @JsonKey(name: 'HelpfulYesTotal', includeIfNull: false)
    this.helpfulYesTotal,
    @JsonKey(name: 'HelpfulNoTotal', includeIfNull: false) this.helpfulNoTotal,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _userFields = userFields;

  factory _$VendorReviewHelpfulnessModelImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$VendorReviewHelpfulnessModelImplFromJson(json);

  @override
  @JsonKey(name: 'VendorReviewId', includeIfNull: false)
  final String? vendorReviewId;
  @override
  @JsonKey(name: 'VendorId', includeIfNull: false)
  final String? vendorId;
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
    return 'VendorReviewHelpfulnessModel(vendorReviewId: $vendorReviewId, vendorId: $vendorId, helpfulYesTotal: $helpfulYesTotal, helpfulNoTotal: $helpfulNoTotal, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VendorReviewHelpfulnessModelImpl &&
            (identical(other.vendorReviewId, vendorReviewId) ||
                other.vendorReviewId == vendorReviewId) &&
            (identical(other.vendorId, vendorId) ||
                other.vendorId == vendorId) &&
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
    vendorReviewId,
    vendorId,
    helpfulYesTotal,
    helpfulNoTotal,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of VendorReviewHelpfulnessModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VendorReviewHelpfulnessModelImplCopyWith<
    _$VendorReviewHelpfulnessModelImpl
  >
  get copyWith => __$$VendorReviewHelpfulnessModelImplCopyWithImpl<
    _$VendorReviewHelpfulnessModelImpl
  >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VendorReviewHelpfulnessModelImplToJson(this);
  }
}

abstract class _VendorReviewHelpfulnessModel
    implements VendorReviewHelpfulnessModel {
  factory _VendorReviewHelpfulnessModel({
    @JsonKey(name: 'VendorReviewId', includeIfNull: false)
    final String? vendorReviewId,
    @JsonKey(name: 'VendorId', includeIfNull: false) final String? vendorId,
    @JsonKey(name: 'HelpfulYesTotal', includeIfNull: false)
    final int? helpfulYesTotal,
    @JsonKey(name: 'HelpfulNoTotal', includeIfNull: false)
    final int? helpfulNoTotal,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$VendorReviewHelpfulnessModelImpl;

  factory _VendorReviewHelpfulnessModel.fromJson(Map<String, dynamic> json) =
      _$VendorReviewHelpfulnessModelImpl.fromJson;

  @override
  @JsonKey(name: 'VendorReviewId', includeIfNull: false)
  String? get vendorReviewId;
  @override
  @JsonKey(name: 'VendorId', includeIfNull: false)
  String? get vendorId;
  @override
  @JsonKey(name: 'HelpfulYesTotal', includeIfNull: false)
  int? get helpfulYesTotal;
  @override
  @JsonKey(name: 'HelpfulNoTotal', includeIfNull: false)
  int? get helpfulNoTotal;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of VendorReviewHelpfulnessModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VendorReviewHelpfulnessModelImplCopyWith<
    _$VendorReviewHelpfulnessModelImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}
