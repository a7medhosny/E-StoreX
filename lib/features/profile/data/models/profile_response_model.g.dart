// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileResponseModel _$ProfileResponseModelFromJson(
  Map<String, dynamic> json,
) => ProfileResponseModel(
  id: json['id'] as String?,
  userName: json['userName'] as String?,
  email: json['email'] as String?,
  displayName: json['displayName'] as String?,
  isActive: json['isActive'] as bool?,
  phoneNumber: json['phoneNumber'] as String?,
  roles: (json['roles'] as List<dynamic>?)?.map((e) => e as String).toList(),
  photoUrl: json['photoUrl'] as String?,
);

Map<String, dynamic> _$ProfileResponseModelToJson(
  ProfileResponseModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'userName': instance.userName,
  'email': instance.email,
  'displayName': instance.displayName,
  'isActive': instance.isActive,
  'phoneNumber': instance.phoneNumber,
  'roles': instance.roles,
  'photoUrl': instance.photoUrl,
};
