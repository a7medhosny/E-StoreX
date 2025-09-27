// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_profile_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateProfileRequest _$UpdateProfileRequestFromJson(
  Map<String, dynamic> json,
) => UpdateProfileRequest(
  userId: json['userId'] as String?,
  displayName: json['displayName'] as String?,
  phoneNumber: json['phoneNumber'] as String?,
  currentPassword: json['currentPassword'] as String?,
  newPassword: json['newPassword'] as String?,
  confirmNewPassword: json['confirmNewPassword'] as String?,
);

Map<String, dynamic> _$UpdateProfileRequestToJson(
  UpdateProfileRequest instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'displayName': instance.displayName,
  'phoneNumber': instance.phoneNumber,
  'currentPassword': instance.currentPassword,
  'newPassword': instance.newPassword,
  'confirmNewPassword': instance.confirmNewPassword,
};
