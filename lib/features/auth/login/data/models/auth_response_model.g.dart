// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthResponseModel _$AuthResponseModelFromJson(Map<String, dynamic> json) =>
    AuthResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      statusCode: (json['statusCode'] as num).toInt(),
      userName: json['userName'] as String?,
      email: json['email'] as String?,
      token: json['token'] as String?,
      expiration: json['expiration'] as String?,
      refreshToken: json['refreshToken'] as String?,
      refreshTokenExpirationDateTime:
          json['refreshTokenExpirationDateTime'] as String?,
    );

Map<String, dynamic> _$AuthResponseModelToJson(AuthResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'statusCode': instance.statusCode,
      'userName': instance.userName,
      'email': instance.email,
      'token': instance.token,
      'expiration': instance.expiration,
      'refreshToken': instance.refreshToken,
      'refreshTokenExpirationDateTime': instance.refreshTokenExpirationDateTime,
    };
