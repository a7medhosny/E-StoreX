import 'package:json_annotation/json_annotation.dart';

part 'error_response_model.g.dart';

@JsonSerializable()
class ErrorResponseModel {
  final bool success;
  final String message;
  final int statusCode;

  // @JsonKey(fromJson: _errorsFromJson)
  final List<String>? errors;

  ErrorResponseModel({
    required this.success,
    required this.message,
    required this.statusCode,
    this.errors,
  });

  factory ErrorResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ErrorResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorResponseModelToJson(this);

  static List<String>? _errorsFromJson(dynamic errors) {
    if (errors is List) {
      return errors.map((e) => e.toString()).toList();
    }
    return null;
  }
}
