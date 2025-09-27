// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) => ProductModel(
  id: json['id'] as String?,
  name: json['name'] as String?,
  description: json['description'] as String?,
  newPrice: (json['newPrice'] as num?)?.toDouble(),
  oldPrice: (json['oldPrice'] as num?)?.toDouble(),
  categoryName: json['categoryName'] as String?,
  photos:
      (json['photos'] as List<dynamic>?)
          ?.map((e) => PhotoModel.fromJson(e as Map<String, dynamic>))
          .toList(),
  quantityAvailable: (json['quantityAvailable'] as num?)?.toInt(),
  brandName: json['brandName'] as String?,
);

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'newPrice': instance.newPrice,
      'oldPrice': instance.oldPrice,
      'categoryName': instance.categoryName,
      'quantityAvailable': instance.quantityAvailable,
      'brandName': instance.brandName,
      'photos': instance.photos,
    };

PhotoModel _$PhotoModelFromJson(Map<String, dynamic> json) =>
    PhotoModel(imageName: json['imageName'] as String);

Map<String, dynamic> _$PhotoModelToJson(PhotoModel instance) =>
    <String, dynamic>{'imageName': instance.imageName};
