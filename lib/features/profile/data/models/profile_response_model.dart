import 'package:json_annotation/json_annotation.dart';

part 'profile_response_model.g.dart';

@JsonSerializable()
class ProfileResponseModel {
  final String? id;
  final String? userName;
  final String? email;
  final String? displayName;
  final bool? isActive;
  final String? phoneNumber;
  final List<String>? roles;
  final String? photoUrl;

  ProfileResponseModel({
    this.id,
    this.userName,
    this.email,
    this.displayName,
    this.isActive,
    this.phoneNumber,
    this.roles,
    this.photoUrl,
  });

  factory ProfileResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileResponseModelToJson(this);
}
