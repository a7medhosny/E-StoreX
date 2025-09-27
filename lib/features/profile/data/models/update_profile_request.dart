import 'package:json_annotation/json_annotation.dart';

part 'update_profile_request.g.dart';

@JsonSerializable()
class UpdateProfileRequest {
  final String? userId;
  final String? displayName;
  final String? phoneNumber;
  final String? currentPassword;
  final String? newPassword;
  final String? confirmNewPassword;

  UpdateProfileRequest({
    this.userId,
    this.displayName,
    this.phoneNumber,
    this.currentPassword,
    this.newPassword,
    this.confirmNewPassword,
  });

  factory UpdateProfileRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateProfileRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateProfileRequestToJson(this);
}
