// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'page_screen_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$PageScreenViewModel {
  String? get pageId => throw _privateConstructorUsedError;
  String? get pageTitle => throw _privateConstructorUsedError;
  String? get pageContent => throw _privateConstructorUsedError;
  DateTime? get lastUpdated => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;

  /// Create a copy of PageScreenViewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PageScreenViewModelCopyWith<PageScreenViewModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PageScreenViewModelCopyWith<$Res> {
  factory $PageScreenViewModelCopyWith(
    PageScreenViewModel value,
    $Res Function(PageScreenViewModel) then,
  ) = _$PageScreenViewModelCopyWithImpl<$Res, PageScreenViewModel>;
  @useResult
  $Res call({
    String? pageId,
    String? pageTitle,
    String? pageContent,
    DateTime? lastUpdated,
    bool isLoading,
  });
}

/// @nodoc
class _$PageScreenViewModelCopyWithImpl<$Res, $Val extends PageScreenViewModel>
    implements $PageScreenViewModelCopyWith<$Res> {
  _$PageScreenViewModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PageScreenViewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pageId = freezed,
    Object? pageTitle = freezed,
    Object? pageContent = freezed,
    Object? lastUpdated = freezed,
    Object? isLoading = null,
  }) {
    return _then(
      _value.copyWith(
            pageId:
                freezed == pageId
                    ? _value.pageId
                    : pageId // ignore: cast_nullable_to_non_nullable
                        as String?,
            pageTitle:
                freezed == pageTitle
                    ? _value.pageTitle
                    : pageTitle // ignore: cast_nullable_to_non_nullable
                        as String?,
            pageContent:
                freezed == pageContent
                    ? _value.pageContent
                    : pageContent // ignore: cast_nullable_to_non_nullable
                        as String?,
            lastUpdated:
                freezed == lastUpdated
                    ? _value.lastUpdated
                    : lastUpdated // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            isLoading:
                null == isLoading
                    ? _value.isLoading
                    : isLoading // ignore: cast_nullable_to_non_nullable
                        as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PageScreenViewModelImplCopyWith<$Res>
    implements $PageScreenViewModelCopyWith<$Res> {
  factory _$$PageScreenViewModelImplCopyWith(
    _$PageScreenViewModelImpl value,
    $Res Function(_$PageScreenViewModelImpl) then,
  ) = __$$PageScreenViewModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? pageId,
    String? pageTitle,
    String? pageContent,
    DateTime? lastUpdated,
    bool isLoading,
  });
}

/// @nodoc
class __$$PageScreenViewModelImplCopyWithImpl<$Res>
    extends _$PageScreenViewModelCopyWithImpl<$Res, _$PageScreenViewModelImpl>
    implements _$$PageScreenViewModelImplCopyWith<$Res> {
  __$$PageScreenViewModelImplCopyWithImpl(
    _$PageScreenViewModelImpl _value,
    $Res Function(_$PageScreenViewModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PageScreenViewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pageId = freezed,
    Object? pageTitle = freezed,
    Object? pageContent = freezed,
    Object? lastUpdated = freezed,
    Object? isLoading = null,
  }) {
    return _then(
      _$PageScreenViewModelImpl(
        pageId:
            freezed == pageId
                ? _value.pageId
                : pageId // ignore: cast_nullable_to_non_nullable
                    as String?,
        pageTitle:
            freezed == pageTitle
                ? _value.pageTitle
                : pageTitle // ignore: cast_nullable_to_non_nullable
                    as String?,
        pageContent:
            freezed == pageContent
                ? _value.pageContent
                : pageContent // ignore: cast_nullable_to_non_nullable
                    as String?,
        lastUpdated:
            freezed == lastUpdated
                ? _value.lastUpdated
                : lastUpdated // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        isLoading:
            null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                    as bool,
      ),
    );
  }
}

/// @nodoc

class _$PageScreenViewModelImpl implements _PageScreenViewModel {
  const _$PageScreenViewModelImpl({
    this.pageId,
    this.pageTitle,
    this.pageContent,
    this.lastUpdated,
    this.isLoading = false,
  });

  @override
  final String? pageId;
  @override
  final String? pageTitle;
  @override
  final String? pageContent;
  @override
  final DateTime? lastUpdated;
  @override
  @JsonKey()
  final bool isLoading;

  @override
  String toString() {
    return 'PageScreenViewModel(pageId: $pageId, pageTitle: $pageTitle, pageContent: $pageContent, lastUpdated: $lastUpdated, isLoading: $isLoading)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PageScreenViewModelImpl &&
            (identical(other.pageId, pageId) || other.pageId == pageId) &&
            (identical(other.pageTitle, pageTitle) ||
                other.pageTitle == pageTitle) &&
            (identical(other.pageContent, pageContent) ||
                other.pageContent == pageContent) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    pageId,
    pageTitle,
    pageContent,
    lastUpdated,
    isLoading,
  );

  /// Create a copy of PageScreenViewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PageScreenViewModelImplCopyWith<_$PageScreenViewModelImpl> get copyWith =>
      __$$PageScreenViewModelImplCopyWithImpl<_$PageScreenViewModelImpl>(
        this,
        _$identity,
      );
}

abstract class _PageScreenViewModel implements PageScreenViewModel {
  const factory _PageScreenViewModel({
    final String? pageId,
    final String? pageTitle,
    final String? pageContent,
    final DateTime? lastUpdated,
    final bool isLoading,
  }) = _$PageScreenViewModelImpl;

  @override
  String? get pageId;
  @override
  String? get pageTitle;
  @override
  String? get pageContent;
  @override
  DateTime? get lastUpdated;
  @override
  bool get isLoading;

  /// Create a copy of PageScreenViewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PageScreenViewModelImplCopyWith<_$PageScreenViewModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
