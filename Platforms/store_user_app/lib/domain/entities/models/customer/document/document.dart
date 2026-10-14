import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../common/user_field/user_field.dart';

part 'document.freezed.dart';
part 'document.g.dart';

@freezed
class Document extends StoreJsonSerializable<Document> with _$Document {
  factory Document(
      {@JsonKey(name: 'Number', includeIfNull: false) String? number,
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
      @JsonKey(name: 'DocDate', includeIfNull: false)
      @Default(null)
      DateTime? docDate,
      @JsonKey(name: 'DueDate', includeIfNull: false)
      @Default(null)
      DateTime? dueDate,
      @JsonKey(name: 'Id', includeIfNull: false) String? id,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _Document;

  factory Document.fromJson(Map<String, dynamic> json) =>
      _$DocumentFromJson(json);
}
