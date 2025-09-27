import 'package:json_annotation/json_annotation.dart';
import 'product_model.dart';

part 'filtered_products_response.g.dart';

@JsonSerializable()
class FilteredProductsResponse {
  final int pageNumber;
  final int pageSize;
  final int totalCount;
  final List<ProductModel> data;

  FilteredProductsResponse({
    required this.pageNumber,
    required this.pageSize,
    required this.totalCount,
    required this.data,
  });

  factory FilteredProductsResponse.fromJson(Map<String, dynamic> json) =>
      _$FilteredProductsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FilteredProductsResponseToJson(this);
}
