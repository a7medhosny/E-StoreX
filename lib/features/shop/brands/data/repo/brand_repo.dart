import 'package:ecommerce/core/networking/estorex_api_service.dart';
import 'package:ecommerce/features/shop/brands/data/model/brand_response_model.dart';
import 'package:ecommerce/features/home/data/models/filtered_products_response.dart';

class BrandRepo {
  final EStoreXApiService apiService;
  BrandRepo({required this.apiService});
  Future<List<BrandResponseModel>> getAllBrands() async {
    try {
      final response = await apiService.getAllBrands();
      return response;
    } catch (e) {
      print("Error fetching brands: $e");
      throw Exception('Failed to load brands try again later');
    }
  }

  Future<FilteredProductsResponse> getProductsByBrandName(
    String brandName,
    int pageNumber,
    int pageSize,
  ) async {
    try {
      return await apiService.getFilteredProducts({
        'SearchBy': 'brand',
        'SearchString': brandName,
        'PageNumber': pageNumber,
        'PageSize': pageSize,
      });
    } catch (e) {
      throw Exception(
        'An unexpected error occurred while fetching filtered products: ${e.toString()}',
      );
    }
  }
}
