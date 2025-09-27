 
 import 'package:json_annotation/json_annotation.dart';

part 'rating_response_model.g.dart';

@JsonSerializable()
 class RatingResponseModel {
   final String id;
   final int score;
   final String comment;
   final String productId;
   final String userName;


   RatingResponseModel({
     required this.id,
     required this.score,
     required this.comment,
     required this.productId,
     required this.userName,
   });

   factory RatingResponseModel.fromJson(Map<String, dynamic> json) =>
       _$RatingResponseModelFromJson(json);

   Map<String, dynamic> toJson() => _$RatingResponseModelToJson(this);
 }