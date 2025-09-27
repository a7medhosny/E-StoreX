import 'package:dio/dio.dart';
import 'package:ecommerce/core/helpers/stripe_payment_service.dart';
import 'package:ecommerce/core/networking/estorex_api_service.dart';
import 'package:ecommerce/features/order/data/models/delivery_option.dart';
import 'package:ecommerce/features/order/data/models/order_request_model.dart';
import 'package:ecommerce/features/order/data/models/order_response_model.dart';
import 'package:ecommerce/features/order/data/models/payment_response.dart';

class OrderRepo {
  final EStoreXApiService apiService;

  OrderRepo({required this.apiService});

  Future<PaymentResponse> getPaymentIntentData({
    required String basketId,
    required String deliveryMethodId,
  }) async {
    try {
      PaymentResponse paymentResponse = await apiService.getPaymentIntentData(
        basketId,
        deliveryMethodId,
      );
      return paymentResponse;
    } on DioException catch (e) {
      throw Exception(_handleDioError(e, 'Cant get payment data'));
    } catch (e) {
      throw Exception('Unexpected error occurred while getting payment data.');
    }
  }

  Future<List<DeliveryOption>> getDeliveryMethods() async {
    try {
      final response = await apiService.getDeliveryMethods();
      return response;
    } on DioException catch (e) {
      throw Exception(_handleDioError(e, 'Error getting delivery methods'));
    } catch (e) {
      throw Exception(
        'Unexpected error occurred while getting delivery methods.',
      );
    }
  }

  Future<OrderResponseModel> createOrder({
    required OrderRequestModel orderRequest,
  }) async {
    try {
      final response = await apiService.createOrder(orderRequest);
      return response;
    } on DioException catch (e) {
      throw Exception(_handleDioError(e, 'Error creating order'));
    } catch (e) {
      throw Exception('Unexpected error occurred while creating order.');
    }
  }

  Future<List<OrderResponseModel>> getOrders() async {
    try {
      final response = await apiService.getOrders();
      return response;
    } on DioException catch (e) {
      throw Exception(_handleDioError(e, 'Error getting orders'));
    } catch (e) {
      throw Exception('Unexpected error occurred while getting orders.');
    }
  }

Future<OrderResponseModel> getOrderById({required String orderId}) async {
    try {
      final response = await apiService.getOrderById(orderId);
      return response;
    } on DioException catch (e) {
      throw Exception(_handleDioError(e, 'Error getting order details'));
    } catch (e) {
      throw Exception('Unexpected error occurred while getting order details.');
    }
  }

  Future<void> makePayment({required PaymentResponse paymentResponse}) async {
    return StripePaymentService.makePayment(paymentResponse: paymentResponse);
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
