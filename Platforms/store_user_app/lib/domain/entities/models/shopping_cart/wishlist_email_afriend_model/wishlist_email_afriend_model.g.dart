// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlist_email_afriend_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WishlistEmailAFriendModelImpl _$$WishlistEmailAFriendModelImplFromJson(
  Map<String, dynamic> json,
) => _$WishlistEmailAFriendModelImpl(
  friendEmail: json['FriendEmail'] as String?,
  yourEmailAddress: json['YourEmailAddress'] as String?,
  personalMessage: json['PersonalMessage'] as String?,
  successfullySent: json['SuccessfullySent'] as bool? ?? false,
  result: json['Result'] as String?,
  displayCaptcha: json['DisplayCaptcha'] as bool? ?? false,
  captcha:
      json['Captcha'] == null
          ? null
          : ICaptchaValidModel.fromJson(
            json['Captcha'] as Map<String, dynamic>,
          ),
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$WishlistEmailAFriendModelImplToJson(
  _$WishlistEmailAFriendModelImpl instance,
) => <String, dynamic>{
  if (instance.friendEmail case final value?) 'FriendEmail': value,
  if (instance.yourEmailAddress case final value?) 'YourEmailAddress': value,
  if (instance.personalMessage case final value?) 'PersonalMessage': value,
  if (instance.successfullySent case final value?) 'SuccessfullySent': value,
  if (instance.result case final value?) 'Result': value,
  if (instance.displayCaptcha case final value?) 'DisplayCaptcha': value,
  if (instance.captcha case final value?) 'Captcha': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
