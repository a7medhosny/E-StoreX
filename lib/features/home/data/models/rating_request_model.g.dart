// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rating_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RatingRequestModel _$RatingRequestModelFromJson(Map<String, dynamic> json) =>
    RatingRequestModel(
      productId: json['productId'] as String,
      score: (json['score'] as num).toInt(),
      comment: json['comment'] as String,
    );

Map<String, dynamic> _$RatingRequestModelToJson(RatingRequestModel instance) =>
    <String, dynamic>{
      'score': instance.score,
      'comment': instance.comment,
      'productId': instance.productId,
    };
