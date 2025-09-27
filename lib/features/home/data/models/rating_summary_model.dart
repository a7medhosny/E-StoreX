import 'package:json_annotation/json_annotation.dart';

part 'rating_summary_model.g.dart';

@JsonSerializable()
class RatingSummaryModel {
  final String productId;
  final double averageScore;
  final int totalRatings;

  final Map<String, int> scoreDistribution;

  RatingSummaryModel({
    required this.productId,
    required this.averageScore,
    required this.totalRatings,
    this.scoreDistribution = const {}, // default empty
  });

  factory RatingSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$RatingSummaryModelFromJson(json);

  Map<String, dynamic> toJson() => _$RatingSummaryModelToJson(this);
}
