import 'package:json_annotation/json_annotation.dart';

part 'register_request_model.g.dart';

@JsonSerializable()
class RegisterRequestModel {
  final String userName;
  final String email;
  final String phone;
  final String password;
  final String confirmPassword;

  RegisterRequestModel({
    required this.userName,
    required this.email,
    required this.phone,
    required this.password,
    required this.confirmPassword,
  });

  factory RegisterRequestModel.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestModelFromJson(json);
  Map<String, dynamic> toJson() => _$RegisterRequestModelToJson(this);
}
