import 'package:dio/dio.dart'; // Add this import for DioException
import 'package:ecommerce/core/helpers/token_manager.dart';
import 'package:ecommerce/core/networking/estorex_api_service.dart';
import 'package:ecommerce/features/auth/login/data/models/auth_response_model.dart';
import 'package:ecommerce/features/basket/data/models/basket_item_model.dart';
import 'package:ecommerce/features/basket/data/models/basket_request_model.dart';
import 'package:ecommerce/features/basket/data/models/basket_response_model.dart';

class BasketRepo {
  final EStoreXApiService apiService;

  BasketRepo({required this.apiService});

  Future<BasketResponseModel> getBasketByCustomerId() async {
    String id = TokenManager.userId ?? TokenManager.guestId!;
    print('UserId $id');
    try {
      BasketResponseModel? basketModel = await apiService.getBasketByCustomerId(
        id,
      );
      basketModel ??= BasketResponseModel(
        id: id,
        basketItems: [],
        discountValue: null,
        percentage: null,
        total: null,
      );
      return basketModel;
    } on DioException catch (e) {
      // Handle Dio-specific errors
      throw Exception(_handleDioError(e, 'Failed to load basket'));
    } catch (e) {
      print('Error: ${e.toString()}');
      // Handle any other unexpected errors
      throw Exception('An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<void> addOrUpdateCustomerBasket(BasketRequestModel basket) async {
    try {
      await apiService.addOrUpdateCustomerBasket(basket);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e, 'Failed to add/update basket'));
    } catch (e) {
      throw Exception('An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<void> deleteBasketByCustomerId(String id) async {
    try {
      await apiService.deleteBasketByCustomerId(id);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e, 'Failed to delete basket'));
    } catch (e) {
      throw Exception('An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<void> deleteItemFromBasketByProductId({
    required String basketId,
    required String productId,
  }) async {
    try {
      await apiService.deleteItemFromBasketByProductId(basketId, productId);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e, 'Failed to delete item from basket'));
    } catch (e) {
      throw Exception('An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<BasketResponseModel> increaseBasketItem({
    required String basketId,
    required String productId,
  }) async {
    try {
      return await apiService.increaseBasketItem(basketId, productId);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e, 'Failed to increase basket item'));
    } catch (e) {
      throw Exception('An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<BasketResponseModel> decreaseBasketItem({
    required String basketId,
    required String productId,
  }) async {
    try {
      return await apiService.decreaseBasketItem(basketId, productId);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e, 'Failed to decrease basket item'));
    } catch (e) {
      throw Exception('An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<AuthResponseModel> validateDiscount(String code) async {
    try {
      return await apiService.validateDiscount(code);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e, 'Failed to validate discount code'));
    } catch (e) {
      throw Exception('An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<BasketResponseModel> applyDiscount({
    required String basketId,
    required String code,
  }) async {
    try {
      return await apiService.applyDiscount(basketId, code);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e, 'Failed to apply discount code'));
    } catch (e) {
      throw Exception('An unexpected error occurred: ${e.toString()}');
    }
  }
  Future<BasketResponseModel>mergeBasketWithGuestBasket({required String guestId})async{
 try {
      return await apiService.mergeBasketWithGuestBasket(guestId);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e, 'Failed to merge basket'));
    } catch (e) {
      throw Exception('An unexpected error occurred: ${e.toString()}');
    }
  }

  // Helper method to extract a meaningful message from DioException
  String _handleDioError(DioException e, String defaultMessage) {
    print('Status code: ${e.response?.statusCode}');
    print('error message: ${e.message}');
    String errorMessage = defaultMessage;
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        errorMessage =
            'Connection timed out. Please check your internet connection.';
        break;
      case DioExceptionType.badResponse:
        // This means the server responded with a status code other than 2xx
        if (e.response != null && e.response!.data != null) {
          // Try to parse error message from response data if available
          errorMessage =
              e.response!.data['message']?.toString() ??
              e.response!.statusMessage ??
              errorMessage;
          // You might also want to log the status code for debugging
          print(
            'API Error - Status Code: ${e.response!.statusCode}, Message: ${e.response!.statusMessage}',
          );
        } else {
          errorMessage =
              'Server error: ${e.response?.statusCode ?? ''} - ${e.response?.statusMessage ?? ''}';
        }
        break;
      case DioExceptionType.cancel:
        errorMessage = 'Request to server was cancelled.';
        break;
      case DioExceptionType.connectionError:
        errorMessage = 'No internet connection or host unreachable.';
        break;
      case DioExceptionType.badCertificate:
        errorMessage = 'Bad SSL certificate.';
        break;
      case DioExceptionType.unknown:
      default:
        errorMessage = 'An unknown error occurred: ${e.message}';
        break;
    }
    return errorMessage;
  }
}
