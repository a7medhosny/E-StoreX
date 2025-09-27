import 'package:dio/dio.dart';
import 'package:ecommerce/features/shop/categories/data/models/category_model.dart';
import 'package:ecommerce/core/networking/estorex_api_service.dart';
import 'package:ecommerce/features/home/data/models/filtered_products_response.dart';

class CategoryRepo {
  final EStoreXApiService apiService;

  CategoryRepo({required this.apiService});

  // Categories
  Future<List<CategoryModel>> getAllCategories() async {
    try {
      return await apiService.getAllCategories();
    }  
    
    catch (e) {
      throw Exception('Failed to load categories]');
    }
  }

  Future<CategoryModel> getCategoryById(String id) async {
    try {
      return await apiService.getCategoryById(id);
    } catch (e) {
      throw Exception('Failed to load category]');
    }
  }

  Future<void> createCategory(Map<String, dynamic> category) async {
    try {
      await apiService.createNewCategory(category);
    } catch (e) {
      throw Exception('Failed to create category]');
    }
  }

  Future<void> updateCategory(String id, Map<String, dynamic> category) async {
    try {
      await apiService.updateCategoryById(id, category);
    } catch (e) {
      throw Exception('Failed to update category]');
    }
  }

  Future<void> deleteCategory(String id) async {
    try {
      await apiService.deleteCategoryById(id);
    } catch (e) {
      throw Exception('Failed to delete category]');
    }
  }

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
