// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rating_summary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RatingSummaryModel _$RatingSummaryModelFromJson(Map<String, dynamic> json) =>
    RatingSummaryModel(
      productId: json['productId'] as String,
      averageScore: (json['averageScore'] as num).toDouble(),
      totalRatings: (json['totalRatings'] as num).toInt(),
      scoreDistribution:
          (json['scoreDistribution'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toInt()),
          ) ??
          const {},
    );

Map<String, dynamic> _$RatingSummaryModelToJson(RatingSummaryModel instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'averageScore': instance.averageScore,
      'totalRatings': instance.totalRatings,
      'scoreDistribution': instance.scoreDistribution,
    };
