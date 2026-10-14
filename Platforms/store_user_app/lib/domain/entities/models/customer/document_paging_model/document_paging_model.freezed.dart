// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'document_paging_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DocumentPagingModel _$DocumentPagingModelFromJson(Map<String, dynamic> json) {
  return _DocumentPagingModel.fromJson(json);
}

/// @nodoc
mixin _$DocumentPagingModel {
  @JsonKey(name: 'FirstItem', includeIfNull: false)
  int? get firstItem => throw _privateConstructorUsedError;
  @JsonKey(name: 'HasNextPage', includeIfNull: false)
  bool? get hasNextPage => throw _privateConstructorUsedError;
  @JsonKey(name: 'HasPreviousPage', includeIfNull: false)
  bool? get hasPreviousPage => throw _privateConstructorUsedError;
  @JsonKey(name: 'LastItem', includeIfNull: false)
  int? get lastItem => throw _privateConstructorUsedError;
  @JsonKey(name: 'PageIndex', includeIfNull: false)
  int? get pageIndex => throw _privateConstructorUsedError;
  @JsonKey(name: 'PageNumber', includeIfNull: false)
  int? get pageNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'PageSize', includeIfNull: false)
  int? get pageSize => throw _privateConstructorUsedError;
  @JsonKey(name: 'TotalItems', includeIfNull: false)
  int? get totalItems => throw _privateConstructorUsedError;
  @JsonKey(name: 'TotalPages', includeIfNull: false)
  int? get totalPages => throw _privateConstructorUsedError;

  /// Serializes this DocumentPagingModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DocumentPagingModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DocumentPagingModelCopyWith<DocumentPagingModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DocumentPagingModelCopyWith<$Res> {
  factory $DocumentPagingModelCopyWith(
    DocumentPagingModel value,
    $Res Function(DocumentPagingModel) then,
  ) = _$DocumentPagingModelCopyWithImpl<$Res, DocumentPagingModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'FirstItem', includeIfNull: false) int? firstItem,
    @JsonKey(name: 'HasNextPage', includeIfNull: false) bool? hasNextPage,
    @JsonKey(name: 'HasPreviousPage', includeIfNull: false)
    bool? hasPreviousPage,
    @JsonKey(name: 'LastItem', includeIfNull: false) int? lastItem,
    @JsonKey(name: 'PageIndex', includeIfNull: false) int? pageIndex,
    @JsonKey(name: 'PageNumber', includeIfNull: false) int? pageNumber,
    @JsonKey(name: 'PageSize', includeIfNull: false) int? pageSize,
    @JsonKey(name: 'TotalItems', includeIfNull: false) int? totalItems,
    @JsonKey(name: 'TotalPages', includeIfNull: false) int? totalPages,
  });
}

/// @nodoc
class _$DocumentPagingModelCopyWithImpl<$Res, $Val extends DocumentPagingModel>
    implements $DocumentPagingModelCopyWith<$Res> {
  _$DocumentPagingModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DocumentPagingModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firstItem = freezed,
    Object? hasNextPage = freezed,
    Object? hasPreviousPage = freezed,
    Object? lastItem = freezed,
    Object? pageIndex = freezed,
    Object? pageNumber = freezed,
    Object? pageSize = freezed,
    Object? totalItems = freezed,
    Object? totalPages = freezed,
  }) {
    return _then(
      _value.copyWith(
            firstItem:
                freezed == firstItem
                    ? _value.firstItem
                    : firstItem // ignore: cast_nullable_to_non_nullable
                        as int?,
            hasNextPage:
                freezed == hasNextPage
                    ? _value.hasNextPage
                    : hasNextPage // ignore: cast_nullable_to_non_nullable
                        as bool?,
            hasPreviousPage:
                freezed == hasPreviousPage
                    ? _value.hasPreviousPage
                    : hasPreviousPage // ignore: cast_nullable_to_non_nullable
                        as bool?,
            lastItem:
                freezed == lastItem
                    ? _value.lastItem
                    : lastItem // ignore: cast_nullable_to_non_nullable
                        as int?,
            pageIndex:
                freezed == pageIndex
                    ? _value.pageIndex
                    : pageIndex // ignore: cast_nullable_to_non_nullable
                        as int?,
            pageNumber:
                freezed == pageNumber
                    ? _value.pageNumber
                    : pageNumber // ignore: cast_nullable_to_non_nullable
                        as int?,
            pageSize:
                freezed == pageSize
                    ? _value.pageSize
                    : pageSize // ignore: cast_nullable_to_non_nullable
                        as int?,
            totalItems:
                freezed == totalItems
                    ? _value.totalItems
                    : totalItems // ignore: cast_nullable_to_non_nullable
                        as int?,
            totalPages:
                freezed == totalPages
                    ? _value.totalPages
                    : totalPages // ignore: cast_nullable_to_non_nullable
                        as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DocumentPagingModelImplCopyWith<$Res>
    implements $DocumentPagingModelCopyWith<$Res> {
  factory _$$DocumentPagingModelImplCopyWith(
    _$DocumentPagingModelImpl value,
    $Res Function(_$DocumentPagingModelImpl) then,
  ) = __$$DocumentPagingModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'FirstItem', includeIfNull: false) int? firstItem,
    @JsonKey(name: 'HasNextPage', includeIfNull: false) bool? hasNextPage,
    @JsonKey(name: 'HasPreviousPage', includeIfNull: false)
    bool? hasPreviousPage,
    @JsonKey(name: 'LastItem', includeIfNull: false) int? lastItem,
    @JsonKey(name: 'PageIndex', includeIfNull: false) int? pageIndex,
    @JsonKey(name: 'PageNumber', includeIfNull: false) int? pageNumber,
    @JsonKey(name: 'PageSize', includeIfNull: false) int? pageSize,
    @JsonKey(name: 'TotalItems', includeIfNull: false) int? totalItems,
    @JsonKey(name: 'TotalPages', includeIfNull: false) int? totalPages,
  });
}

/// @nodoc
class __$$DocumentPagingModelImplCopyWithImpl<$Res>
    extends _$DocumentPagingModelCopyWithImpl<$Res, _$DocumentPagingModelImpl>
    implements _$$DocumentPagingModelImplCopyWith<$Res> {
  __$$DocumentPagingModelImplCopyWithImpl(
    _$DocumentPagingModelImpl _value,
    $Res Function(_$DocumentPagingModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DocumentPagingModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firstItem = freezed,
    Object? hasNextPage = freezed,
    Object? hasPreviousPage = freezed,
    Object? lastItem = freezed,
    Object? pageIndex = freezed,
    Object? pageNumber = freezed,
    Object? pageSize = freezed,
    Object? totalItems = freezed,
    Object? totalPages = freezed,
  }) {
    return _then(
      _$DocumentPagingModelImpl(
        firstItem:
            freezed == firstItem
                ? _value.firstItem
                : firstItem // ignore: cast_nullable_to_non_nullable
                    as int?,
        hasNextPage:
            freezed == hasNextPage
                ? _value.hasNextPage
                : hasNextPage // ignore: cast_nullable_to_non_nullable
                    as bool?,
        hasPreviousPage:
            freezed == hasPreviousPage
                ? _value.hasPreviousPage
                : hasPreviousPage // ignore: cast_nullable_to_non_nullable
                    as bool?,
        lastItem:
            freezed == lastItem
                ? _value.lastItem
                : lastItem // ignore: cast_nullable_to_non_nullable
                    as int?,
        pageIndex:
            freezed == pageIndex
                ? _value.pageIndex
                : pageIndex // ignore: cast_nullable_to_non_nullable
                    as int?,
        pageNumber:
            freezed == pageNumber
                ? _value.pageNumber
                : pageNumber // ignore: cast_nullable_to_non_nullable
                    as int?,
        pageSize:
            freezed == pageSize
                ? _value.pageSize
                : pageSize // ignore: cast_nullable_to_non_nullable
                    as int?,
        totalItems:
            freezed == totalItems
                ? _value.totalItems
                : totalItems // ignore: cast_nullable_to_non_nullable
                    as int?,
        totalPages:
            freezed == totalPages
                ? _value.totalPages
                : totalPages // ignore: cast_nullable_to_non_nullable
                    as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DocumentPagingModelImpl implements _DocumentPagingModel {
  _$DocumentPagingModelImpl({
    @JsonKey(name: 'FirstItem', includeIfNull: false) this.firstItem,
    @JsonKey(name: 'HasNextPage', includeIfNull: false)
    this.hasNextPage = false,
    @JsonKey(name: 'HasPreviousPage', includeIfNull: false)
    this.hasPreviousPage = false,
    @JsonKey(name: 'LastItem', includeIfNull: false) this.lastItem,
    @JsonKey(name: 'PageIndex', includeIfNull: false) this.pageIndex,
    @JsonKey(name: 'PageNumber', includeIfNull: false) this.pageNumber,
    @JsonKey(name: 'PageSize', includeIfNull: false) this.pageSize,
    @JsonKey(name: 'TotalItems', includeIfNull: false) this.totalItems,
    @JsonKey(name: 'TotalPages', includeIfNull: false) this.totalPages,
  });

  factory _$DocumentPagingModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DocumentPagingModelImplFromJson(json);

  @override
  @JsonKey(name: 'FirstItem', includeIfNull: false)
  final int? firstItem;
  @override
  @JsonKey(name: 'HasNextPage', includeIfNull: false)
  final bool? hasNextPage;
  @override
  @JsonKey(name: 'HasPreviousPage', includeIfNull: false)
  final bool? hasPreviousPage;
  @override
  @JsonKey(name: 'LastItem', includeIfNull: false)
  final int? lastItem;
  @override
  @JsonKey(name: 'PageIndex', includeIfNull: false)
  final int? pageIndex;
  @override
  @JsonKey(name: 'PageNumber', includeIfNull: false)
  final int? pageNumber;
  @override
  @JsonKey(name: 'PageSize', includeIfNull: false)
  final int? pageSize;
  @override
  @JsonKey(name: 'TotalItems', includeIfNull: false)
  final int? totalItems;
  @override
  @JsonKey(name: 'TotalPages', includeIfNull: false)
  final int? totalPages;

  @override
  String toString() {
    return 'DocumentPagingModel(firstItem: $firstItem, hasNextPage: $hasNextPage, hasPreviousPage: $hasPreviousPage, lastItem: $lastItem, pageIndex: $pageIndex, pageNumber: $pageNumber, pageSize: $pageSize, totalItems: $totalItems, totalPages: $totalPages)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DocumentPagingModelImpl &&
            (identical(other.firstItem, firstItem) ||
                other.firstItem == firstItem) &&
            (identical(other.hasNextPage, hasNextPage) ||
                other.hasNextPage == hasNextPage) &&
            (identical(other.hasPreviousPage, hasPreviousPage) ||
                other.hasPreviousPage == hasPreviousPage) &&
            (identical(other.lastItem, lastItem) ||
                other.lastItem == lastItem) &&
            (identical(other.pageIndex, pageIndex) ||
                other.pageIndex == pageIndex) &&
            (identical(other.pageNumber, pageNumber) ||
                other.pageNumber == pageNumber) &&
            (identical(other.pageSize, pageSize) ||
                other.pageSize == pageSize) &&
            (identical(other.totalItems, totalItems) ||
                other.totalItems == totalItems) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    firstItem,
    hasNextPage,
    hasPreviousPage,
    lastItem,
    pageIndex,
    pageNumber,
    pageSize,
    totalItems,
    totalPages,
  );

  /// Create a copy of DocumentPagingModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DocumentPagingModelImplCopyWith<_$DocumentPagingModelImpl> get copyWith =>
      __$$DocumentPagingModelImplCopyWithImpl<_$DocumentPagingModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DocumentPagingModelImplToJson(this);
  }
}

abstract class _DocumentPagingModel implements DocumentPagingModel {
  factory _DocumentPagingModel({
    @JsonKey(name: 'FirstItem', includeIfNull: false) final int? firstItem,
    @JsonKey(name: 'HasNextPage', includeIfNull: false) final bool? hasNextPage,
    @JsonKey(name: 'HasPreviousPage', includeIfNull: false)
    final bool? hasPreviousPage,
    @JsonKey(name: 'LastItem', includeIfNull: false) final int? lastItem,
    @JsonKey(name: 'PageIndex', includeIfNull: false) final int? pageIndex,
    @JsonKey(name: 'PageNumber', includeIfNull: false) final int? pageNumber,
    @JsonKey(name: 'PageSize', includeIfNull: false) final int? pageSize,
    @JsonKey(name: 'TotalItems', includeIfNull: false) final int? totalItems,
    @JsonKey(name: 'TotalPages', includeIfNull: false) final int? totalPages,
  }) = _$DocumentPagingModelImpl;

  factory _DocumentPagingModel.fromJson(Map<String, dynamic> json) =
      _$DocumentPagingModelImpl.fromJson;

  @override
  @JsonKey(name: 'FirstItem', includeIfNull: false)
  int? get firstItem;
  @override
  @JsonKey(name: 'HasNextPage', includeIfNull: false)
  bool? get hasNextPage;
  @override
  @JsonKey(name: 'HasPreviousPage', includeIfNull: false)
  bool? get hasPreviousPage;
  @override
  @JsonKey(name: 'LastItem', includeIfNull: false)
  int? get lastItem;
  @override
  @JsonKey(name: 'PageIndex', includeIfNull: false)
  int? get pageIndex;
  @override
  @JsonKey(name: 'PageNumber', includeIfNull: false)
  int? get pageNumber;
  @override
  @JsonKey(name: 'PageSize', includeIfNull: false)
  int? get pageSize;
  @override
  @JsonKey(name: 'TotalItems', includeIfNull: false)
  int? get totalItems;
  @override
  @JsonKey(name: 'TotalPages', includeIfNull: false)
  int? get totalPages;

  /// Create a copy of DocumentPagingModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DocumentPagingModelImplCopyWith<_$DocumentPagingModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
