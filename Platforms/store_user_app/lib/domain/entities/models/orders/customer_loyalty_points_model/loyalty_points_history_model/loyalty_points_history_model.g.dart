// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loyalty_points_history_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LoyaltyPointsHistoryModelImpl _$$LoyaltyPointsHistoryModelImplFromJson(
  Map<String, dynamic> json,
) => _$LoyaltyPointsHistoryModelImpl(
  points: (json['Points'] as num?)?.toInt(),
  pointsBalance: (json['PointsBalance'] as num?)?.toInt(),
  message: json['Message'] as String?,
  createdOn:
      json['CreatedOn'] == null
          ? null
          : DateTime.parse(json['CreatedOn'] as String),
  id: json['Id'] as String?,
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$LoyaltyPointsHistoryModelImplToJson(
  _$LoyaltyPointsHistoryModelImpl instance,
) => <String, dynamic>{
  if (instance.points case final value?) 'Points': value,
  if (instance.pointsBalance case final value?) 'PointsBalance': value,
  if (instance.message case final value?) 'Message': value,
  if (instance.createdOn?.toIso8601String() case final value?)
    'CreatedOn': value,
  if (instance.id case final value?) 'Id': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
