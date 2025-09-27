// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filtered_products_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FilteredProductsResponse _$FilteredProductsResponseFromJson(
  Map<String, dynamic> json,
) => FilteredProductsResponse(
  pageNumber: (json['pageNumber'] as num).toInt(),
  pageSize: (json['pageSize'] as num).toInt(),
  totalCount: (json['totalCount'] as num).toInt(),
  data:
      (json['data'] as List<dynamic>)
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$FilteredProductsResponseToJson(
  FilteredProductsResponse instance,
) => <String, dynamic>{
  'pageNumber': instance.pageNumber,
  'pageSize': instance.pageSize,
  'totalCount': instance.totalCount,
  'data': instance.data,
};
