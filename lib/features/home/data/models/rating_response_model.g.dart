// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rating_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RatingResponseModel _$RatingResponseModelFromJson(Map<String, dynamic> json) =>
    RatingResponseModel(
      id: json['id'] as String,
      score: (json['score'] as num).toInt(),
      comment: json['comment'] as String,
      productId: json['productId'] as String,
      userName: json['userName'] as String,
    );

Map<String, dynamic> _$RatingResponseModelToJson(
  RatingResponseModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'score': instance.score,
  'comment': instance.comment,
  'productId': instance.productId,
  'userName': instance.userName,
};
