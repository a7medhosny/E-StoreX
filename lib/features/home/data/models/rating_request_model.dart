import 'package:json_annotation/json_annotation.dart';

part 'rating_request_model.g.dart';

@JsonSerializable()
class RatingRequestModel {
  final int score;
  final String comment;
  final String productId;

  RatingRequestModel({
    required this.productId,
    required this.score,
    required this.comment,});

  factory RatingRequestModel.fromJson(Map<String, dynamic> json) =>
      _$RatingRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$RatingRequestModelToJson(this);
}
