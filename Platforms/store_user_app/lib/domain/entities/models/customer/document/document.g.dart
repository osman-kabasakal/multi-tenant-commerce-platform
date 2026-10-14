// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DocumentImpl _$$DocumentImplFromJson(Map<String, dynamic> json) =>
    _$DocumentImpl(
      number: json['Number'] as String?,
      name: json['Name'] as String?,
      description: json['Description'] as String?,
      downloadId: json['DownloadId'] as String?,
      status: json['Status'] as String?,
      documentType: json['DocumentType'] as String?,
      link: json['Link'] as String?,
      amount: (json['Amount'] as num?)?.toDouble(),
      outstandAmount: (json['OutstandAmount'] as num?)?.toDouble(),
      quantity: (json['Quantity'] as num?)?.toInt(),
      docDate:
          json['DocDate'] == null
              ? null
              : DateTime.parse(json['DocDate'] as String),
      dueDate:
          json['DueDate'] == null
              ? null
              : DateTime.parse(json['DueDate'] as String),
      id: json['Id'] as String?,
      userFields:
          (json['UserFields'] as List<dynamic>?)
              ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$DocumentImplToJson(
  _$DocumentImpl instance,
) => <String, dynamic>{
  if (instance.number case final value?) 'Number': value,
  if (instance.name case final value?) 'Name': value,
  if (instance.description case final value?) 'Description': value,
  if (instance.downloadId case final value?) 'DownloadId': value,
  if (instance.status case final value?) 'Status': value,
  if (instance.documentType case final value?) 'DocumentType': value,
  if (instance.link case final value?) 'Link': value,
  if (instance.amount case final value?) 'Amount': value,
  if (instance.outstandAmount case final value?) 'OutstandAmount': value,
  if (instance.quantity case final value?) 'Quantity': value,
  if (instance.docDate?.toIso8601String() case final value?) 'DocDate': value,
  if (instance.dueDate?.toIso8601String() case final value?) 'DueDate': value,
  if (instance.id case final value?) 'Id': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
