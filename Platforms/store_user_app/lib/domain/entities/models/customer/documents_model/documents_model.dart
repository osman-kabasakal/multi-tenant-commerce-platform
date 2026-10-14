import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../document/document.dart';

import '../document_paging_model/document_paging_model.dart';

import '../../../common/user_field/user_field.dart';

part 'documents_model.freezed.dart';
part 'documents_model.g.dart';

@freezed
class DocumentsModel extends StoreJsonSerializable<DocumentsModel>
    with _$DocumentsModel {
  factory DocumentsModel(
      {@JsonKey(name: 'DocumentList', includeIfNull: false)
      @Default([])
      List<Document>? documentList,
      @JsonKey(name: 'PagingContext', includeIfNull: false)
      DocumentPagingModel? pagingContext,
      @JsonKey(name: 'CustomerId', includeIfNull: false) String? customerId,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _DocumentsModel;

  factory DocumentsModel.fromJson(Map<String, dynamic> json) =>
      _$DocumentsModelFromJson(json);
}
