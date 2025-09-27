// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brand_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BrandResponseModel _$BrandResponseModelFromJson(Map<String, dynamic> json) =>
    BrandResponseModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      photos:
          (json['photos'] as List<dynamic>?)
              ?.map((e) => PhotoModel.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$BrandResponseModelToJson(BrandResponseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'photos': instance.photos,
    };
