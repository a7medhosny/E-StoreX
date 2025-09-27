import 'package:json_annotation/json_annotation.dart';

part 'auth_response_model.g.dart';

@JsonSerializable()
class AuthResponseModel {
  final bool success;
  final String message;
  final int statusCode;
  final String? userName;
  final String? email;
  final String? token;
  final String? expiration;
  final String? refreshToken;
  final String? refreshTokenExpirationDateTime;

  AuthResponseModel({
    required this.success,
    required this.message,
    required this.statusCode,
    this.userName,
    this.email,
    this.token,
    this.expiration,
    this.refreshToken,
    this.refreshTokenExpirationDateTime,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$AuthResponseModelToJson(this);
}
