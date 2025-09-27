// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterRequestModel _$RegisterRequestModelFromJson(
  Map<String, dynamic> json,
) => RegisterRequestModel(
  userName: json['userName'] as String,
  email: json['email'] as String,
  phone: json['phone'] as String,
  password: json['password'] as String,
  confirmPassword: json['confirmPassword'] as String,
);

Map<String, dynamic> _$RegisterRequestModelToJson(
  RegisterRequestModel instance,
) => <String, dynamic>{
  'userName': instance.userName,
  'email': instance.email,
  'phone': instance.phone,
  'password': instance.password,
  'confirmPassword': instance.confirmPassword,
};
