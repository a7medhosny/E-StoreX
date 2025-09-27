import 'package:ecommerce/features/home/data/models/product_model.dart';
import 'package:json_annotation/json_annotation.dart';
part 'brand_response_model.g.dart';

@JsonSerializable()
class BrandResponseModel {
  final String? id;
  final String? name;
    final List<PhotoModel>? photos;


  BrandResponseModel({
    required this.id,
    required this.name,
    required this.photos
  });

  factory BrandResponseModel.fromJson(Map<String, dynamic> json) => _$BrandResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$BrandResponseModelToJson(this);
}
