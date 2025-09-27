import 'package:dio/dio.dart';
import 'package:ecommerce/core/networking/estorex_api_service.dart';
import 'package:ecommerce/features/home/data/models/filtered_products_response.dart';

class SearchRepo {
  final EStoreXApiService apiService;

  SearchRepo({required this.apiService});
  
 Future<FilteredProductsResponse> getFilteredProducts(
    Map<String, dynamic> filters,
  ) async {
    try {
      return await apiService.getFilteredProducts(filters);
    } on DioException catch (e) {
      print("DioException: ${e.message}");
      if (e.type == DioExceptionType.badResponse) {
        throw Exception(
          'Failed to fetch filtered products: ${e.response?.data}',
        );
      } else {
        throw Exception('Failed to fetch filtered products: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to fetch filtered products');
    }
  }

  
}