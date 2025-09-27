part of 'order_cubit.dart';

@immutable
sealed class OrderState {}

final class OrderInitial extends OrderState {}

// Get Payment Intent
final class GetPaymentIntentDataLoading extends OrderState {}

final class GetPaymentIntentDataSuccess extends OrderState {
  final PaymentResponse paymentResponse;

  GetPaymentIntentDataSuccess({required this.paymentResponse});
}

final class GetPaymentIntentDataError extends OrderState {
  final String error;

  GetPaymentIntentDataError({required this.error});
}

// Get Delivery Methods
final class GetDeliveryMethodsLoading extends OrderState {}

final class GetDeliveryMethodsSuccess extends OrderState {
  final List<DeliveryOption> deliveryOptions;

  GetDeliveryMethodsSuccess({required this.deliveryOptions});
}

final class GetDeliveryMethodsError extends OrderState {
  final String error;

  GetDeliveryMethodsError({required this.error});
}

// Create Order
final class CreateOrderLoading extends OrderState {}
final class CreateOrderSuccess extends OrderState {}
final class CreateOrderError extends OrderState {
  final String error;

  CreateOrderError({required this.error});
}

// Get Orders
final class GetOrdersLoading extends OrderState {}
final class GetOrdersSuccess extends OrderState {
  final List<OrderResponseModel>? orders;
  GetOrdersSuccess({this.orders});
}
final class GetOrdersError extends OrderState {
  final String error;
  GetOrdersError({required this.error});
}

//Get Order By Id
final class GetOrderByIdLoading extends OrderState {}
final class GetOrderByIdSuccess extends OrderState {
  final OrderResponseModel order;
  GetOrderByIdSuccess({required this.order});
}
final class GetOrderByIdError extends OrderState {
  final String error;
  GetOrderByIdError({required this.error});
}

// Make Payment
final class MakePaymentLoading extends OrderState {}

final class MakePaymentSuccess extends OrderState {}

final class MakePaymentError extends OrderState {
  final String error;

  MakePaymentError({required this.error});
}