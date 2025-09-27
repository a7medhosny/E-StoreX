import 'package:dio/dio.dart'; // Make sure this import is present
import 'package:ecommerce/core/networking/estorex_api_service.dart';
import 'package:ecommerce/features/shop/categories/data/models/category_model.dart';
import 'package:ecommerce/features/home/data/models/product_model.dart';
import 'package:ecommerce/features/home/data/models/filtered_products_response.dart';
import 'package:ecommerce/features/home/data/models/rating_request_model.dart';
import 'package:ecommerce/features/home/data/models/rating_response_model.dart';
import 'package:ecommerce/features/home/data/models/rating_summary_model.dart';
// BasketModel is not directly used in HomeRepo, so it can be removed if not needed elsewhere.
// import 'package:ecommerce/features/home/data/models/basket_model.dart';

class HomeRepo {
  final EStoreXApiService apiService;

  HomeRepo({required this.apiService});

  // Helper method to extract a meaningful message from DioException
  String _handleDioError(DioException e, String defaultMessage) {
    String errorMessage = defaultMessage;
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        errorMessage =
            'Connection timed out. Please check your internet connection.';
        break;
      case DioExceptionType.badResponse:
        // Attempt to extract a more specific error message from the response data
        if (e.response != null && e.response!.data != null) {
          // Assuming the error message is in a 'message' field in the response body
          errorMessage =
              e.response!.data['Message']?.toString() ??
              e.response!.statusMessage ??
              defaultMessage;
          // You might also want to log the status code for debugging
          print(
            'API Error - Status Code: ${e.response!.statusCode}, Message: ${e.response!.statusMessage}',
          );
        } else {
          errorMessage =
              'Server error: ${e.response?.statusCode ?? ''} - ${e.response?.statusMessage ?? 'Unknown server issue'}';
        }
        break;
      case DioExceptionType.cancel:
        errorMessage = 'Request to server was cancelled.';
        break;
      case DioExceptionType.connectionError:
        errorMessage =
            'No internet connection or host unreachable. Please try again later.';
        break;
      case DioExceptionType.badCertificate:
        errorMessage = 'SSL certificate error. Please contact support.';
        break;
      case DioExceptionType.unknown:
      default:
        errorMessage = 'An unexpected network error occurred: ${e.message}';
        break;
    }
    print('DioException: ${errorMessage}');
    return errorMessage;
  }

  // Categories
  Future<List<CategoryModel>> getAllCategories() async {
    try {
      return await apiService.getAllCategories();
    } on DioException catch (e) {
      throw Exception(_handleDioError(e, 'Failed to load categories.'));
    } catch (e) {
      throw Exception(
        'An unexpected error occurred while loading categories: ${e.toString()}',
      );
    }
  }

  // Products
  Future<FilteredProductsResponse> getFilteredProducts(
    Map<String, dynamic> filters,
  ) async {
    try {
      return await apiService.getFilteredProducts(filters);
    } on DioException catch (e) {
      // Re-using the centralized error handler
      throw Exception(_handleDioError(e, 'Failed to fetch filtered products.'));
    } catch (e) {
      throw Exception(
        'An unexpected error occurred while fetching filtered products: ${e.toString()}',
      );
    }
  }

  Future<ProductModel> getProductById(String id) async {
    try {
      return await apiService.getProductById(id);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e, 'Failed to fetch product by ID.'));
    } catch (e) {
      throw Exception(
        'An unexpected error occurred while fetching product by ID: ${e.toString()}',
      );
    }
  }


  





  // get all home data
  Future<Map<String, dynamic>> getAllHomeData() async {
    try {
      final products = await getFilteredProducts({}).then((response) {
        return response.data; // Assuming response.data is List<ProductModel>
      });
      final categories = await getAllCategories();
      return {'products': products, 'categories': categories};
    } on DioException catch (e) {
      throw Exception(_handleDioError(e, 'Failed to load home data.'));
    } catch (e) {
      throw Exception(
        'An unexpected error occurred while loading home data: ${e.toString()}',
      );
    }
  }

  Future<List<ProductModel>> getFavorites() async {
    try {
      return await apiService.getFavorites();
    } on DioException catch (e) {
      print('Error fetching favorites: ${e.message}');
      throw Exception(_handleDioError(e, 'Failed to fetch favorites.'));
    } catch (e) {
      throw Exception(
        'An unexpected error occurred while fetching favorites: ${e.toString()}',
      );
    }
  }

  Future<void> addToFavorites(String productId) async {
    try {
      await apiService.addToFavorites(productId);
    } on DioException catch (e) {
      throw Exception(
        _handleDioError(e, 'Failed to add product to favorites.'),
      );
    } catch (e) {
      throw Exception(
        'An unexpected error occurred while adding product to favorites: ${e.toString()}',
      );
    }
  }

  Future<void> removeFromFavorites(String id) async {
    try {
      await apiService.removeFromFavorites(id);
    } on DioException catch (e) {
      throw Exception(
        _handleDioError(e, 'Failed to remove product from favorites.'),
      );
    } catch (e) {
      throw Exception(
        'An unexpected error occurred while removing product from favorites: ${e.toString()}',
      );
    }
  }

  // Ratings
  Future<List<RatingResponseModel>> getRatingsByProductId(
    String productId,
  ) async {
    try {
      return await apiService.getRatingsByProductId(productId);
    } on DioException catch (e) {
      throw Exception(
        _handleDioError(e, 'Failed to fetch ratings for product.'),
      );
    } catch (e) {
      throw Exception(
        'An unexpected error occurred while fetching ratings for product: ${e.toString()}',
      );
    }
  }

  Future<RatingResponseModel> getUserRating(String productId) async {
    try {
      return await apiService.getUserRating(productId);
    } on DioException catch (e) {
      throw Exception(
        _handleDioError(e, 'Failed to fetch user rating for product.'),
      );
    } catch (e) {
      throw Exception(
        'An unexpected error occurred while fetching user rating for product: ${e.toString()}',
      );
    }
  }

  Future<RatingResponseModel> submitRating(RatingRequestModel rating) async {
    try {
      return await apiService.submitRating(rating);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e, 'Failed to submit rating.'));
    } catch (e) {
      throw Exception(
        'An unexpected error occurred while submitting rating: ${e.toString()}',
      );
    }
  }

  Future<RatingResponseModel> updateRatingById(
    String id,
    RatingRequestModel rating,
  ) async {
    try {
      return await apiService.updateRatingById(id, rating);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e, 'Failed to update rating.'));
    } catch (e) {
      throw Exception(
        'An unexpected error occurred while updating rating: ${e.toString()}',
      );
    }
  }

  Future<RatingSummaryModel> getRatingSummary(String productId) async {
    try {
      return await apiService.getRatingSummary(productId);
    } on DioException catch (e) {
      throw Exception(
        _handleDioError(e, 'Failed to fetch rating summary for product.'),
      );
    } catch (e) {
      throw Exception(
        'An unexpected error occurred while fetching rating summary for product: ${e.toString()}',
      );
    }
  }

  Future<void> deleteRatingById(String id) async {
    try {
      await apiService.deleteRatingById(id);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e, 'Failed to delete rating.'));
    } catch (e) {
      throw Exception(
        'An unexpected error occurred while deleting rating: ${e.toString()}',
      );
    }
  }
}
