import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:ecommerce/features/order/data/models/delivery_option.dart';
import 'package:ecommerce/features/order/data/models/order_request_model.dart';
import 'package:ecommerce/features/order/data/models/order_response_model.dart';
import 'package:ecommerce/features/order/data/models/payment_response.dart';
import 'package:ecommerce/features/order/data/repo/order_repo.dart';
import 'package:meta/meta.dart';

part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit(this.orderRepo) : super(OrderInitial());
  final OrderRepo orderRepo;

  Future<void> getPaymentIntentData({
    required String basketId,
    required String deliveryMethodId,
  }) async {
    emit(GetPaymentIntentDataLoading());
    try {
      final response = await orderRepo.getPaymentIntentData(
        basketId: basketId,
        deliveryMethodId: deliveryMethodId,
      );
      emit(GetPaymentIntentDataSuccess(paymentResponse: response));
    } catch (e) {
      emit(GetPaymentIntentDataError(error: e.toString()));
    }
  }

  Future<void> getDeliveryMethods() async {
    emit(GetDeliveryMethodsLoading());
    try {
      final deliveryOptions = await orderRepo.getDeliveryMethods();
      emit(GetDeliveryMethodsSuccess(deliveryOptions: deliveryOptions));
    } catch (e) {
      emit(GetDeliveryMethodsError(error: e.toString()));
    }
  }

  Future<void> createOrder({
    required String deliveryMethodId,
    required String basketId,
    required shippingAddress,
  }) async {
    emit(CreateOrderLoading());
    try {
      print('creating order...');
      await orderRepo.createOrder(
        orderRequest: OrderRequestModel(
          deliveryMethodId: deliveryMethodId,
          basketId: basketId,
          shippingAddress: shippingAddress,
        ),
      );
      emit(CreateOrderSuccess());
    } catch (e) {
      emit(CreateOrderError(error: e.toString()));
    }
  }

  Future<void> getOrders() async {
    emit(GetOrdersLoading());
    try {
      final List<OrderResponseModel> response = await orderRepo.getOrders();
      emit(GetOrdersSuccess(orders: response));
    } catch (e) {
      emit(GetOrdersError(error: e.toString()));
    }
  }

  Future<void> getOrderById({required String orderId}) async {
    emit(GetOrderByIdLoading());
    try {
      final OrderResponseModel response = await orderRepo.getOrderById(
        orderId: orderId,
      );
      emit(GetOrderByIdSuccess(order: response));
    } catch (e) {
      emit(GetOrderByIdError(error: e.toString()));
    }
  }

  Future<void> makePayment({required PaymentResponse paymentResponse}) async {
    emit(MakePaymentLoading());
    try {
      await orderRepo.makePayment(paymentResponse: paymentResponse);
      emit(MakePaymentSuccess());
    } catch (e) {
      emit(MakePaymentError(error: e.toString()));
    }
  }
}
