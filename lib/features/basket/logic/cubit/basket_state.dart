part of 'basket_cubit.dart';

@immutable
sealed class BasketState {}

final class BasketInitial extends BasketState {}

/// States for loading the entire basket
final class BasketLoading extends BasketState {}

final class BasketLoaded extends BasketState {
  final BasketResponseModel basketModel;
  BasketLoaded({required this.basketModel});
}

final class BasketError extends BasketState {
  final String message;
  BasketError({required this.message});
}

/// States for individual item operations (add, remove, update quantity)
final class BasketItemOperationLoading extends BasketState {}

final class BasketItemAddedSuccess extends BasketState {
  final String message; // Optional: "Item added successfully"
  BasketItemAddedSuccess({this.message = 'Item added to basket!'});
}

final class BasketItemAddedError extends BasketState {
  final String message;
  BasketItemAddedError({this.message = 'Item already added!'});
}

final class BasketItemRemovedSuccess extends BasketState {
  final String message; // Optional: "Item removed successfully"
  BasketItemRemovedSuccess({this.message = 'Item removed from basket!'});
}

final class BasketItemRemovedError extends BasketState {
  final String message;
  BasketItemRemovedError({required this.message});
}

final class BasketItemQuantityUpdatedSuccess extends BasketState {
  final String message; // Optional: "Quantity updated successfully"
  BasketItemQuantityUpdatedSuccess({this.message = 'Item quantity updated!'});
}

final class BasketItemOperationError extends BasketState {
  final String message;
  BasketItemOperationError({required this.message});
}

final class DiscountValidated extends BasketState {
  final String message;
  DiscountValidated({this.message = 'Discount applied!'});
}

final class ApplyDiscountCodeError extends BasketState {
  final String message;
  ApplyDiscountCodeError({required this.message});
}

final class ApplyDiscountCodeLoading extends BasketState {}
