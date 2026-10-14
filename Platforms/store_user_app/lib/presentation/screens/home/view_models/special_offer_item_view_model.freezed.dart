// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'special_offer_item_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$SpecialOfferItemViewModel {
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get imageUrl => throw _privateConstructorUsedError;

  /// Create a copy of SpecialOfferItemViewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SpecialOfferItemViewModelCopyWith<SpecialOfferItemViewModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpecialOfferItemViewModelCopyWith<$Res> {
  factory $SpecialOfferItemViewModelCopyWith(
    SpecialOfferItemViewModel value,
    $Res Function(SpecialOfferItemViewModel) then,
  ) = _$SpecialOfferItemViewModelCopyWithImpl<$Res, SpecialOfferItemViewModel>;
  @useResult
  $Res call({String title, String description, String imageUrl});
}

/// @nodoc
class _$SpecialOfferItemViewModelCopyWithImpl<
  $Res,
  $Val extends SpecialOfferItemViewModel
>
    implements $SpecialOfferItemViewModelCopyWith<$Res> {
  _$SpecialOfferItemViewModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SpecialOfferItemViewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = null,
    Object? imageUrl = null,
  }) {
    return _then(
      _value.copyWith(
            title:
                null == title
                    ? _value.title
                    : title // ignore: cast_nullable_to_non_nullable
                        as String,
            description:
                null == description
                    ? _value.description
                    : description // ignore: cast_nullable_to_non_nullable
                        as String,
            imageUrl:
                null == imageUrl
                    ? _value.imageUrl
                    : imageUrl // ignore: cast_nullable_to_non_nullable
                        as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SpecialOfferItemViewModelImplCopyWith<$Res>
    implements $SpecialOfferItemViewModelCopyWith<$Res> {
  factory _$$SpecialOfferItemViewModelImplCopyWith(
    _$SpecialOfferItemViewModelImpl value,
    $Res Function(_$SpecialOfferItemViewModelImpl) then,
  ) = __$$SpecialOfferItemViewModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String title, String description, String imageUrl});
}

/// @nodoc
class __$$SpecialOfferItemViewModelImplCopyWithImpl<$Res>
    extends
        _$SpecialOfferItemViewModelCopyWithImpl<
          $Res,
          _$SpecialOfferItemViewModelImpl
        >
    implements _$$SpecialOfferItemViewModelImplCopyWith<$Res> {
  __$$SpecialOfferItemViewModelImplCopyWithImpl(
    _$SpecialOfferItemViewModelImpl _value,
    $Res Function(_$SpecialOfferItemViewModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SpecialOfferItemViewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = null,
    Object? imageUrl = null,
  }) {
    return _then(
      _$SpecialOfferItemViewModelImpl(
        title:
            null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                    as String,
        description:
            null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                    as String,
        imageUrl:
            null == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                    as String,
      ),
    );
  }
}

/// @nodoc

class _$SpecialOfferItemViewModelImpl implements _SpecialOfferItemViewModel {
  const _$SpecialOfferItemViewModelImpl({
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  @override
  final String title;
  @override
  final String description;
  @override
  final String imageUrl;

  @override
  String toString() {
    return 'SpecialOfferItemViewModel(title: $title, description: $description, imageUrl: $imageUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpecialOfferItemViewModelImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl));
  }

  @override
  int get hashCode => Object.hash(runtimeType, title, description, imageUrl);

  /// Create a copy of SpecialOfferItemViewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SpecialOfferItemViewModelImplCopyWith<_$SpecialOfferItemViewModelImpl>
  get copyWith => __$$SpecialOfferItemViewModelImplCopyWithImpl<
    _$SpecialOfferItemViewModelImpl
  >(this, _$identity);
}

abstract class _SpecialOfferItemViewModel implements SpecialOfferItemViewModel {
  const factory _SpecialOfferItemViewModel({
    required final String title,
    required final String description,
    required final String imageUrl,
  }) = _$SpecialOfferItemViewModelImpl;

  @override
  String get title;
  @override
  String get description;
  @override
  String get imageUrl;

  /// Create a copy of SpecialOfferItemViewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SpecialOfferItemViewModelImplCopyWith<_$SpecialOfferItemViewModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
