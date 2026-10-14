// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_page_category_item_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$HomePageCategoryItemViewModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get imageUrl => throw _privateConstructorUsedError;

  /// Create a copy of HomePageCategoryItemViewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HomePageCategoryItemViewModelCopyWith<HomePageCategoryItemViewModel>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomePageCategoryItemViewModelCopyWith<$Res> {
  factory $HomePageCategoryItemViewModelCopyWith(
    HomePageCategoryItemViewModel value,
    $Res Function(HomePageCategoryItemViewModel) then,
  ) =
      _$HomePageCategoryItemViewModelCopyWithImpl<
        $Res,
        HomePageCategoryItemViewModel
      >;
  @useResult
  $Res call({String id, String name, String imageUrl});
}

/// @nodoc
class _$HomePageCategoryItemViewModelCopyWithImpl<
  $Res,
  $Val extends HomePageCategoryItemViewModel
>
    implements $HomePageCategoryItemViewModelCopyWith<$Res> {
  _$HomePageCategoryItemViewModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HomePageCategoryItemViewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null, Object? imageUrl = null}) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            name:
                null == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
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
abstract class _$$HomePageCategoryItemViewModelImplCopyWith<$Res>
    implements $HomePageCategoryItemViewModelCopyWith<$Res> {
  factory _$$HomePageCategoryItemViewModelImplCopyWith(
    _$HomePageCategoryItemViewModelImpl value,
    $Res Function(_$HomePageCategoryItemViewModelImpl) then,
  ) = __$$HomePageCategoryItemViewModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, String imageUrl});
}

/// @nodoc
class __$$HomePageCategoryItemViewModelImplCopyWithImpl<$Res>
    extends
        _$HomePageCategoryItemViewModelCopyWithImpl<
          $Res,
          _$HomePageCategoryItemViewModelImpl
        >
    implements _$$HomePageCategoryItemViewModelImplCopyWith<$Res> {
  __$$HomePageCategoryItemViewModelImplCopyWithImpl(
    _$HomePageCategoryItemViewModelImpl _value,
    $Res Function(_$HomePageCategoryItemViewModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HomePageCategoryItemViewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null, Object? imageUrl = null}) {
    return _then(
      _$HomePageCategoryItemViewModelImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        name:
            null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
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

class _$HomePageCategoryItemViewModelImpl
    implements _HomePageCategoryItemViewModel {
  const _$HomePageCategoryItemViewModelImpl({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  @override
  final String id;
  @override
  final String name;
  @override
  final String imageUrl;

  @override
  String toString() {
    return 'HomePageCategoryItemViewModel(id: $id, name: $name, imageUrl: $imageUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomePageCategoryItemViewModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, name, imageUrl);

  /// Create a copy of HomePageCategoryItemViewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HomePageCategoryItemViewModelImplCopyWith<
    _$HomePageCategoryItemViewModelImpl
  >
  get copyWith => __$$HomePageCategoryItemViewModelImplCopyWithImpl<
    _$HomePageCategoryItemViewModelImpl
  >(this, _$identity);
}

abstract class _HomePageCategoryItemViewModel
    implements HomePageCategoryItemViewModel {
  const factory _HomePageCategoryItemViewModel({
    required final String id,
    required final String name,
    required final String imageUrl,
  }) = _$HomePageCategoryItemViewModelImpl;

  @override
  String get id;
  @override
  String get name;
  @override
  String get imageUrl;

  /// Create a copy of HomePageCategoryItemViewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HomePageCategoryItemViewModelImplCopyWith<
    _$HomePageCategoryItemViewModelImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}
