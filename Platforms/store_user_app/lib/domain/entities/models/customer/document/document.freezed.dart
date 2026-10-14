// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'document.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Document _$DocumentFromJson(Map<String, dynamic> json) {
  return _Document.fromJson(json);
}

/// @nodoc
mixin _$Document {
  @JsonKey(name: 'Number', includeIfNull: false)
  String? get number => throw _privateConstructorUsedError;
  @JsonKey(name: 'Name', includeIfNull: false)
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'Description', includeIfNull: false)
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'DownloadId', includeIfNull: false)
  String? get downloadId => throw _privateConstructorUsedError;
  @JsonKey(name: 'Status', includeIfNull: false)
  String? get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'DocumentType', includeIfNull: false)
  String? get documentType => throw _privateConstructorUsedError;
  @JsonKey(name: 'Link', includeIfNull: false)
  String? get link => throw _privateConstructorUsedError;
  @JsonKey(name: 'Amount', includeIfNull: false)
  double? get amount => throw _privateConstructorUsedError;
  @JsonKey(name: 'OutstandAmount', includeIfNull: false)
  double? get outstandAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'Quantity', includeIfNull: false)
  int? get quantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'DocDate', includeIfNull: false)
  DateTime? get docDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'DueDate', includeIfNull: false)
  DateTime? get dueDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this Document to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Document
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DocumentCopyWith<Document> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DocumentCopyWith<$Res> {
  factory $DocumentCopyWith(Document value, $Res Function(Document) then) =
      _$DocumentCopyWithImpl<$Res, Document>;
  @useResult
  $Res call({
    @JsonKey(name: 'Number', includeIfNull: false) String? number,
    @JsonKey(name: 'Name', includeIfNull: false) String? name,
    @JsonKey(name: 'Description', includeIfNull: false) String? description,
    @JsonKey(name: 'DownloadId', includeIfNull: false) String? downloadId,
    @JsonKey(name: 'Status', includeIfNull: false) String? status,
    @JsonKey(name: 'DocumentType', includeIfNull: false) String? documentType,
    @JsonKey(name: 'Link', includeIfNull: false) String? link,
    @JsonKey(name: 'Amount', includeIfNull: false) double? amount,
    @JsonKey(name: 'OutstandAmount', includeIfNull: false)
    double? outstandAmount,
    @JsonKey(name: 'Quantity', includeIfNull: false) int? quantity,
    @JsonKey(name: 'DocDate', includeIfNull: false) DateTime? docDate,
    @JsonKey(name: 'DueDate', includeIfNull: false) DateTime? dueDate,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$DocumentCopyWithImpl<$Res, $Val extends Document>
    implements $DocumentCopyWith<$Res> {
  _$DocumentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Document
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? number = freezed,
    Object? name = freezed,
    Object? description = freezed,
    Object? downloadId = freezed,
    Object? status = freezed,
    Object? documentType = freezed,
    Object? link = freezed,
    Object? amount = freezed,
    Object? outstandAmount = freezed,
    Object? quantity = freezed,
    Object? docDate = freezed,
    Object? dueDate = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            number:
                freezed == number
                    ? _value.number
                    : number // ignore: cast_nullable_to_non_nullable
                        as String?,
            name:
                freezed == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String?,
            description:
                freezed == description
                    ? _value.description
                    : description // ignore: cast_nullable_to_non_nullable
                        as String?,
            downloadId:
                freezed == downloadId
                    ? _value.downloadId
                    : downloadId // ignore: cast_nullable_to_non_nullable
                        as String?,
            status:
                freezed == status
                    ? _value.status
                    : status // ignore: cast_nullable_to_non_nullable
                        as String?,
            documentType:
                freezed == documentType
                    ? _value.documentType
                    : documentType // ignore: cast_nullable_to_non_nullable
                        as String?,
            link:
                freezed == link
                    ? _value.link
                    : link // ignore: cast_nullable_to_non_nullable
                        as String?,
            amount:
                freezed == amount
                    ? _value.amount
                    : amount // ignore: cast_nullable_to_non_nullable
                        as double?,
            outstandAmount:
                freezed == outstandAmount
                    ? _value.outstandAmount
                    : outstandAmount // ignore: cast_nullable_to_non_nullable
                        as double?,
            quantity:
                freezed == quantity
                    ? _value.quantity
                    : quantity // ignore: cast_nullable_to_non_nullable
                        as int?,
            docDate:
                freezed == docDate
                    ? _value.docDate
                    : docDate // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            dueDate:
                freezed == dueDate
                    ? _value.dueDate
                    : dueDate // ignore: cast_nullable_to_non_nullable
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
abstract class _$$DocumentImplCopyWith<$Res>
    implements $DocumentCopyWith<$Res> {
  factory _$$DocumentImplCopyWith(
    _$DocumentImpl value,
    $Res Function(_$DocumentImpl) then,
  ) = __$$DocumentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'Number', includeIfNull: false) String? number,
    @JsonKey(name: 'Name', includeIfNull: false) String? name,
    @JsonKey(name: 'Description', includeIfNull: false) String? description,
    @JsonKey(name: 'DownloadId', includeIfNull: false) String? downloadId,
    @JsonKey(name: 'Status', includeIfNull: false) String? status,
    @JsonKey(name: 'DocumentType', includeIfNull: false) String? documentType,
    @JsonKey(name: 'Link', includeIfNull: false) String? link,
    @JsonKey(name: 'Amount', includeIfNull: false) double? amount,
    @JsonKey(name: 'OutstandAmount', includeIfNull: false)
    double? outstandAmount,
    @JsonKey(name: 'Quantity', includeIfNull: false) int? quantity,
    @JsonKey(name: 'DocDate', includeIfNull: false) DateTime? docDate,
    @JsonKey(name: 'DueDate', includeIfNull: false) DateTime? dueDate,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$DocumentImplCopyWithImpl<$Res>
    extends _$DocumentCopyWithImpl<$Res, _$DocumentImpl>
    implements _$$DocumentImplCopyWith<$Res> {
  __$$DocumentImplCopyWithImpl(
    _$DocumentImpl _value,
    $Res Function(_$DocumentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Document
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? number = freezed,
    Object? name = freezed,
    Object? description = freezed,
    Object? downloadId = freezed,
    Object? status = freezed,
    Object? documentType = freezed,
    Object? link = freezed,
    Object? amount = freezed,
    Object? outstandAmount = freezed,
    Object? quantity = freezed,
    Object? docDate = freezed,
    Object? dueDate = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$DocumentImpl(
        number:
            freezed == number
                ? _value.number
                : number // ignore: cast_nullable_to_non_nullable
                    as String?,
        name:
            freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String?,
        description:
            freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                    as String?,
        downloadId:
            freezed == downloadId
                ? _value.downloadId
                : downloadId // ignore: cast_nullable_to_non_nullable
                    as String?,
        status:
            freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                    as String?,
        documentType:
            freezed == documentType
                ? _value.documentType
                : documentType // ignore: cast_nullable_to_non_nullable
                    as String?,
        link:
            freezed == link
                ? _value.link
                : link // ignore: cast_nullable_to_non_nullable
                    as String?,
        amount:
            freezed == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                    as double?,
        outstandAmount:
            freezed == outstandAmount
                ? _value.outstandAmount
                : outstandAmount // ignore: cast_nullable_to_non_nullable
                    as double?,
        quantity:
            freezed == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                    as int?,
        docDate:
            freezed == docDate
                ? _value.docDate
                : docDate // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        dueDate:
            freezed == dueDate
                ? _value.dueDate
                : dueDate // ignore: cast_nullable_to_non_nullable
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
class _$DocumentImpl implements _Document {
  _$DocumentImpl({
    @JsonKey(name: 'Number', includeIfNull: false) this.number,
    @JsonKey(name: 'Name', includeIfNull: false) this.name,
    @JsonKey(name: 'Description', includeIfNull: false) this.description,
    @JsonKey(name: 'DownloadId', includeIfNull: false) this.downloadId,
    @JsonKey(name: 'Status', includeIfNull: false) this.status,
    @JsonKey(name: 'DocumentType', includeIfNull: false) this.documentType,
    @JsonKey(name: 'Link', includeIfNull: false) this.link,
    @JsonKey(name: 'Amount', includeIfNull: false) this.amount,
    @JsonKey(name: 'OutstandAmount', includeIfNull: false) this.outstandAmount,
    @JsonKey(name: 'Quantity', includeIfNull: false) this.quantity,
    @JsonKey(name: 'DocDate', includeIfNull: false) this.docDate = null,
    @JsonKey(name: 'DueDate', includeIfNull: false) this.dueDate = null,
    @JsonKey(name: 'Id', includeIfNull: false) this.id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _userFields = userFields;

  factory _$DocumentImpl.fromJson(Map<String, dynamic> json) =>
      _$$DocumentImplFromJson(json);

  @override
  @JsonKey(name: 'Number', includeIfNull: false)
  final String? number;
  @override
  @JsonKey(name: 'Name', includeIfNull: false)
  final String? name;
  @override
  @JsonKey(name: 'Description', includeIfNull: false)
  final String? description;
  @override
  @JsonKey(name: 'DownloadId', includeIfNull: false)
  final String? downloadId;
  @override
  @JsonKey(name: 'Status', includeIfNull: false)
  final String? status;
  @override
  @JsonKey(name: 'DocumentType', includeIfNull: false)
  final String? documentType;
  @override
  @JsonKey(name: 'Link', includeIfNull: false)
  final String? link;
  @override
  @JsonKey(name: 'Amount', includeIfNull: false)
  final double? amount;
  @override
  @JsonKey(name: 'OutstandAmount', includeIfNull: false)
  final double? outstandAmount;
  @override
  @JsonKey(name: 'Quantity', includeIfNull: false)
  final int? quantity;
  @override
  @JsonKey(name: 'DocDate', includeIfNull: false)
  final DateTime? docDate;
  @override
  @JsonKey(name: 'DueDate', includeIfNull: false)
  final DateTime? dueDate;
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
    return 'Document(number: $number, name: $name, description: $description, downloadId: $downloadId, status: $status, documentType: $documentType, link: $link, amount: $amount, outstandAmount: $outstandAmount, quantity: $quantity, docDate: $docDate, dueDate: $dueDate, id: $id, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DocumentImpl &&
            (identical(other.number, number) || other.number == number) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.downloadId, downloadId) ||
                other.downloadId == downloadId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.documentType, documentType) ||
                other.documentType == documentType) &&
            (identical(other.link, link) || other.link == link) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.outstandAmount, outstandAmount) ||
                other.outstandAmount == outstandAmount) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.docDate, docDate) || other.docDate == docDate) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
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
    number,
    name,
    description,
    downloadId,
    status,
    documentType,
    link,
    amount,
    outstandAmount,
    quantity,
    docDate,
    dueDate,
    id,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of Document
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DocumentImplCopyWith<_$DocumentImpl> get copyWith =>
      __$$DocumentImplCopyWithImpl<_$DocumentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DocumentImplToJson(this);
  }
}

abstract class _Document implements Document {
  factory _Document({
    @JsonKey(name: 'Number', includeIfNull: false) final String? number,
    @JsonKey(name: 'Name', includeIfNull: false) final String? name,
    @JsonKey(name: 'Description', includeIfNull: false)
    final String? description,
    @JsonKey(name: 'DownloadId', includeIfNull: false) final String? downloadId,
    @JsonKey(name: 'Status', includeIfNull: false) final String? status,
    @JsonKey(name: 'DocumentType', includeIfNull: false)
    final String? documentType,
    @JsonKey(name: 'Link', includeIfNull: false) final String? link,
    @JsonKey(name: 'Amount', includeIfNull: false) final double? amount,
    @JsonKey(name: 'OutstandAmount', includeIfNull: false)
    final double? outstandAmount,
    @JsonKey(name: 'Quantity', includeIfNull: false) final int? quantity,
    @JsonKey(name: 'DocDate', includeIfNull: false) final DateTime? docDate,
    @JsonKey(name: 'DueDate', includeIfNull: false) final DateTime? dueDate,
    @JsonKey(name: 'Id', includeIfNull: false) final String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$DocumentImpl;

  factory _Document.fromJson(Map<String, dynamic> json) =
      _$DocumentImpl.fromJson;

  @override
  @JsonKey(name: 'Number', includeIfNull: false)
  String? get number;
  @override
  @JsonKey(name: 'Name', includeIfNull: false)
  String? get name;
  @override
  @JsonKey(name: 'Description', includeIfNull: false)
  String? get description;
  @override
  @JsonKey(name: 'DownloadId', includeIfNull: false)
  String? get downloadId;
  @override
  @JsonKey(name: 'Status', includeIfNull: false)
  String? get status;
  @override
  @JsonKey(name: 'DocumentType', includeIfNull: false)
  String? get documentType;
  @override
  @JsonKey(name: 'Link', includeIfNull: false)
  String? get link;
  @override
  @JsonKey(name: 'Amount', includeIfNull: false)
  double? get amount;
  @override
  @JsonKey(name: 'OutstandAmount', includeIfNull: false)
  double? get outstandAmount;
  @override
  @JsonKey(name: 'Quantity', includeIfNull: false)
  int? get quantity;
  @override
  @JsonKey(name: 'DocDate', includeIfNull: false)
  DateTime? get docDate;
  @override
  @JsonKey(name: 'DueDate', includeIfNull: false)
  DateTime? get dueDate;
  @override
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of Document
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DocumentImplCopyWith<_$DocumentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
