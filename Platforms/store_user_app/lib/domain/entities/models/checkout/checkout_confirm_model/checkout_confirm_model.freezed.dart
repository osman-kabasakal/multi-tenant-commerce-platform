// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'checkout_confirm_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CheckoutConfirmModel _$CheckoutConfirmModelFromJson(Map<String, dynamic> json) {
  return _CheckoutConfirmModel.fromJson(json);
}

/// @nodoc
mixin _$CheckoutConfirmModel {
  @JsonKey(name: 'TermsOfServiceOnOrderConfirmPage', includeIfNull: false)
  bool? get termsOfServiceOnOrderConfirmPage =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'MinOrderTotalWarning', includeIfNull: false)
  String? get minOrderTotalWarning => throw _privateConstructorUsedError;
  @JsonKey(name: 'Warnings', includeIfNull: false)
  List<String>? get warnings => throw _privateConstructorUsedError;
  @JsonKey(name: 'OrderReviewData', includeIfNull: false)
  OrderReviewDataModel? get orderReviewData =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this CheckoutConfirmModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CheckoutConfirmModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CheckoutConfirmModelCopyWith<CheckoutConfirmModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CheckoutConfirmModelCopyWith<$Res> {
  factory $CheckoutConfirmModelCopyWith(
    CheckoutConfirmModel value,
    $Res Function(CheckoutConfirmModel) then,
  ) = _$CheckoutConfirmModelCopyWithImpl<$Res, CheckoutConfirmModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'TermsOfServiceOnOrderConfirmPage', includeIfNull: false)
    bool? termsOfServiceOnOrderConfirmPage,
    @JsonKey(name: 'MinOrderTotalWarning', includeIfNull: false)
    String? minOrderTotalWarning,
    @JsonKey(name: 'Warnings', includeIfNull: false) List<String>? warnings,
    @JsonKey(name: 'OrderReviewData', includeIfNull: false)
    OrderReviewDataModel? orderReviewData,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  $OrderReviewDataModelCopyWith<$Res>? get orderReviewData;
}

/// @nodoc
class _$CheckoutConfirmModelCopyWithImpl<
  $Res,
  $Val extends CheckoutConfirmModel
>
    implements $CheckoutConfirmModelCopyWith<$Res> {
  _$CheckoutConfirmModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CheckoutConfirmModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? termsOfServiceOnOrderConfirmPage = freezed,
    Object? minOrderTotalWarning = freezed,
    Object? warnings = freezed,
    Object? orderReviewData = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            termsOfServiceOnOrderConfirmPage:
                freezed == termsOfServiceOnOrderConfirmPage
                    ? _value.termsOfServiceOnOrderConfirmPage
                    : termsOfServiceOnOrderConfirmPage // ignore: cast_nullable_to_non_nullable
                        as bool?,
            minOrderTotalWarning:
                freezed == minOrderTotalWarning
                    ? _value.minOrderTotalWarning
                    : minOrderTotalWarning // ignore: cast_nullable_to_non_nullable
                        as String?,
            warnings:
                freezed == warnings
                    ? _value.warnings
                    : warnings // ignore: cast_nullable_to_non_nullable
                        as List<String>?,
            orderReviewData:
                freezed == orderReviewData
                    ? _value.orderReviewData
                    : orderReviewData // ignore: cast_nullable_to_non_nullable
                        as OrderReviewDataModel?,
            userFields:
                freezed == userFields
                    ? _value.userFields
                    : userFields // ignore: cast_nullable_to_non_nullable
                        as List<UserField>?,
          )
          as $Val,
    );
  }

  /// Create a copy of CheckoutConfirmModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrderReviewDataModelCopyWith<$Res>? get orderReviewData {
    if (_value.orderReviewData == null) {
      return null;
    }

    return $OrderReviewDataModelCopyWith<$Res>(_value.orderReviewData!, (
      value,
    ) {
      return _then(_value.copyWith(orderReviewData: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CheckoutConfirmModelImplCopyWith<$Res>
    implements $CheckoutConfirmModelCopyWith<$Res> {
  factory _$$CheckoutConfirmModelImplCopyWith(
    _$CheckoutConfirmModelImpl value,
    $Res Function(_$CheckoutConfirmModelImpl) then,
  ) = __$$CheckoutConfirmModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'TermsOfServiceOnOrderConfirmPage', includeIfNull: false)
    bool? termsOfServiceOnOrderConfirmPage,
    @JsonKey(name: 'MinOrderTotalWarning', includeIfNull: false)
    String? minOrderTotalWarning,
    @JsonKey(name: 'Warnings', includeIfNull: false) List<String>? warnings,
    @JsonKey(name: 'OrderReviewData', includeIfNull: false)
    OrderReviewDataModel? orderReviewData,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  @override
  $OrderReviewDataModelCopyWith<$Res>? get orderReviewData;
}

/// @nodoc
class __$$CheckoutConfirmModelImplCopyWithImpl<$Res>
    extends _$CheckoutConfirmModelCopyWithImpl<$Res, _$CheckoutConfirmModelImpl>
    implements _$$CheckoutConfirmModelImplCopyWith<$Res> {
  __$$CheckoutConfirmModelImplCopyWithImpl(
    _$CheckoutConfirmModelImpl _value,
    $Res Function(_$CheckoutConfirmModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CheckoutConfirmModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? termsOfServiceOnOrderConfirmPage = freezed,
    Object? minOrderTotalWarning = freezed,
    Object? warnings = freezed,
    Object? orderReviewData = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$CheckoutConfirmModelImpl(
        termsOfServiceOnOrderConfirmPage:
            freezed == termsOfServiceOnOrderConfirmPage
                ? _value.termsOfServiceOnOrderConfirmPage
                : termsOfServiceOnOrderConfirmPage // ignore: cast_nullable_to_non_nullable
                    as bool?,
        minOrderTotalWarning:
            freezed == minOrderTotalWarning
                ? _value.minOrderTotalWarning
                : minOrderTotalWarning // ignore: cast_nullable_to_non_nullable
                    as String?,
        warnings:
            freezed == warnings
                ? _value._warnings
                : warnings // ignore: cast_nullable_to_non_nullable
                    as List<String>?,
        orderReviewData:
            freezed == orderReviewData
                ? _value.orderReviewData
                : orderReviewData // ignore: cast_nullable_to_non_nullable
                    as OrderReviewDataModel?,
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
class _$CheckoutConfirmModelImpl implements _CheckoutConfirmModel {
  _$CheckoutConfirmModelImpl({
    @JsonKey(name: 'TermsOfServiceOnOrderConfirmPage', includeIfNull: false)
    this.termsOfServiceOnOrderConfirmPage = false,
    @JsonKey(name: 'MinOrderTotalWarning', includeIfNull: false)
    this.minOrderTotalWarning,
    @JsonKey(name: 'Warnings', includeIfNull: false)
    final List<String>? warnings = const [],
    @JsonKey(name: 'OrderReviewData', includeIfNull: false)
    this.orderReviewData,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _warnings = warnings,
       _userFields = userFields;

  factory _$CheckoutConfirmModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CheckoutConfirmModelImplFromJson(json);

  @override
  @JsonKey(name: 'TermsOfServiceOnOrderConfirmPage', includeIfNull: false)
  final bool? termsOfServiceOnOrderConfirmPage;
  @override
  @JsonKey(name: 'MinOrderTotalWarning', includeIfNull: false)
  final String? minOrderTotalWarning;
  final List<String>? _warnings;
  @override
  @JsonKey(name: 'Warnings', includeIfNull: false)
  List<String>? get warnings {
    final value = _warnings;
    if (value == null) return null;
    if (_warnings is EqualUnmodifiableListView) return _warnings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'OrderReviewData', includeIfNull: false)
  final OrderReviewDataModel? orderReviewData;
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
    return 'CheckoutConfirmModel(termsOfServiceOnOrderConfirmPage: $termsOfServiceOnOrderConfirmPage, minOrderTotalWarning: $minOrderTotalWarning, warnings: $warnings, orderReviewData: $orderReviewData, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CheckoutConfirmModelImpl &&
            (identical(
                  other.termsOfServiceOnOrderConfirmPage,
                  termsOfServiceOnOrderConfirmPage,
                ) ||
                other.termsOfServiceOnOrderConfirmPage ==
                    termsOfServiceOnOrderConfirmPage) &&
            (identical(other.minOrderTotalWarning, minOrderTotalWarning) ||
                other.minOrderTotalWarning == minOrderTotalWarning) &&
            const DeepCollectionEquality().equals(other._warnings, _warnings) &&
            (identical(other.orderReviewData, orderReviewData) ||
                other.orderReviewData == orderReviewData) &&
            const DeepCollectionEquality().equals(
              other._userFields,
              _userFields,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    termsOfServiceOnOrderConfirmPage,
    minOrderTotalWarning,
    const DeepCollectionEquality().hash(_warnings),
    orderReviewData,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of CheckoutConfirmModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CheckoutConfirmModelImplCopyWith<_$CheckoutConfirmModelImpl>
  get copyWith =>
      __$$CheckoutConfirmModelImplCopyWithImpl<_$CheckoutConfirmModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CheckoutConfirmModelImplToJson(this);
  }
}

abstract class _CheckoutConfirmModel implements CheckoutConfirmModel {
  factory _CheckoutConfirmModel({
    @JsonKey(name: 'TermsOfServiceOnOrderConfirmPage', includeIfNull: false)
    final bool? termsOfServiceOnOrderConfirmPage,
    @JsonKey(name: 'MinOrderTotalWarning', includeIfNull: false)
    final String? minOrderTotalWarning,
    @JsonKey(name: 'Warnings', includeIfNull: false)
    final List<String>? warnings,
    @JsonKey(name: 'OrderReviewData', includeIfNull: false)
    final OrderReviewDataModel? orderReviewData,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$CheckoutConfirmModelImpl;

  factory _CheckoutConfirmModel.fromJson(Map<String, dynamic> json) =
      _$CheckoutConfirmModelImpl.fromJson;

  @override
  @JsonKey(name: 'TermsOfServiceOnOrderConfirmPage', includeIfNull: false)
  bool? get termsOfServiceOnOrderConfirmPage;
  @override
  @JsonKey(name: 'MinOrderTotalWarning', includeIfNull: false)
  String? get minOrderTotalWarning;
  @override
  @JsonKey(name: 'Warnings', includeIfNull: false)
  List<String>? get warnings;
  @override
  @JsonKey(name: 'OrderReviewData', includeIfNull: false)
  OrderReviewDataModel? get orderReviewData;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of CheckoutConfirmModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CheckoutConfirmModelImplCopyWith<_$CheckoutConfirmModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
